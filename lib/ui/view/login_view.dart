import 'package:flutter/material.dart';
import 'package:organotes/ui/resuables/my_button.dart';
import 'package:organotes/ui/resuables/my_text_button.dart';
import 'package:organotes/ui/resuables/my_text_field.dart';
import 'package:organotes/ui/view_model/login_view_model.dart';
import 'package:organotes/ui/view_model/signup_view_model.dart';
import 'package:organotes/utils/routes/routes.dart';
import 'package:organotes/utils/screen_size.dart';
import 'package:organotes/utils/utils.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final scWidth = ScreenSize.screenWidth;
  final scHeight = ScreenSize.screenHeight;

  TextEditingController mailTextController = TextEditingController();

  TextEditingController passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        height: scHeight,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: LoginView._formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (scHeight * 0.03).ph,
                    const Text(
                      'Welcome Back !',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 28),
                    ),
                    (scHeight * 0.03).ph,
                    const Text(
                      'Login to your account to continue Organising your Notes.',
                      style: TextStyle(
                          fontFamily: 'Poppin',
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 17),
                    ),
                    (scHeight * 0.03).ph,
                    MyTextField(
                      controller: mailTextController,
                      hintText: 'e-mail',
                      lineColor: Colors.blueAccent.shade400,
                      validator: (val) {
                        if (val == null || val.trim() == '') {
                          return 'Please Enter something';
                        } else if (!RegExp(
                                r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+$')
                            .hasMatch(val)) {
                          return 'Enter valid E-mail address';
                        } else {
                          return null;
                        }
                      },
                    ),
                    (scHeight * 0.02).ph,
                    MyTextField(
                      isPassword: true,
                        controller: passwordTextController,
                        hintText: 'Password',
                        lineColor: Colors.blueAccent.shade400,
                        validator: (val) {
                          if (val == null || val.trim() == '') {
                            return 'Please Enter Something';
                          }
                          if (val.length < 6) {
                            return 'Password length must be more than 6';
                          }
                          return null;
                        }),
                    (scHeight * 0.02).ph,
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Align(
                        alignment: Alignment(1, 1),
                        child: MyTextButton(
                          text: 'Forget Password',
                          fontSize: 16,
                          color: Colors.blue.shade300,
                          onPress: () {
                            Navigator.pushNamed(context, Routes.confirmMailView,
                                arguments: Routes.loginView);
                          },
                        ),
                      ),
                    ),
                    (scHeight * 0.03).ph,
                    Center(
                      child: Consumer<LoginViewModel>(
                        builder: (context, value, child) => MyButton(
                          text: "Login",
                          isLoading: value.loading ? true : false,
                          onPress: value.loading
                              ? () {}
                              : () async {
                                  if (LoginView._formKey.currentState!
                                          .validate() ==
                                      false) {
                                    return;
                                  }

                                  final res = await value.login(
                                      mailTextController.text.trim(),
                                      passwordTextController.text.trim());

                                  if (res.status) {
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        Routes.homeView, (route) => false, arguments: true);
                                  } else {
                                    Utils.showToast(res.message, true, context);
                                  }
                                },
                          color: value.loading ? Colors.grey : Colors.black,
                        ),
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    mailTextController.dispose();
    passwordTextController.dispose();
  }
}
