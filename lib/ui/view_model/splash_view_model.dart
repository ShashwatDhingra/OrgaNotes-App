import 'package:flutter/cupertino.dart';
import 'package:organotes/utils/helper.dart';

class SplashViewModel extends ChangeNotifier {

  PrefHelper _prefHelper = PrefHelper();

  Future<bool> checkUser() async {
    await Future.delayed(const Duration(seconds: 3));
    final isUser = _prefHelper.getString(PrefHelper.TOKEN);

    if(isUser == null || isUser == ''){
      return false;
    }else{
      return true;
    }
  }
}