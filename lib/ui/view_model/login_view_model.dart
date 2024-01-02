import 'package:flutter/material.dart';
import 'package:organotes/repository/auth_repository.dart';
import 'package:organotes/repository/notes_repository.dart';
import 'package:organotes/ui/resuables/my_text_button.dart';
import 'package:organotes/utils/helper.dart';
import 'package:organotes/data/response/response.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();
  PrefHelper _prefHelper = PrefHelper();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  Future<ApiResponse> login(String email, String password) async {
    dynamic response;
    setLoading(true);
    try{
      response = await _authRepo.login({"email": email, "password": password});
    }catch(e){
      setLoading(false);
      return ApiResponse(false, e.toString());
    }
    setLoading(false);
    // Persist User State
    if(response['status']){
      print(response['token']);
      final saveUser = await _prefHelper.setString(PrefHelper.TOKEN, response['token']);
      if(!saveUser){
        return ApiResponse(false, 'Please try again');
      }
    }
    return ApiResponse(response['status'], response['message']);
  }
}
