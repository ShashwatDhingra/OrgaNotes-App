import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:organotes/data/response/response.dart';
import 'package:organotes/repository/notes_repository.dart';
import 'package:organotes/utils/notification_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:organotes/model/notes.dart';
import 'package:organotes/utils/helper.dart';
import 'package:path_provider/path_provider.dart';

class NoteEditViewModel extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  String userName = '';
  String userMail = '';

  final DBHelper _dbHelper = DBHelper();
  final PrefHelper _prefHelper = PrefHelper();
  final NotificationHandler notificationHandler = NotificationHandler();
  final NotesRepository _notesRepository = NotesRepository();

  bool? isNewNoteBackupEnabled;
  bool? isExistingNoteBackupEnabled;

  // Controllers for Quills
  final quill.QuillController titleController = quill.QuillController.basic();

  final quill.QuillController descController = quill.QuillController.basic();

  NoteEditViewModel() {
    getUserData();
  }

  Future<void> getUserData() async {
    final jwtToken = await _prefHelper.getString(PrefHelper.TOKEN);
    final payload = JWT.decode(jwtToken!);
    userName = payload.payload['username'];
    userMail = payload.payload['email'];
    notifyListeners();
  }

  void setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  Future<bool> saveNote() async {
    setLoading(true);
    try {
      final id = generateNoteId();
      final titleJson = jsonEncode(titleController.document.toDelta().toJson());
      final descJson = jsonEncode(descController.document.toDelta().toJson());
      final title = titleController.document.toPlainText().trim();
      final desc = descController.document.toPlainText().trim();

      final newNote = Note(
          id: id,
          deltaTitle: titleJson,
          deltaDesc: descJson,
          title: title,
          desc: desc,
          created: DateTime.now(),
          lastModified: DateTime.now(),
          isBackup: isNewNoteBackupEnabled!);

      await _dbHelper.insert(newNote);

      // backup note
      if (newNote.isBackup) {
        final ApiResponse response = await addNoteBackup(newNote);
        if (!response.status) {
          print(response.message);
          newNote.isBackup = false;
          _dbHelper.update(newNote);
        }
        return response.status;
      }

      setLoading(false);
      return true;
    } catch (e) {
      setLoading(false);
      print(e);
      return false;
    }
  }

  Future<bool> updateNote(Note note) async {
    setLoading(true);

    final isBackupToogled = (note.isBackup != isExistingNoteBackupEnabled!);
    final previousIsBackupValue = note.isBackup;
    try {
      note.deltaTitle = jsonEncode(titleController.document.toDelta().toJson());
      note.deltaDesc = jsonEncode(descController.document.toDelta().toJson());
      note.title = titleController.document.toPlainText().trim();
      note.desc = descController.document.toPlainText().trim();
      note.lastModified = DateTime.now();
      note.isBackup = isExistingNoteBackupEnabled!;

      if(previousIsBackupValue){
        final ApiResponse response = await updateNoteBackup(note);

        if (!response.status) {
            print(response.message);
            return false;
          }
      }

      await _dbHelper.update(note);

      // backup note
      if (isBackupToogled) {
        if (isExistingNoteBackupEnabled!) {
          final ApiResponse response = await addNoteBackup(note);

          if (!response.status) {
            print(response.message);
            note.isBackup = !isExistingNoteBackupEnabled!;
            _dbHelper.update(note);
          }
          return response.status;
        } else {
          final ApiResponse response = await deleteNoteBackup(note);

          if (!response.status) {
            print(response.message);
            note.isBackup = !isExistingNoteBackupEnabled!;
            _dbHelper.update(note);
          }
          return response.status;
        }
      }
      setLoading(false);
      return true;
    } catch (e) {
      setLoading(false);
      print(e);
      return false;
    }
  }

  Future<String?> downloadNote(String title, String description) async {
    final dir = await getExternalStorageDirectory();
    if (dir == null) {
      return 'Error: Error while downloading the Note';
    }
    // // getting the download path
    String newPath = '';
    final folders = dir.path.split('/');
    for (int x = 1; x < folders.length; x++) {
      String folder = folders[x];
      if (folder != 'Android') {
        newPath += '/$folder';
      } else {
        break;
      }
    }

    // Finding Document/Documents path
    Directory documentDir = Directory('$newPath/Document');
    Directory documentsDir = Directory('$newPath/Documents');
    bool dirExists = await documentDir.exists();
    if (dirExists) {
      try {
        final saveNoteFileRes =
            await saveNoteFile(title, description, '$newPath/Document');
        if (!saveNoteFileRes) {
          return 'Error: Error while downloading the Note';
        } else {
          notificationHandler.showNotification(
              'Note Saved Successfully', 'Your Note saved in Document folder');
          return null;
        }
      } catch (e) {
        return 'Error: Error while downloading the Note';
      }
    }

    dirExists = await documentsDir.exists();

    if (dirExists) {
      try {
        final saveNoteFileRes =
            await saveNoteFile(title, description, '$newPath/Documents');
        if (!saveNoteFileRes) {
          return 'Error: Error while downloading the Note';
        } else {
          notificationHandler.showNotification(
              'Note Saved Successfully', 'Your Note saved in Document folder');
          return null;
        }
      } catch (e) {
        return 'Error: Error while downloading the Note';
      }
    }
    return 'Please create a Document Directory in Storage';
  }

  Future<bool> saveNoteFile(
      String title, String description, String path) async {
    final pdfBytes = await generatePdf(title, description);

    File newfile = File('$path/${title.toString()}.pdf');
    try {
      newfile.writeAsBytes(pdfBytes);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<Uint8List> generatePdf(String title, String desc) async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(title,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 12),
                pw.Text(desc)
              ]);
        }));

    return await pdf.save();
  }

  int generateNoteId() {
    // Get the current timestamp (milliseconds since epoch)
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    // Use Random class to generate a random number
    Random random = Random(timestamp);
    return random.nextInt(9000000) + 1000000;
  }

  bool getBackupSetting() {
    return _prefHelper.getBool(PrefHelper.IS_BACKUP_ENABLED) ?? false;
  }

  void toogleIsNewNoteBackupEnabled() {
    isNewNoteBackupEnabled = !isNewNoteBackupEnabled!;
    notifyListeners();
  }

  void toogleIsExistingNoteBackupEnabled() {
    isExistingNoteBackupEnabled = !isExistingNoteBackupEnabled!;
    notifyListeners();
  }

  Future<ApiResponse> addNoteBackup(Note note) async {
    setLoading(true);
    dynamic response;
    try {
      response = await _notesRepository
          .addNote({"email": userMail, "note": note.toJson()});
    } catch (e) {
      setLoading(false);
      return ApiResponse(response['status'], response['message']);
    }
    setLoading(false);
    return ApiResponse(response['status'], response['message']);
  }

  Future<ApiResponse> deleteNoteBackup(Note note) async {
    setLoading(true);
    dynamic response;
    try {
      response = await _notesRepository
          .deleteNotes({"email": userMail, "note_id": note.id});
    } catch (e) {
      setLoading(false);
      return ApiResponse(response['status'], response['message']);
    }
    setLoading(false);
    return ApiResponse(response['status'], response['message']);
  }

  Future<ApiResponse> updateNoteBackup(Note note) async {
    setLoading(true);
    dynamic response;
    try {
      response = await _notesRepository
          .updateNote({"email": userMail, "note_id": note.id, "note": note,});
    } catch (e) {
      setLoading(false);
      return ApiResponse(response['status'], response['message']);
    }
    setLoading(false);
    return ApiResponse(response['status'], response['message']);
  }
}
