import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:organotes/ui/view_model/splash_view_model.dart';
import 'package:organotes/utils/routes/routes.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeProvider();
    });
  }

  void initializeProvider() async {
    bool isUser =
        await Provider.of<SplashViewModel>(context, listen: false).checkUser();
    if (isUser) {
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.homeView, (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.introView, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: AnimatedTextKit(
      totalRepeatCount: 1,
      animatedTexts: [
        ColorizeAnimatedText(
            colors: [
              Colors.black,
              Colors.blueGrey.shade100,
              Colors.white,
              Colors.black,
            ],
            'Orga Notes',
            textStyle:
                const TextStyle(fontSize: 54, fontWeight: FontWeight.w300),
            speed: const Duration(milliseconds: 500))
      ],
    )));
  }
}
