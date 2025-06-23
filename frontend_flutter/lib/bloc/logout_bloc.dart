import 'package:frontend_flutter/helpers/user_info.dart';

/// BLoC untuk menangani proses logout user.
class LogoutBloc {
  /// Menghapus semua data user yang tersimpan di SharedPreferences (logout)
  static Future<void> logout() async {
    await UserInfo().logout();
  }
}
