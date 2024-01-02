import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organotes/model/notes.dart';
import 'package:organotes/res/my_colors.dart';
import 'package:organotes/ui/resuables/my_text_button.dart';
import 'package:organotes/utils/utils.dart';

class NoteTile extends StatelessWidget {
  const NoteTile({super.key, required this.note, required this.deleteNote});

  final Note note;
  final Function(int) deleteNote;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: MyColors.noteTileColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                  blurRadius: 2, spreadRadius: 0.1, color: Colors.grey.shade400)
            ]),
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Icon(Icons.circle, color: Colors.grey.shade400, size: 16),
              8.pw,
              Text(note.title, style: TextStyle(fontWeight: FontWeight.w700)),
              Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.backup_rounded, color: note.isBackup ? Colors.green : Colors.grey.shade400,),
                  !note.isBackup ? Icon(Icons.close, color: Colors.grey.shade600, size: 30) : const SizedBox()
                ],
              ),
              8.pw
            ],
          ),
          8.ph,
          Row(
            children: [
              Icon(Icons.circle, color: Colors.transparent, size: 16),
              8.pw,
              Text(note.desc,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
          8.ph,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, color: Colors.transparent, size: 16),
              8.pw,
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('d MMM yyy').format(note.lastModified),
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                    GestureDetector(
                        onTap: () {
                          Utils.triggerHapticFeedback();
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text('Confirm to Delete'),
                                    content:const Text('Consider to Backup your Note'),
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
                                          onPress: () {
                                            deleteNote(note.id!);
                                            Navigator.pop(context);
                                          },
                                          text: 'Yes',
                                        ),
                                      )
                                    ],
                                  ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Icon(Icons.delete,
                              size: 20, color: Colors.grey.shade700),
                        ))
                  ],
                ),
              ),
            ],
          )
        ]));
  }
}
