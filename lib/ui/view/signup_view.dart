import 'package:flutter/material.dart';
import 'package:organotes/ui/resuables/my_button.dart';
import 'package:organotes/ui/resuables/my_text_field.dart';
import 'package:organotes/ui/view_model/signup_view_model.dart';
import 'package:organotes/utils/routes/routes.dart';
import 'package:organotes/utils/screen_size.dart';
import 'package:organotes/utils/utils.dart';
import 'package:provider/provider.dart';

class SignupView extends StatefulWidget {
  SignupView({super.key, required this.mail});

  final String mail;

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final scWidth = ScreenSize.screenWidth;
  final scHeight = ScreenSize.screenHeight;

  TextEditingController mailTextController = TextEditingController();

  TextEditingController passwordTextController = TextEditingController();

  TextEditingController repeatPasswordTextController = TextEditingController();

  TextEditingController usernameTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    mailTextController.text = widget.mail;
  }

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
              key: SignupView._formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (scHeight * 0.03).ph,
                    const Text(
                      'Create your account',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 28),
                    ),
                    (scHeight * 0.03).ph,
                    const Text(
                      'Create an account to Organise your Notes with OrgaNotes',
                      style: TextStyle(
                          fontFamily: 'Poppin',
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 17),
                    ),
                    (scHeight * 0.03).ph,
                    MyTextField(
                        controller: usernameTextController,
                        hintText: 'username',
                        lineColor: Colors.blueAccent.shade400,
                        validator: (val) {
                          if (val == null || val.trim() == '') {
                            return 'Please Enter Something';
                          }
                          return null;
                        }),
                    (scHeight * 0.02).ph,
                    MyTextField(
                      enable: false,
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
                    MyTextField(
                      isPassword: true,
                        controller: repeatPasswordTextController,
                        hintText: 'Confirm Password',
                        lineColor: Colors.blueAccent.shade400,
                        validator: (val) {
                          if (val == null || val.trim() == '') {
                            return 'Please Enter Something';
                          }
                          if (passwordTextController.text !=
                              repeatPasswordTextController.text) {
                            return 'Password doesn\'t match';
                          }
                          return null;
                        }),
                    (scHeight * 0.04).ph,
                    Center(
                      child: Consumer<SignupViewModel>(
                        builder: (context, value, child) => MyButton(
                          text: "Create",
                          isLoading: value.loading ? true : false,
                          onPress: value.loading
                              ? () {}
                              : () async {
                                  if (SignupView._formKey.currentState!
                                          .validate() ==
                                      false) {
                                    return;
                                  }

                                  final res = await value.signup(
                                      username:
                                          usernameTextController.text.trim(),
                                      mail: mailTextController.text.trim(),
                                      password:
                                          passwordTextController.text.trim());

                                  if (res.status) {
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        Routes.homeView, (route) => false);
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
    usernameTextController.dispose();
    mailTextController.dispose();
    passwordTextController.dispose();
    repeatPasswordTextController.dispose();
  }
}
