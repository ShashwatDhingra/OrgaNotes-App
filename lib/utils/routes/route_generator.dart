import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:organotes/ui/view/confirm_mail_view.dart';
import 'package:organotes/ui/view/home_view.dart';
import 'package:organotes/ui/view/intro_view.dart';
import 'package:organotes/ui/view/login_view.dart';
import 'package:organotes/ui/view/note_edit_view.dart';
import 'package:organotes/ui/view/otp_view.dart';
import 'package:organotes/ui/view/reset_password_view.dart';
import 'package:organotes/ui/view/signup_view.dart';
import 'package:organotes/ui/view/splash_view.dart';
import 'package:organotes/utils/routes/routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Gettting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.splashView:
        return MaterialPageRoute(builder: (context) => const SplashView());
      case Routes.introView:
        return MaterialPageRoute(builder: (context) => IntroView());
      case Routes.confirmMailView:
        return MaterialPageRoute(
            builder: (context) =>
                ConfirmMailView(previousScreen: args.toString()));
      case Routes.optView:
        args as Map<String, String>;
        return MaterialPageRoute(
            builder: (context) => OptView(
                  email: args['email']!,
                  previousScreen: args['previousScreen']!,
                ));
      case Routes.signupView:
        return MaterialPageRoute(
            builder: (context) => SignupView(mail: args.toString()));
      case Routes.loginView:
        return MaterialPageRoute(builder: (context) => LoginView());
      case Routes.homeView:
        return MaterialPageRoute(builder: (context) => HomeView(isPreviousLoginScreen: args.runtimeType == bool ? true : false));
      case Routes.resetPasswordView:
        return MaterialPageRoute(
            builder: (context) => ResetPasswordView(mail: args.toString()));
      case Routes.noteEditView:
        args as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => NoteEditView(
                  isEditing: args['isEditing'],
                  note: args['note'],
                ));

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(
      builder: (context) {
        return Scaffold(
            appBar: AppBar(title: const Text('ERROR')),
            body: const Center(child: Text('ERROR')));
      },
    );
  }
}
