import 'package:flutter/material.dart';
import 'package:organotes/repository/auth_repository.dart';
import 'package:organotes/data/response/response.dart';
import 'package:organotes/utils/utils.dart';

class ConfirmMailViewModel extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();

  bool _loading = false;

  bool get loading => _loading;

  void setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  Future<ApiResponse> confirmMail(String email) async {
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

  Future<ApiResponse> forgetPassword(String email)async{
    dynamic response;
    setLoading(true);
    try{
      response = await _authRepo.forgetPassword({"email": email});
    }catch(e){
      setLoading(false);
      return ApiResponse(false, e.toString());
    }

    setLoading(false);
    return ApiResponse(response['status'], response['message']);
  }
  
}
