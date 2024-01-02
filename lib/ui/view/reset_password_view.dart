import 'package:flutter/material.dart';
import 'package:organotes/ui/resuables/my_button.dart';
import 'package:organotes/ui/resuables/my_text_button.dart';
import 'package:organotes/ui/resuables/my_text_field.dart';
import 'package:organotes/ui/view_model/login_view_model.dart';
import 'package:organotes/ui/view_model/reset_password_view_model.dart';
import 'package:organotes/ui/view_model/signup_view_model.dart';
import 'package:organotes/utils/routes/routes.dart';
import 'package:organotes/utils/screen_size.dart';
import 'package:organotes/utils/utils.dart';
import 'package:provider/provider.dart';

class ResetPasswordView extends StatefulWidget {
  ResetPasswordView({super.key, required this.mail});

  String mail;

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final scWidth = ScreenSize.screenWidth;
  final scHeight = ScreenSize.screenHeight;

  TextEditingController passwordTextController = TextEditingController();

  TextEditingController repeatPasswordTextController = TextEditingController();

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
              key: ResetPasswordView._formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (scHeight * 0.03).ph,
                    const Text(
                      'Reset Password',
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 28),
                    ),
                    (scHeight * 0.03).ph,
                    const Text(
                      'Enter new password you want to set for you account.',
                      style: TextStyle(
                          fontFamily: 'Poppin',
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 17),
                    ),
                    (scHeight * 0.03).ph,
                    MyTextField(
                      isPassword: true,
                      controller: passwordTextController,
                      hintText: 'Enter Password',
                      lineColor: Colors.blueAccent.shade400,
                      validator: (val) {
                        if (val == null || val.trim() == '') {
                          return 'Please Enter something';
                        }
                        if (val.length < 6) {
                          return 'Password length is less than 6';
                        }
                        return null;
                      },
                    ),
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
                    (scHeight * 0.03).ph,
                    Center(
                      child: Consumer<ResetPasswordViewModel>(
                        builder: (context, value, child) => MyButton(
                          text: "Confirm",
                          isLoading: value.loading ? true : false,
                          onPress: value.loading
                              ? () {}
                              : () async {
                                  if (ResetPasswordView._formKey.currentState!
                                          .validate() ==
                                      false) {
                                    return;
                                  }

                                  final res = await value.resetPassword(
                                      widget.mail, passwordTextController.text);

                                  if (res.status) {
                                    Navigator.pop(context);
                                    Utils.showToast(
                                        'Password Changed Successfully',
                                        false,
                                        context);
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
    passwordTextController.dispose();
    repeatPasswordTextController.dispose();
  }
}
