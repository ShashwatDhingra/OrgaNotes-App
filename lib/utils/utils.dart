import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Utils {
  static showToast(String message, bool isError, BuildContext context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          isDismissible: true,
          flushbarStyle: FlushbarStyle.FLOATING,
          duration: const Duration(seconds: 3),
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(16), topRight: Radius.circular(16)),
          backgroundColor: isError ? Colors.red.shade100 : Colors.green.shade100,
          margin: const EdgeInsets.all(20),
          messageText: Text(
            message,
            style: TextStyle(fontWeight: FontWeight.w200),
          ),
          titleColor: Colors.black,
          titleText: Text(isError ? 'Error' : 'Success',
              style: const TextStyle(fontWeight: FontWeight.w400)),
          icon: Padding(
            padding: const EdgeInsets.all(4.0),
            child: CircleAvatar(
                backgroundColor: isError ? Colors.transparent : Colors.green,
                child: isError
                    ? Icon(Icons.info, color: Colors.red, size: 30)
                    : Icon(Icons.done, size: 32)),
          ),
        )..show(context));
  }

  static void triggerHapticFeedback() {
    HapticFeedback.mediumImpact(); // can also use `lightImpact` or `heavyImpact`
  }
}

extension MySizedBox on num {
  SizedBox get ph => SizedBox(height: toDouble());
  SizedBox get pw => SizedBox(width: toDouble());
}
