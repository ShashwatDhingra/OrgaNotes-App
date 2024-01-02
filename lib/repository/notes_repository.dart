import 'package:organotes/data/network_service/base_api_services.dart';
import 'package:organotes/data/network_service/network_api_services.dart';
import 'package:http/http.dart' as http;
import 'package:organotes/res/app_url.dart';

class NotesRepository{
  final BaseApiService _apiService = NetworkApiService(http.Client());

  Future<dynamic> addNote(Map<String, dynamic> data)async{
    try{
      final response = await _apiService.post(AppUrl.addNoteUrl, data);
      return response;
    }catch(e){
      rethrow;
    }
  }

  Future<dynamic> addNotes(Map<String, dynamic> data)async{
    try{
      final response = await _apiService.post(AppUrl.addNotesUrl, data);
      return response;
    }catch(e){
      rethrow;
    }
  }

  Future<dynamic> getNotes(Map<String, dynamic> data)async{
    try{
      final response = await _apiService.post(AppUrl.getNotesUrl, data);
      return response;
    }catch(e){
      rethrow;
    }
  }

  Future<dynamic> updateNote(Map<String, dynamic> data)async{
    try{
      final response = await _apiService.put(AppUrl.updateNoteUrl, data);
      return response;
    }catch(e){
      rethrow;
    }
  }

  Future<dynamic> deleteNotes(Map<String, dynamic> data)async{
    try{
      final response = await _apiService.delete(AppUrl.deleteNoteUrl, data);
      return response;
    }catch(e){
      rethrow;
    }
  }
}