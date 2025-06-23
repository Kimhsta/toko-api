import 'package:flutter/material.dart';
import 'package:frontend_flutter/bloc/logout_bloc.dart';
import 'package:frontend_flutter/bloc/produk_bloc.dart';
import 'package:frontend_flutter/model/produk.dart';
import 'package:frontend_flutter/ui/login_page.dart';
import 'package:frontend_flutter/ui/produk_detail.dart';
import 'package:frontend_flutter/ui/produk_form.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({Key? key}) : super(key: key);

  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  late Future<List<Produk>> _futureProduk;

  @override
  void initState() {
    super.initState();
    _loadProduk();
  }

  void _loadProduk() {
    _futureProduk = ProdukBloc.getProduks();
  }

  Future<void> _navigateToForm() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProdukForm()),
    );
    setState(() {
      _loadProduk();
    });
  }

  void _logout() async {
    await LogoutBloc.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Produk'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: _navigateToForm,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Produk>>(
        future: _futureProduk,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Produk tidak tersedia."));
          }
          return ListProduk(list: snapshot.data!);
        },
      ),
    );
  }
}

class ListProduk extends StatelessWidget {
  final List<Produk> list;

  const ListProduk({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, i) => ItemProduk(produk: list[i]),
    );
  }
}

class ItemProduk extends StatelessWidget {
  final Produk produk;

  const ItemProduk({Key? key, required this.produk}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProdukDetail(produk: produk)),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(produk.namaProduk ?? ''),
          subtitle: Text("Rp ${produk.hargaProduk.toString()}"),
        ),
      ),
    );
  }
}
