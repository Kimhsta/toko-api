import 'package:flutter/material.dart';
import 'package:frontend_flutter/bloc/registrasi_bloc.dart';
import 'package:frontend_flutter/ui/login_page.dart';
import 'package:frontend_flutter/widget/warning_dialog.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiPasswordController = TextEditingController();

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
              maxWidth: isLargeScreen ? 450 : double.infinity,
            ),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  blurRadius: 16,
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Buat Akun Baru',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  _namaTextField(),
                  const SizedBox(height: 16),
                  _emailTextField(),
                  const SizedBox(height: 16),
                  _passwordTextField(),
                  const SizedBox(height: 16),
                  _konfirmasiPasswordTextField(),
                  const SizedBox(height: 24),
                  _buttonRegistrasi(),
                  const SizedBox(height: 16),
                  _textSudahPunyaAkun(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _namaTextField() {
    return TextFormField(
      controller: _namaController,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        labelText: "Nama Lengkap",
        hintText: "Masukkan nama lengkap",
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.length < 3) {
          return "Nama minimal 3 karakter";
        }
        return null;
      },
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "Masukkan email aktif",
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email harus diisi';
        }
        final pattern = r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$';
        if (!RegExp(pattern).hasMatch(value)) {
          return "Email tidak valid";
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
        labelText: "Password",
        hintText: "Minimal 6 karakter",
        prefixIcon: Icon(Icons.lock),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.length < 6) {
          return "Password minimal 6 karakter";
        }
        return null;
      },
    );
  }

  Widget _konfirmasiPasswordTextField() {
    return TextFormField(
      controller: _konfirmasiPasswordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: "Konfirmasi Password",
        hintText: "Ulangi password di atas",
        prefixIcon: Icon(Icons.lock_outline),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value != _passwordController.text) {
          return "Konfirmasi tidak cocok";
        }
        return null;
      },
    );
  }

  Widget _buttonRegistrasi() {
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
                : const Text("Registrasi"),
        onPressed: _isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _textSudahPunyaAkun() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Sudah punya akun? "),
        InkWell(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          },
          child: const Text(
            "Login",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    RegistrasiBloc.registrasi(
          nama: _namaController.text,
          email: _emailController.text,
          password: _passwordController.text,
        )
        .then((value) {
          // langsung arahkan ke login setelah berhasil
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        })
        .catchError((error) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (_) => const WarningDialog(
                  description: "Registrasi gagal, silakan coba lagi",
                ),
          );
        })
        .whenComplete(() => setState(() => _isLoading = false));
  }
}
