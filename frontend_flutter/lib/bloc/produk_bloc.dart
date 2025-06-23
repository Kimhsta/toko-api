import 'dart:convert';
import 'package:frontend_flutter/helpers/api.dart';
import 'package:frontend_flutter/helpers/api_url.dart';
import 'package:frontend_flutter/model/produk.dart';

/// BLoC (Business Logic Component) untuk manajemen data produk.
class ProdukBloc {
  /// Mengambil daftar semua produk dari server
  static Future<List<Produk>> getProduks() async {
    String apiUrl = ApiUrl.listProduk;

    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);

    // Ambil data produk dari field 'data' pada response JSON
    List<dynamic> listProduk = (jsonObj as Map<String, dynamic>)['data'];
    List<Produk> produks =
        listProduk.map((item) => Produk.fromJson(item)).toList();

    return produks;
  }

  /// Menambahkan produk baru ke server
  static Future<bool> addProduk({required Produk produk}) async {
    String apiUrl = ApiUrl.createProduk;

    var body = {
      "kode_produk": produk.kodeProduk,
      "nama_produk": produk.namaProduk,
      "harga": produk.hargaProduk.toString(),
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);

    return jsonObj['status'] == true;
  }

  /// Mengupdate produk berdasarkan ID
  static Future<bool> updateProduk({required Produk produk}) async {
    String apiUrl = ApiUrl.updateProduk(produk.id!);

    var body = {
      "kode_produk": produk.kodeProduk,
      "nama_produk": produk.namaProduk,
      "harga": produk.hargaProduk.toString(),
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);

    return jsonObj['data'] == true;
  }

  /// Menghapus produk berdasarkan ID
  static Future<bool> deleteProduk({required int id}) async {
    String apiUrl = ApiUrl.deleteProduk(id);

    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);

    return (jsonObj as Map<String, dynamic>)['data'] == true;
  }
}
