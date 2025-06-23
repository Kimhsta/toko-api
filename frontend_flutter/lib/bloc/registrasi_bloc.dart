import 'dart:convert';
import 'package:frontend_flutter/helpers/api.dart';
import 'package:frontend_flutter/helpers/api_url.dart';
import 'package:frontend_flutter/model/registrasi.dart';

/// BLoC (Business Logic Component) untuk menangani proses registrasi user.
class RegistrasiBloc {
  /// Melakukan registrasi ke API dan mengembalikan objek `Registrasi`
  static Future<Registrasi> registrasi({
    String? nama,
    String? email,
    String? password,
  }) async {
    String apiUrl = ApiUrl.registrasi;

    // Data yang dikirim ke API
    var body = {"nama": nama, "email": email, "password": password};

    // Kirim POST request dan ambil response
    var response = await Api().post(apiUrl, body);

    // Decode response JSON
    var jsonObj = json.decode(response.body);

    // Parsing ke model Registrasi
    return Registrasi.fromJson(jsonObj);
  }
}
