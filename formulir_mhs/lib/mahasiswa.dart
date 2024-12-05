class Mahasiswa {
  int? id;
  String npm;
  String nama;
  int umur;

  Mahasiswa({this.id, required this.npm, required this.nama, required this.umur});

  // Konversi dari Map (SQLite) ke Model
  factory Mahasiswa.fromMap(Map<String, dynamic> map) {
    return Mahasiswa(
      id: map['id'],
      npm: map['npm'],
      nama: map['nama'],
      umur: map['umur'],
    );
  }

  // Konversi dari Model ke Map (SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'npm': npm,
      'nama': nama,
      'umur': umur,
    };
  }
}