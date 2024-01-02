import 'package:flutter/material.dart';
import 'package:organotes/ui/resuables/mypinput.dart';
import 'package:organotes/ui/view_model/confirm_mail_view_model.dart';
import 'package:organotes/ui/view_model/otp_view_model.dart';
import 'package:organotes/utils/routes/routes.dart';
import 'package:organotes/utils/screen_size.dart';
import 'package:organotes/utils/utils.dart';
import 'package:provider/provider.dart';

class OptView extends StatefulWidget {
  OptView({super.key, required this.email, required this.previousScreen});

  final String email;
  String previousScreen;

  @override
  State<OptView> createState() => _OptViewState();
}

class _OptViewState extends State<OptView> {
  final scWidth = ScreenSize.screenWidth;
  final scHeight = ScreenSize.screenHeight;

  late final OtpViewModel otpViewModel;

  @override
  void initState() {
    super.initState();
    // Start the timer when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeProvider();
    });
  }

  void initializeProvider() {
    otpViewModel = Provider.of<OtpViewModel>(context, listen: false);
    otpViewModel.startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          (scHeight * 0.03).ph,
          const Text(
            'Kindly check your mail inbox',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 28),
          ),
          (scHeight * 0.02).ph,
          const Text(
            'Enter the four digit PIN',
            style: TextStyle(
                fontFamily: 'Poppin',
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 17),
          ),
          (scHeight * 0.02).ph,
          Consumer<OtpViewModel>(
            builder: (context, value, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (!value.isTimerActive) {
                      final res = widget.previousScreen == Routes.introView
                          ? await value.resendConfirmMailPin(widget.email)
                          : await value.resendResetPasswordPin(widget.email);
                      if (res.status) {
                        Utils.showToast(res.message, false, context);
                        value.startTimer();
                      } else {
                        Utils.showToast(res.message, true, context);
                      }
                    }
                  },
                  child: Text(
                    'Resend',
                    style: TextStyle(
                        fontFamily: 'Poppin',
                        color: value.isTimerActive || value.loading
                            ? Colors.grey
                            : Colors.blue,
                        fontWeight: FontWeight.w400,
                        fontSize: 17),
                  ),
                ),
                (scHeight * 0.01).ph,
                RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.grey),
                        children: [
                      TextSpan(text: '0 : '),
                      TextSpan(
                          text:
                              value.timer == 0 ? '00' : value.timer.toString())
                    ]))
              ],
            ),
          ),
          (scHeight * 0.02).ph,
          MyPinPut(
            onSave: (pin) async {
              final response = widget.previousScreen == Routes.introView
                  ? await Provider.of<OtpViewModel>(context, listen: false)
                      .verifyConfirmMailPin(widget.email, pin)
                  : await Provider.of<OtpViewModel>(context, listen: false)
                      .verifyResetPasswordPin(widget.email, pin);
              if (response.status) {
                widget.previousScreen == Routes.introView
                    ? Navigator.pushReplacementNamed(context, Routes.signupView,
                        arguments: widget.email)
                    : Navigator.pushReplacementNamed(
                        context, Routes.resetPasswordView,
                        arguments: widget.email);
              } else {
                Utils.showToast(response.message, true, context);
              }
            },
          )
        ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Future.microtask(() => {otpViewModel.stopTimer()});
  }
}
