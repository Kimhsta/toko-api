class Produk {
  int? id;
  String? kodeProduk;
  String? namaProduk;
  int? hargaProduk;

  Produk({this.id, this.kodeProduk, this.namaProduk, this.hargaProduk});

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'],
      kodeProduk: json['nobarcode'], // sesuaikan dengan nama di DB dan API
      namaProduk: json['nama'],
      hargaProduk: int.tryParse(json['harga'].toString().split('.')[0]),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nobarcode': kodeProduk,
    'nama': namaProduk,
    'harga': hargaProduk,
  };
}
