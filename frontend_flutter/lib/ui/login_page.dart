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

  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _emailTextField(),
              _passwordTextField(),
              const SizedBox(height: 20),
              _buttonLogin(),
              const SizedBox(height: 30),
              _menuRegistrasi(),
            ],
          ),
        ),
      ),
    );
  }

  // TextField untuk email
  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Email"),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email harus diisi';
        }
        return null;
      },
    );
  }

  // TextField untuk password
  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Password"),
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Password harus diisi";
        }
        return null;
      },
    );
  }

  // Tombol login
  Widget _buttonLogin() {
    return _isLoading
        ? const CircularProgressIndicator()
        : ElevatedButton(
          onPressed: () {
            final isValid = _formKey.currentState!.validate();
            if (isValid && !_isLoading) {
              _submit();
            }
          },
          child: const Text("Login"),
        );
  }

  // Fungsi login
  void _submit() {
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    LoginBloc.login(
          email: _emailTextboxController.text,
          password: _passwordTextboxController.text,
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
                (context) => const WarningDialog(
                  description: "Login gagal, silahkan coba lagi",
                ),
          );
        })
        .whenComplete(() {
          setState(() => _isLoading = false);
        });
  }

  // Link ke halaman registrasi
  Widget _menuRegistrasi() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegistrasiPage()),
        );
      },
      child: const Text("Registrasi", style: TextStyle(color: Colors.blue)),
    );
  }
}
