import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:organotes/ui/resuables/my_button.dart';
import 'package:organotes/ui/resuables/my_text_field.dart';
import 'package:organotes/ui/view_model/confirm_mail_view_model.dart';
import 'package:organotes/utils/routes/routes.dart';
import 'package:organotes/utils/screen_size.dart';
import 'package:organotes/utils/utils.dart';
import 'package:provider/provider.dart';

class ConfirmMailView extends StatefulWidget {
  ConfirmMailView({super.key, required this.previousScreen});

  String previousScreen;

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  State<ConfirmMailView> createState() => _ConfirmMailViewState();
}

class _ConfirmMailViewState extends State<ConfirmMailView> {
  final scWidth = ScreenSize.screenWidth;

  final scHeight = ScreenSize.screenHeight;

  TextEditingController mailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: ConfirmMailView._formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            (scHeight * 0.03).ph,
            const Text(
              'Enter your email address',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 28),
            ),
            (scHeight * 0.03).ph,
            const Text(
              'You\'ll received a PIN on your email id ',
              style: TextStyle(
                  fontFamily: 'Poppin',
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 17),
            ),
            (scHeight * 0.03).ph,
            MyTextField(
              controller: mailTextController,
              hintText: 'E-mail',
              lineColor: Colors.blueAccent.shade400,
              validator: (val) {
                if (val == '' || val == null) {
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
            const Spacer(),
            Center(
              child: Consumer<ConfirmMailViewModel>(
                builder: (context, value, child) => MyButton(
                  text: "Continue",
                  isLoading: value.loading ? true : false,
                  onPress: value.loading
                      ? () {}
                      : () async {
                          if (ConfirmMailView._formKey.currentState!
                                  .validate() ==
                              false) {
                            return;
                          }
                          final res = widget.previousScreen == Routes.introView
                              ? await value
                                  .confirmMail(mailTextController.text.trim())
                              : await value.forgetPassword(
                                  mailTextController.text.trim());

                          if (res.status) {
                            Navigator.of(context).pushReplacementNamed(
                                Routes.optView,
                                arguments: {
                                  "email": mailTextController.text.toString(),
                                  "previousScreen": widget.previousScreen
                                });
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
    );
  }

  @override
  void dispose() {
    super.dispose();
    mailTextController.dispose();
  }
}
