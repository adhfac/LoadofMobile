import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'mahasiswa.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._privateConstructor();
  static Database? _database;

  DBHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'mahasiswa.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE mahasiswa(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            npm TEXT NOT NULL,
            nama TEXT NOT NULL,
            umur INTEGER NOT NULL
          )
        ''');
      },
      version: 1,
    );
  }

  Future<List<Mahasiswa>> getMahasiswaList() async {
    final db = await database;
    final result = await db.query('mahasiswa');
    return result.map((map) => Mahasiswa.fromMap(map)).toList();
  }

  Future<int> addMahasiswa(Mahasiswa mahasiswa) async {
    final db = await database;
    return await db.insert('mahasiswa', mahasiswa.toMap());
  }

  Future<Mahasiswa?> getMahasiswaById(int id) async {
    final db = await database;
    final result = await db.query('mahasiswa', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Mahasiswa.fromMap(result.first);
    }
    return null;
  }

  Future<int> deleteMahasiswa(int id) async {
  final db = await database;
  return await db.delete('mahasiswa', where: 'id = ?', whereArgs: [id]);
}
}


