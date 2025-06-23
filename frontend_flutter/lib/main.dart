import 'package:flutter/material.dart';
import 'package:frontend_flutter/helpers/user_info.dart';
import 'package:frontend_flutter/ui/login_page.dart';
import 'package:frontend_flutter/ui/produk_page.dart';

void main() {
  runApp(const MyApp());
}

/// Widget utama aplikasi
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// Widget default saat menunggu pengecekan login
  Widget page = const Scaffold(
    body: Center(child: CircularProgressIndicator()),
  );

  @override
  void initState() {
    super.initState();
    isLogin();
  }

  /// Mengecek apakah user sudah login (berdasarkan token di SharedPreferences)
  void isLogin() async {
    var token = await UserInfo().getToken();
    setState(() {
      page = (token != null) ? const ProdukPage() : const LoginPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Kita',
      debugShowCheckedModeBanner: false,
      home: page,
    );
  }
}
