class Dompet {
  int? idDompet;
  String namaDompet;
  double jumlahUang;

  Dompet({
    this.idDompet,
    required this.namaDompet,
    required this.jumlahUang,
  });

  Map<String, dynamic> toMap() {
    return {
      'idDompet': idDompet,
      'namaDompet': namaDompet,
      'jumlahUang': jumlahUang,
    };
  }

  factory Dompet.fromMap(Map<String, dynamic> map) {
    return Dompet(
      idDompet: map['idDompet'],
      namaDompet: map['namaDompet'],
      jumlahUang: map['jumlahUang'],
    );
  }
}
