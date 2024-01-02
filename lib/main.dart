import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:organotes/ui/view_model/confirm_mail_view_model.dart';
import 'package:organotes/ui/view_model/home_view_model.dart';
import 'package:organotes/ui/view_model/login_view_model.dart';
import 'package:organotes/ui/view_model/note_edit_view_model.dart';
import 'package:organotes/ui/view_model/otp_view_model.dart';
import 'package:organotes/ui/view_model/reset_password_view_model.dart';
import 'package:organotes/ui/view_model/signup_view_model.dart';
import 'package:organotes/ui/view_model/splash_view_model.dart';
import 'package:organotes/utils/helper.dart';
import 'package:organotes/utils/notification_handler.dart';
import 'package:organotes/utils/routes/route_generator.dart';
import 'package:organotes/utils/routes/routes.dart';
import 'package:organotes/utils/screen_size.dart';
import 'package:organotes/utils/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make status bar transparent
      systemNavigationBarColor:
          Colors.transparent, // Make navigation bar transparent (optional)
    ),
  );

  await NotificationHandler.initNotification();
  await PrefHelper.initSharedPref();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ConfirmMailViewModel()),
    ChangeNotifierProvider(create: (context) => OtpViewModel()),
    ChangeNotifierProvider(create: (context) => SignupViewModel()),
    ChangeNotifierProvider(create: (context) => LoginViewModel()),
    ChangeNotifierProvider(create: (context) => SplashViewModel()),
    ChangeNotifierProvider(create: (context) => HomeViewModel()),
    ChangeNotifierProvider(create: (context) => ResetPasswordViewModel()),
    ChangeNotifierProvider(create: (context) => NoteEditViewModel())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initializations
    ScreenSize().init(context);

    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: MyTheme.lightTheme,
      title: 'OrgaNotes',
      initialRoute: Routes.splashView,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
