import 'package:organotes/data/network_service/base_api_services.dart';
import 'package:organotes/data/network_service/network_api_services.dart';
import 'package:http/http.dart' as http;
import 'package:organotes/res/app_url.dart';

class AuthRepository {
  // Lossely Coupled
  final BaseApiService apiService = NetworkApiService(http.Client());

  Future<dynamic> confirmMail(Map<String, String> data) async{
    try{
      final response = await apiService.post(AppUrl.confirmEmailUrl, data);
      return response;
    }catch(e){
      rethrow;
    }
  }

  Future<dynamic> verifyConfirmMailPin(Map<String, String> data) async{
    try{
      final response = await apiService.post(AppUrl.verifyConfirmMailPinUrl, data);
      return response;
    }catch(e){
      rethrow;
    }
  }

  Future<dynamic> login(Map<String, String> data) async {
    try {
      final response = await apiService.post(AppUrl.loginUrl, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> signup(Map<String, String> data) async {
    try {
      final response = await apiService.post(AppUrl.signupUrl, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> forgetPassword(Map<String, String> data)async{
    try{
      final resopnse = await apiService.post(AppUrl.forgetPasswordUrl, data);
      return resopnse;
    }catch(e){
      rethrow;
    }
  }

  Future<dynamic> verifyResetPasswordPin(Map<String, String> data)async{
    try{
      final resopnse = await apiService.post(AppUrl.verifyResetPinUrl, data);
      return resopnse;
    }catch(e){
      rethrow;
    }
  }

  Future<dynamic> resetPassword(Map<String, String> data)async{
    try{
      final resopnse = await apiService.post(AppUrl.resetPasswordUrl, data);
      return resopnse;
    }catch(e){
      rethrow;
    }
  }
}
