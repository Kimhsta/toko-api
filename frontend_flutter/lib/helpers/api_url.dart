class ApiUrl {
  // Base URL untuk koneksi ke Laravel (gunakan 10.0.2.2 untuk emulator Android)
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Endpoint untuk auth
  static const String registrasi = '$baseUrl/register';
  static const String login = '$baseUrl/login';

  // Endpoint produk (meskipun tidak dipakai di tugas, tetap disiapkan)
  static const String listProduk = '$baseUrl/barang';
  static const String createProduk = '$baseUrl/barang';

  static String updateProduk(int id) {
    return '$baseUrl/barang/$id/update';
  }

  static String showProduk(int id) {
    return '$baseUrl/barang/$id';
  }

  static String deleteProduk(int id) {
    return '$baseUrl/barang/$id';
  }
}
