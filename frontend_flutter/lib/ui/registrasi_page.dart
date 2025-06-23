import 'package:flutter/material.dart';
import 'package:frontend_flutter/bloc/registrasi_bloc.dart';
import 'package:frontend_flutter/widget/success_dialog.dart';
import 'package:frontend_flutter/widget/warning_dialog.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrasi")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _namaTextField(),
              _emailTextField(),
              _passwordTextField(),
              _passwordKonfirmasiTextField(),
              const SizedBox(height: 20),
              _buttonRegistrasi(),
            ],
          ),
        ),
      ),
    );
  }

  // TextField untuk Nama
  Widget _namaTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama"),
      keyboardType: TextInputType.text,
      controller: _namaTextboxController,
      validator: (value) {
        if (value == null || value.length < 3) {
          return "Nama harus diisi minimal 3 karakter";
        }
        return null;
      },
    );
  }

  // TextField untuk Email
  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Email"),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email harus diisi';
        }
        final pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        final regex = RegExp(pattern);
        if (!regex.hasMatch(value)) {
          return "Email tidak valid";
        }
        return null;
      },
    );
  }

  // TextField untuk Password
  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Password"),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value == null || value.length < 6) {
          return "Password harus diisi minimal 6 karakter";
        }
        return null;
      },
    );
  }

  // TextField untuk Konfirmasi Password
  Widget _passwordKonfirmasiTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Konfirmasi Password"),
      keyboardType: TextInputType.text,
      obscureText: true,
      validator: (value) {
        if (value != _passwordTextboxController.text) {
          return "Konfirmasi Password tidak sama";
        }
        return null;
      },
    );
  }

  // Tombol Registrasi
  Widget _buttonRegistrasi() {
    return _isLoading
        ? const CircularProgressIndicator()
        : ElevatedButton(
          onPressed: () {
            final isValid = _formKey.currentState!.validate();
            if (isValid && !_isLoading) {
              _submit();
            }
          },
          child: const Text("Registrasi"),
        );
  }

  // Fungsi untuk memproses registrasi
  void _submit() {
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    RegistrasiBloc.registrasi(
          nama: _namaTextboxController.text,
          email: _emailTextboxController.text,
          password: _passwordTextboxController.text,
        )
        .then((value) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (context) => SuccessDialog(
                  description: "Registrasi berhasil, silahkan login",
                  okClick: () {
                    Navigator.pop(context); // tutup dialog
                    Navigator.pop(context); // kembali ke login page
                  },
                ),
          );
        })
        .catchError((error) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (context) => const WarningDialog(
                  description: "Registrasi gagal, silahkan coba lagi",
                ),
          );
        })
        .whenComplete(() => setState(() => _isLoading = false));
  }
}
