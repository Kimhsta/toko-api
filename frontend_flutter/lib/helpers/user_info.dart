import 'package:shared_preferences/shared_preferences.dart';

/// Kelas helper untuk menyimpan dan mengambil informasi pengguna secara lokal
/// menggunakan SharedPreferences, seperti token dan userID.
class UserInfo {
  /// Menyimpan token ke SharedPreferences
  Future<void> setToken(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("token", value);
  }

  /// Mengambil token dari SharedPreferences
  Future<String?> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("token");
  }

  /// Menyimpan ID pengguna ke SharedPreferences
  Future<void> setUserID(int value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt("userID", value);
  }

  /// Mengambil ID pengguna dari SharedPreferences
  Future<int?> getUserID() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("userID");
  }

  /// Menghapus semua data yang disimpan (logout)
  Future<void> logout() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}
