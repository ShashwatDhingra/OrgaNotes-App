import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:organotes/ui/resuables/my_button.dart';
import 'package:organotes/ui/resuables/my_text_button.dart';
import 'package:organotes/utils/notification_handler.dart';
import 'package:organotes/utils/routes/routes.dart';
import 'package:organotes/utils/screen_size.dart';
import 'package:organotes/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';

class IntroView extends StatefulWidget{
  IntroView({super.key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {

  final NotificationHandler _notificationHandler = NotificationHandler();
  
  final scWidth = ScreenSize.screenWidth;

  final scHeight = ScreenSize.screenHeight;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notificationHandler.checkAndRequestNotificationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment(1, -1),
              colors: [Colors.blueAccent.shade200, Colors.white])),
      child: Center(
        child: Column(
          children: [
            (scHeight * 0.17).ph,
            Lottie.asset('assets/anims/intro_view_anim.json',
                height: scHeight * 0.37),
            (scHeight * 0.1).ph,
            const Text(
              'Unlock the Power of Productivity with OrgaNotes.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 22),
            ),
            (scHeight * 0.01).ph,
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                  'Stay focused, stay organized, and let your ideas flourish!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w200)),
            ),
            (scHeight * 0.05).ph,
            MyButton(
              color: Colors.black,
              text: 'Create new account',
              onPress: () {
                Navigator.pushNamed(context, Routes.confirmMailView, arguments: Routes.introView);
              },
            ),
            (scHeight * 0.03).ph,
            MyTextButton(text: 'I already have an account', onPress: () {
              Navigator.pushNamed(context, Routes.loginView);
            })
          ],
        ),
      ),
    ));
  }
}
