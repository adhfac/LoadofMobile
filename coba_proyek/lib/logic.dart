class Dompet {
  String namaRekening;
  double saldo;

  Dompet({required this.namaRekening, this.saldo = 0.0});
}

// CatatanKeuangan.dart
class CatatanKeuangan {
  String kategori;
  double jumlah;
  DateTime tanggal;
  String namaDompet;

  CatatanKeuangan({
    required this.kategori,
    required this.jumlah,
    required this.tanggal,
    required this.namaDompet,
  });
}