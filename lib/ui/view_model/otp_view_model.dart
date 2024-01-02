import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:organotes/repository/auth_repository.dart';
import 'package:organotes/ui/view/otp_view.dart';
import 'package:organotes/data/response/response.dart';

class OtpViewModel extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();

  bool _loading = false;
  bool get loading => _loading;

  late Timer? _timerInstance;
  int _timer = 59;
  int get timer => _timer;
  bool _isTimerActive = false;
  bool get isTimerActive => _isTimerActive;

  void stopTimer() {
    _timer = 59;
    setTimerState(false);
    notifyListeners();
  }

  Future<void> startTimer() async {
    setTimerState(true);
    notifyListeners();
    _timerInstance = Timer.periodic(Duration(seconds: 1), (_) {
      if (_timer == 0 || _isTimerActive == false) {
        _timerInstance!.cancel();
        _timer = 59;
        setTimerState(false);
        notifyListeners();
        return;
      }
      else {
        _timer--;
        notifyListeners();
      }
    });
  }

  void setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  void setTimerState(bool val) {
    _isTimerActive = val;
    notifyListeners();
  }

  Future<ApiResponse> verifyConfirmMailPin(String email, String pin) async {
    dynamic response;
    setLoading(true);
    try {
      response = await _authRepo
          .verifyConfirmMailPin({"email": email, "pin": pin}).timeout(
        const Duration(seconds: 25),
        onTimeout: () {
          return ApiResponse(false, 'Try Again Later');
        },
      );
    } catch (e) {
      setLoading(false);
      return ApiResponse(false, e.toString());
    }
    setLoading(false);
    return ApiResponse(response['status'], response['message']);
  }

  Future<ApiResponse> resendConfirmMailPin(String email) async {
    dynamic response;
    setLoading(true);
    try {
      response = await _authRepo.confirmMail({"email": email}).timeout(
        const Duration(seconds: 25),
        onTimeout: () {
          return ApiResponse(false, 'Try Again Later');
        },
      );
    } catch (e) {
      setLoading(false);
      return ApiResponse(false, e.toString());
    }
    setLoading(false);
    return ApiResponse(response['status'], response['message']);
  }

  Future<ApiResponse> verifyResetPasswordPin(String email, String pin) async {
    dynamic response;
    setLoading(true);
    try {
      response = await _authRepo
          .verifyResetPasswordPin({"email": email, "pin": pin}).timeout(
        const Duration(seconds: 25),
        onTimeout: () {
          return ApiResponse(false, 'Try Again Later');
        },
      );
    } catch (e) {
      setLoading(false);
      return ApiResponse(false, e.toString());
    }
    setLoading(false);
    return ApiResponse(response['status'], response['message']);
  }

  Future<ApiResponse> resendResetPasswordPin(String email) async {
    dynamic response;
    setLoading(true);
    try {
      response = await _authRepo.forgetPassword({"email": email}).timeout(
        const Duration(seconds: 25),
        onTimeout: () {
          return ApiResponse(false, 'Try Again Later');
        },
      );
    } catch (e) {
      setLoading(false);
      return ApiResponse(false, e.toString());
    }
    setLoading(false);
    return ApiResponse(response['status'], response['message']);
  }
}
