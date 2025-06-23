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
  late Future<List<Produk>> _futureProduks;

  @override
  void initState() {
    super.initState();
    _futureProduks = ProdukBloc.getProduks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProdukForm()),
              );
              // Refresh after returning
              setState(() {
                _futureProduks = ProdukBloc.getProduks();
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                await LogoutBloc.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Produk>>(
        future: _futureProduks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Gagal memuat produk: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada produk tersedia."));
          }

          final produks = snapshot.data!;
          return ListView.builder(
            itemCount: produks.length,
            itemBuilder: (context, index) {
              return ItemProduk(produk: produks[index]);
            },
          );
        },
      ),
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
