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
        title: const Text('Produk Xiaomi'),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Admin"),
              accountEmail: Text("admin@tokokita.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
              ),
              decoration: BoxDecoration(color: Colors.deepPurple),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToForm,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
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
    return ListView.separated(
      itemCount: list.length,
      padding: const EdgeInsets.all(8),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) => ItemProduk(produk: list[i]),
    );
  }
}

class ItemProduk extends StatelessWidget {
  final Produk produk;

  const ItemProduk({Key? key, required this.produk}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple[100],
          child: const Icon(Icons.phone_android, color: Colors.deepPurple),
        ),
        title: Text(
          produk.namaProduk ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Rp ${produk.hargaProduk}",
          style: const TextStyle(color: Colors.black54),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProdukDetail(produk: produk),
            ),
          );
        },
      ),
    );
  }
}
