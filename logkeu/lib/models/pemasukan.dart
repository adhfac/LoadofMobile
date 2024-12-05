class Pemasukan {
  int? idPemasukan;
  int idDompet;
  String judul;
  String kategori;
  DateTime tanggalDibuat;
  double jumlahUang;

  Pemasukan({
    this.idPemasukan,
    required this.idDompet,
    required this.judul,
    required this.kategori,
    required this.tanggalDibuat,
    required this.jumlahUang,
  });

  // Mengonversi objek Pemasukan ke Map (untuk penyimpanan di SQLite)
  Map<String, dynamic> toMap() {
    return {
      'idPemasukan': idPemasukan,
      'idDompet': idDompet,
      'judul': judul,
      'kategori': kategori,
      'tanggalDibuat': tanggalDibuat.toIso8601String(),
      'jumlahUang': jumlahUang,
    };
  }

  // Mengonversi Map ke objek Pemasukan
  factory Pemasukan.fromMap(Map<String, dynamic> map) {
    return Pemasukan(
      idPemasukan: map['idPemasukan'],
      idDompet: map['idDompet'],
      judul: map['judul'],
      kategori: map['kategori'],
      tanggalDibuat: DateTime.parse(map['tanggalDibuat']),
      jumlahUang: map['jumlahUang'],
    );
  }
}
