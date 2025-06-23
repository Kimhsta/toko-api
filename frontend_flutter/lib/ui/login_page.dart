import 'package:flutter/material.dart';
import 'package:frontend_flutter/bloc/login_bloc.dart';
import 'package:frontend_flutter/helpers/user_info.dart';
import 'package:frontend_flutter/ui/produk_page.dart';
import 'package:frontend_flutter/ui/registrasi_page.dart';
import 'package:frontend_flutter/widget/warning_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLargeScreen = mediaQuery.size.width > 600;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isLargeScreen ? 400 : double.infinity,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Login ke Akun Anda',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  _emailTextField(),
                  const SizedBox(height: 16),
                  _passwordTextField(),
                  const SizedBox(height: 24),
                  _buttonLogin(),
                  const SizedBox(height: 16),
                  _menuRegistrasi(), // GANTI DENGAN VERSI MODERN
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: 'Masukkan email anda',
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email harus diisi';
        }
        return null;
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Password',
        hintText: 'Masukkan password',
        prefixIcon: Icon(Icons.lock),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password harus diisi';
        }
        return null;
      },
    );
  }

  Widget _buttonLogin() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        child:
            _isLoading
                ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : const Text("Login"),
        onPressed: _isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    LoginBloc.login(
          email: _emailController.text,
          password: _passwordController.text,
        )
        .then((value) async {
          await UserInfo().setToken(value.token.toString());
          await UserInfo().setUserID(int.parse(value.userID.toString()));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProdukPage()),
          );
        })
        .catchError((error) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (_) => const WarningDialog(
                  description: "Login gagal, silahkan coba lagi",
                ),
          );
        })
        .whenComplete(() => setState(() => _isLoading = false));
  }

  Widget _menuRegistrasi() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Belum punya akun? "),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegistrasiPage()),
            );
          },
          child: const Text(
            "Registrasi",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
