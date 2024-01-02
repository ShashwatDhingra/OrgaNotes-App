import 'package:flutter/material.dart';
import 'package:organotes/repository/auth_repository.dart';
import 'package:organotes/data/response/response.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  AuthRepository _authRepo = AuthRepository();
  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  Future<ApiResponse> resetPassword(String email, String password) async {
    setLoading(true);
    dynamic response;
    try{
      response = await _authRepo.resetPassword({"email": email, "password": password});
    }catch(e){
      setLoading(false);
      return ApiResponse(false, e.toString());
    }
    setLoading(false);
    return ApiResponse(response['status'], response['message']);
  }
}