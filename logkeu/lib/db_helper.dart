import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/dompet.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._privateConstructor();
  static Database? _database;

  DBHelper._privateConstructor();

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'pencatat_keuangan.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE dompet(
            idDompet INTEGER PRIMARY KEY AUTOINCREMENT,
            namaDompet TEXT,
            jumlahUang REAL
          )
        ''');

        await db.execute('''
          CREATE TABLE pengeluaran(
            idPengeluaran INTEGER PRIMARY KEY AUTOINCREMENT,
            idDompet INTEGER,
            judul TEXT,
            kategori TEXT,
            tanggalDibuat TEXT,
            jumlahUang REAL,
            FOREIGN KEY(idDompet) REFERENCES dompet(idDompet)
          )
        ''');

        await db.execute('''
          CREATE TABLE pemasukan(
            idPemasukan INTEGER PRIMARY KEY AUTOINCREMENT,
            idDompet INTEGER,
            judul TEXT,
            kategori TEXT,
            tanggalDibuat TEXT,
            jumlahUang REAL,
            FOREIGN KEY(idDompet) REFERENCES dompet(idDompet)
          )
        ''');

        await db.execute('''
          CREATE TRIGGER pemasukan_insert_trigger
          AFTER INSERT ON pemasukan
          BEGIN
            UPDATE dompet
            SET jumlahUang = jumlahUang + NEW.jumlahUang
            WHERE idDompet = NEW.idDompet;
          END;
        ''');

        await db.execute('''
          CREATE TRIGGER pemasukan_delete_trigger
          AFTER DELETE ON pemasukan
          BEGIN
            UPDATE dompet
            SET jumlahUang = jumlahUang - OLD.jumlahUang
            WHERE idDompet = OLD.idDompet;
          END;
        ''');

        await db.execute('''
          CREATE TRIGGER pengeluaran_insert_trigger
          AFTER INSERT ON pengeluaran
          BEGIN
            UPDATE dompet
            SET jumlahUang = jumlahUang - NEW.jumlahUang
            WHERE idDompet = NEW.idDompet;
          END;
        ''');

        await db.execute('''
          CREATE TRIGGER pengeluaran_delete_trigger
          AFTER DELETE ON pengeluaran
          BEGIN
            UPDATE dompet
            SET jumlahUang = jumlahUang + OLD.jumlahUang
            WHERE idDompet = OLD.idDompet;
          END;
        ''');
      },
    );
  }

  static Future<List<Dompet>> getDompetList() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('dompet');
      return List.generate(maps.length, (i) {
        return Dompet(
          idDompet: maps[i]['idDompet'],
          namaDompet: maps[i]['namaDompet'],
          jumlahUang: maps[i]['jumlahUang'],
        );
      });
    } catch (e) {
      print('Error fetching dompet list: $e');
      return [];
    }
  }

  static Future<int> insertDompet(Dompet dompet) async {
    final db = await database;
    return await db.insert('dompet', dompet.toMap());
  }

  static Future<int> updateDompet(Dompet dompet) async {
    final db = await database;
    return await db.update(
      'dompet',
      dompet.toMap(),
      where: 'idDompet = ?',
      whereArgs: [dompet.idDompet],
    );
  }

  static Future<int> deleteDompet(int id) async {
    final db = await database;
    return await db.delete(
      'dompet',
      where: 'idDompet = ?',
      whereArgs: [id],
    );
  }

  static Future<Dompet?> getDompetById(int id) async {
    final db = await database;
    final result = await db.query('dompet', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Dompet.fromMap(result.first);
    }
    return null;
  }

  static Future<int> insertPemasukan(Map<String, dynamic> pemasukan) async {
    final db = await database;
    var dompet = await db.query(
      'dompet',
      columns: ['jumlahUang'],
      where: 'idDompet = ?',
      whereArgs: [pemasukan['idDompet']],
    );
    if (dompet.isNotEmpty) {
      double saldoSekarang = dompet.first['jumlahUang'] as double;
      double jumlahPemasukan = pemasukan['jumlahUang']; // Pastikan 'jumlah' ada di pemasukan

      double saldoBaru = saldoSekarang + jumlahPemasukan;

      await db.update(
        'dompet',
        {'jumlahUang': saldoBaru},
        where: 'idDompet = ?',
        whereArgs: [pemasukan['idDompet']],
      );
    }
    return await db.insert('pemasukan', pemasukan);
  }

// Menghapus pemasukan
  static Future<int> deletePemasukan(int id) async {
    final db = await database;
    return await db.delete(
      'pemasukan',
      where: 'idPemasukan = ?',
      whereArgs: [id],
    );
  }

// Mendapatkan daftar pemasukan berdasarkan idDompet
  static Future<List<Map<String, dynamic>>> getPemasukanByDompet(
      int idDompet) async {
    final db = await database;
    return await db.query(
      'pemasukan',
      where: 'idDompet = ?',
      whereArgs: [idDompet],
    );
  }

  static Future<int> insertPengeluaran(Map<String, dynamic> pengeluaran) async {
    final db = await database;
    var dompet = await db.query(
      'dompet',
      columns: ['jumlahUang'],
      where: 'idDompet = ?',
      whereArgs: [pengeluaran['idDompet']],
    );
    if (dompet.isNotEmpty) {
      double saldoSekarang = dompet.first['jumlahUang'] as double;
      double jumlahPengeluaran = pengeluaran['jumlahUang']; // Pastikan 'jumlah' ada di pemasukan

      double saldoBaru = saldoSekarang - jumlahPengeluaran;

      await db.update(
        'dompet',
        {'jumlahUang': saldoBaru},
        where: 'idDompet = ?',
        whereArgs: [pengeluaran['idDompet']],
      );
    }
    return await db.insert('pengeluaran', pengeluaran);
  }

  static Future<int> deletePengeluaran(int id) async {
    final db = await database;
    return await db.delete(
      'pengeluaran',
      where: 'idPengeluaran = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getPengeluaranByDompet(
      int idDompet) async {
    final db = await database;
    return await db.query(
      'pengeluaran',
      where: 'idDompet = ?',
      whereArgs: [idDompet],
    );
  }
}
