import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:organotes/data/response/response.dart';
import 'package:organotes/model/notes.dart';
import 'package:organotes/repository/notes_repository.dart';
import 'package:organotes/ui/resuables/my_text_button.dart';
import 'package:organotes/utils/helper.dart';
import 'package:jsonwebtoken_decode/jsonwebtoken_decode.dart';
import 'package:organotes/utils/utils.dart';

class HomeViewModel extends ChangeNotifier {
  PrefHelper _prefHelper = PrefHelper();
  DBHelper _dbHelper = DBHelper();
  List<Note> notes = [];
  bool _loading = false;
  String userName = '';
  String userMail = '';
  bool isBackupEnabled = false;
  final NotesRepository _notesRepository = NotesRepository();

  bool get loading => _loading;

  HomeViewModel() {
    // Initialize user data and backup setting when creating the HomeViewModel
    getUserData();
    initBackupSetting();
  }

  void setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  Future<void> getUserData() async {
    final jwtToken = await _prefHelper.getString(PrefHelper.TOKEN);
    final payload = JWT.decode(jwtToken!);
    userName = payload.payload['username'];
    userMail = payload.payload['email'];
    notifyListeners();
  }

  Future<bool> logout() async {
    setLoading(true);
    final val = await _prefHelper
        .setString(PrefHelper.TOKEN, '')
        .timeout(const Duration(seconds: 10));
    if (val) {
      await Future.delayed(const Duration(seconds: 2));
      _dbHelper.clear();
    }
    setLoading(false);
    return val;
  }

  Future<void> getNotes() async {
    setLoading(true);
    notes = await _dbHelper.get();
    notifyListeners();
    setLoading(false);
  }

  Future<void> deleteNote(noteId) async {
    final isDeleted = await _dbHelper.delete(noteId);
    if (isDeleted) {
      notes = await _dbHelper.get();
      notifyListeners();
    }
  }

  Future<void> initBackupSetting() async {
    isBackupEnabled =
        await _prefHelper.getBool(PrefHelper.IS_BACKUP_ENABLED) ?? false;
    notifyListeners();
  }

  void changeBackupOptionValue(bool value) async {
    await _prefHelper.setBool(PrefHelper.IS_BACKUP_ENABLED, value);
    isBackupEnabled = value;
    notifyListeners();
  }

  Future<void> checkNotes(String email, BuildContext context) async {
    dynamic response;
    setLoading(true);
    try {
      response = await _notesRepository.getNotes({"email": email});
    } catch (e) {
      setLoading(false);
    }
    setLoading(false);
    if (response['status']) {
      final notesList = response['notes'] as List;
      if (notesList.isNotEmpty) {
        showImportNotesDialog(context, notesList);
      }else{
        Utils.showToast("You don't have notes backed-up on cloud", true, context);
      }
    }
  }

  Future<void> showImportNotesDialog(
      BuildContext context, List notesJson) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                  'You\'ve Notes on cloud. Do you want to import them ?'),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: loading
                      ? const SpinKitFadingCircle(
                          color: Colors.black,
                        )
                      : MyTextButton(
                          text: 'Yes',
                          onPress: () async {
                            await importNotes(notesJson);
                            Navigator.pop(context);
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTextButton(
                    text: 'No',
                    onPress: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ));
  }

  Future<void> importNotes(List notesJson) async {
    setLoading(true);
    print(notesJson);
    List<Note> notes = notesJson.map((note) => Note.fromJson(note)).toList();
    notes.forEach((note) {
      _dbHelper.insert(note);
    });
    setLoading(false);
    await getNotes();
  }
}
