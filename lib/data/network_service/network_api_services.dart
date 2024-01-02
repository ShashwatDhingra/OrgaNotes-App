import 'dart:convert';
import 'package:organotes/data/network_service/base_api_services.dart';
import 'package:http/http.dart' as http;

class NetworkApiService extends BaseApiService {
  // dependency injection
  final http.Client client;

  NetworkApiService(this.client);

  @override
  Future get(String url) async {
    dynamic responseJson = {"status": false};

    try {
      final response =
          await client.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      responseJson = resolveResponse(response);
    } catch (e) {
      rethrow;
    }
    return responseJson;
  }

  @override
  Future post(String url, dynamic data) async {
    dynamic responseJson = {"status": false};

    try {
      final response = await client.post(Uri.parse(url),
          headers: {'Content-type': 'Application/json'},
          body: json.encode(data));

      responseJson = resolveResponse(response);
    } catch (e) {
      rethrow;
    }

    return responseJson;
  }

  @override
  Future delete(String url, dynamic data) async {
    dynamic responseJson = {"status": false};

    try {
      final response = await client.delete(Uri.parse(url),
          headers: {'Content-type': 'Application/json'},
          body: json.encode(data));

      responseJson = resolveResponse(response);
    } catch (e) {
      rethrow;
    }

    return responseJson;
  }

  @override
  Future<dynamic> put(String url, dynamic data) async {
    dynamic responseJson = {"status": false};

    try {
      final response = await client.put(Uri.parse(url),
          headers: {'Content-type': 'Application/json'},
          body: json.encode(data));

      responseJson = resolveResponse(response);
    } catch (e) {
      rethrow;
    }

    return responseJson;
  }

  dynamic resolveResponse(http.Response response) {
    return json.decode(response.body);
    // if (response.statusCode >= 200 && response.statusCode < 300) {
    //   return json.decode(response.body);
    // } else if (response.statusCode == 400) {
    //   throw BadRequestException('adf');
    // } else if (response.statusCode == 401) {
    //   throw UnauthorizedException('adf');
    // } else {
    //   throw FetchDataException('Error : ${response.statusCode} ${json.decode(response.body)}');
    // }
  }
}
