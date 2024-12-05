class Pengeluaran {
  int? idPengeluaran;
  int idDompet;
  String judul;
  String kategori;
  DateTime tanggalDibuat;
  double jumlahUang;

  Pengeluaran({
    this.idPengeluaran,
    required this.idDompet,
    required this.judul,
    required this.kategori,
    required this.tanggalDibuat,
    required this.jumlahUang,
  });

  Map<String, dynamic> toMap() {
    return {
      'idPengeluaran': idPengeluaran,
      'idDompet': idDompet,
      'judul': judul,
      'kategori': kategori,
      'tanggalDibuat': tanggalDibuat.toIso8601String(),
      'jumlahUang': jumlahUang,
    };
  }

  factory Pengeluaran.fromMap(Map<String, dynamic> map) {
    return Pengeluaran(
      idPengeluaran: map['idPengeluaran'],
      idDompet: map['idDompet'],
      judul: map['judul'],
      kategori: map['kategori'],
      tanggalDibuat: DateTime.parse(map['tanggalDibuat']),
      jumlahUang: map['jumlahUang'],
    );
  }
}
