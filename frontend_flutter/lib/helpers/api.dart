import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:frontend_flutter/helpers/user_info.dart';
import 'app_exception.dart';

/// Kelas helper untuk melakukan permintaan HTTP `get`, `post`, dan `delete`
/// dengan header Authorization Bearer token.
class Api {
  /// Fungsi POST dengan token Authorization
  Future<dynamic> post(String url, dynamic data) async {
    final token = await UserInfo().getToken();
    dynamic responseJson;

    try {
      final response = await http.post(
        Uri.parse(url),
        body: data,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  /// Fungsi GET dengan token Authorization
  Future<dynamic> get(String url) async {
    final token = await UserInfo().getToken();
    dynamic responseJson;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  /// Fungsi DELETE dengan token Authorization
  Future<dynamic> delete(String url) async {
    final token = await UserInfo().getToken();
    dynamic responseJson;

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }

  /// Fungsi private untuk memproses response HTTP dan melemparkan exception sesuai status code
  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 422:
        throw UnprocessableEntityException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
          'Error occurred while Communication with Server with status code: ${response.statusCode}',
        );
    }
  }
}
