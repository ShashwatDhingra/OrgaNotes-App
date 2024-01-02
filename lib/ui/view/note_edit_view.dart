import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:organotes/model/notes.dart';
import 'package:organotes/ui/resuables/my_button.dart';
import 'package:organotes/ui/resuables/my_text_button.dart';
import 'package:organotes/ui/view_model/home_view_model.dart';
import 'package:organotes/ui/view_model/note_edit_view_model.dart';
import 'package:organotes/utils/screen_size.dart';
import 'package:organotes/utils/utils.dart';
import 'package:provider/provider.dart';

class NoteEditView extends StatefulWidget {
  NoteEditView({super.key, required this.isEditing, this.note});

  final bool isEditing;
  final Note? note;

  @override
  State<NoteEditView> createState() => _NoteEditViewState();
}

class _NoteEditViewState extends State<NoteEditView> {
  final scHeight = ScreenSize.screenHeight;

  final scWidth = ScreenSize.screenWidth;

  late HomeViewModel homeProvider;

  void downloadNote() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                  'Only Text will be shown in pdf. Want to download ?'),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTextButton(
                    onPress: () {
                      Navigator.pop(context);
                    },
                    text: 'No',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTextButton(
                    onPress: () async {
                      final noteEditViewModel = Provider.of<NoteEditViewModel>(
                          context,
                          listen: false);
                      final downlaodNoteRes =
                          await noteEditViewModel.downloadNote(
                              noteEditViewModel.titleController.document
                                  .toPlainText()
                                  .trim(),
                              noteEditViewModel.descController.document
                                  .toPlainText()
                                  .trim());
                      Navigator.pop(context);
                      if (downlaodNoteRes == null) {
                        Utils.showToast(
                            'Note Downloaded Successfully ', false, context);
                      } else {
                        Utils.showToast(downlaodNoteRes, true, context);
                      }
                    },
                    text: 'Yes',
                  ),
                )
              ],
            ));
  }

  void onBackupPressed() {
    final noteEditViewModel =
        Provider.of<NoteEditViewModel>(context, listen: false);

    widget.isEditing
        ? noteEditViewModel.toogleIsExistingNoteBackupEnabled()
        : noteEditViewModel.toogleIsNewNoteBackupEnabled();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeProvider = Provider.of<HomeViewModel>(context, listen: false);
    });
    final noteEditViewModel =
        Provider.of<NoteEditViewModel>(context, listen: false);
    if (widget.isEditing) {
      noteEditViewModel.isExistingNoteBackupEnabled = widget.note!.isBackup;
      noteEditViewModel.titleController.document =
          Document.fromJson(jsonDecode(widget.note!.deltaTitle));

      noteEditViewModel.descController.document =
          Document.fromJson(jsonDecode(widget.note!.deltaDesc));
    } else {
      noteEditViewModel.isNewNoteBackupEnabled =
          noteEditViewModel.getBackupSetting();
      noteEditViewModel.titleController.clear();
      noteEditViewModel.descController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            Consumer<NoteEditViewModel>(
              builder: (context, value, child) => IconButton(
                  icon: Icon(Icons.backup,
                      color: widget.isEditing
                          ? value.isExistingNoteBackupEnabled!
                              ? Colors.green
                              : Colors.grey
                          : value.isNewNoteBackupEnabled!
                              ? Colors.green
                              : Colors.grey),
                  onPressed: onBackupPressed,
                  tooltip: "Backup this Note"),
            ),
            IconButton(
                icon: Icon(Icons.download),
                onPressed: downloadNote,
                tooltip: 'Download as pdf')
          ],
        ),
        body: Consumer<NoteEditViewModel>(
          builder: (context, value, child) => Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isEditing == true) ...[
                  Text(
                    'Created: ${DateFormat('d MMM y, hh:mma').format(widget.note!.created)}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Last Modified: ${DateFormat('d MMM y, hh:mma').format(widget.note!.lastModified)}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
                (scHeight * 0.02).ph,
                QuillProvider(
                    configurations:
                        QuillConfigurations(controller: value.descController),
                    child: QuillToolbar(
                      configurations: QuillToolbarConfigurations(
                          buttonOptions: QuillToolbarButtonOptions(
                              base: QuillToolbarToggleStyleButtonOptions(
                                  iconTheme: QuillIconTheme(
                                      iconUnselectedFillColor:
                                          Colors.transparent,
                                      borderRadius: 12,
                                      iconSelectedFillColor: Colors.grey)),
                              backgroundColor: QuillToolbarColorButtonOptions(
                                  iconTheme: QuillIconTheme(
                                      borderRadius: 8,
                                      iconSelectedColor:
                                          Colors.grey.shade400))),
                          sectionDividerColor: Colors.black,
                          toolbarSize: scHeight * 0.070,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(3)),
                          showLink: false,
                          showCodeBlock: false,
                          showInlineCode: false,
                          showClearFormat: false,
                          multiRowsDisplay: false,
                          showFontFamily: false,
                          showFontSize: false,
                          showSearchButton: false,
                          showColorButton: false,
                          showBackgroundColorButton: false),
                    )),
                (scHeight * 0.03).ph,
                QuillProvider(
                    configurations:
                        QuillConfigurations(controller: value.titleController),
                    child: Container(
                      height: (scHeight * 0.07),
                      child: QuillEditor.basic(
                        configurations: const QuillEditorConfigurations(
                            placeholder: 'Title'),
                      ),
                    )),
                Divider(thickness: 0.7),
                QuillProvider(
                    configurations:
                        QuillConfigurations(controller: value.descController),
                    child: Container(
                      height: (scHeight * 0.5),
                      child: QuillEditor.basic(
                        configurations: const QuillEditorConfigurations(
                            scrollable: true, placeholder: 'Description'),
                      ),
                    )),
                const Spacer(),
                MyButton(
                    isLoading: value.loading,
                    text: widget.isEditing ? 'Save Changes' : 'Save',
                    onPress: widget.isEditing
                            ? () async {
                                if (value.titleController.document.isEmpty()) {
                                  Utils.showToast(
                                      'Title can\'t be empty', true, context);
                                  return;
                                }
                                final res =
                                    await value.updateNote(widget.note!);
                                homeProvider.getNotes();
                                Navigator.pop(context);
                                if (!res) {
                                  Utils.showToast(
                                      'There\'s an error while save the changes to Clouds',
                                      true,
                                      context);
                                }
                              }
                            : () async {
                                if (value.titleController.document.isEmpty()) {
                                  Utils.showToast(
                                      'Title can\'t be empty', true, context);
                                  return;
                                }
                                final res = await value.saveNote();
                                homeProvider.getNotes();
                                Navigator.pop(context);
                                if (!res) {
                                  Utils.showToast(
                                      'There\'s an error while making backup of this note.',
                                      true,
                                      context);
                                }
                              },
                    color: Colors.black)
              ],
            ),
          ),
        ));
  }
}
