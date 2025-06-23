import 'dart:convert';
import 'package:frontend_flutter/helpers/api.dart';
import 'package:frontend_flutter/helpers/api_url.dart';
import 'package:frontend_flutter/model/login.dart';

/// BLoC (Business Logic Component) untuk proses login user.
class LoginBloc {
  /// Mengirim data login ke API dan mengembalikan objek model `Login`
  static Future<Login> login({String? email, String? password}) async {
    // URL endpoint login
    String apiUrl = ApiUrl.login;

    // Data dikirim ke body POST request
    var body = {"email": email, "password": password};

    // Kirim request ke server
    var response = await Api().post(apiUrl, body);

    // Decode JSON dari response body
    var jsonObj = json.decode(response.body);

    // Konversi ke model Login
    return Login.fromJson(jsonObj);
  }
}
