/// Kelas yang berisi seluruh URL endpoint API yang digunakan aplikasi.
class ApiUrl {
  /// Base URL dari REST API (gunakan 10.0.2.2 untuk koneksi ke localhost di emulator Android)
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  /// Endpoint untuk registrasi user
  static const String registrasi = '$baseUrl/registrasi';

  /// Endpoint untuk login user
  static const String login = '$baseUrl/login';

  /// Endpoint untuk menampilkan semua produk
  static const String listProduk = '$baseUrl/produk';

  /// Endpoint untuk menambahkan produk baru
  static const String createProduk = '$baseUrl/produk';

  /// Endpoint untuk mengupdate produk tertentu
  static String updateProduk(int id) {
    return '$baseUrl/produk/$id/update';
  }

  /// Endpoint untuk menampilkan detail produk tertentu
  static String showProduk(int id) {
    return '$baseUrl/produk/$id';
  }

  /// Endpoint untuk menghapus produk tertentu
  static String deleteProduk(int id) {
    return '$baseUrl/produk/$id';
  }
}
