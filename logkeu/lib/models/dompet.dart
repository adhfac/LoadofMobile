class Dompet {
  int? idDompet;
  String namaDompet;
  double jumlahUang;

  Dompet({
    this.idDompet,
    required this.namaDompet,
    required this.jumlahUang,
  });

  // Mengonversi objek Dompet ke Map (untuk penyimpanan di SQLite)
  Map<String, dynamic> toMap() {
    return {
      'idDompet': idDompet,
      'namaDompet': namaDompet,
      'jumlahUang': jumlahUang,
    };
  }

  // Mengonversi Map ke objek Dompet
  factory Dompet.fromMap(Map<String, dynamic> map) {
    return Dompet(
      idDompet: map['idDompet'],
      namaDompet: map['namaDompet'],
      jumlahUang: map['jumlahUang'],
    );
  }
}
