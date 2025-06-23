/// Exception kustom untuk menangani berbagai jenis error dalam aplikasi.
class AppException implements Exception {
  final String? _message;
  final String? _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

/// Exception untuk error komunikasi (misal: koneksi gagal, server down)
class FetchDataException extends AppException {
  FetchDataException([String? message])
    : super(message, "Error During Communication: ");
}

/// Exception untuk request yang tidak valid (400 Bad Request)
class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, "Invalid Request: ");
}

/// Exception untuk unauthorized access (401 Unauthorized)
class UnauthorisedException extends AppException {
  UnauthorisedException([String? message]) : super(message, "Unauthorised: ");
}

/// Exception untuk error validasi dari server (422 Unprocessable Entity)
class UnprocessableEntityException extends AppException {
  UnprocessableEntityException([String? message])
    : super(message, "Unprocessable Entity: ");
}

/// Exception untuk input yang tidak valid dari user (client-side)
class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}
