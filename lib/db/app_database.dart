import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static const String contatosTable = 'contatos';
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final String path = join(await getDatabasesPath(), 'contatos.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $contatosTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            telefone TEXT NOT NULL,
            email TEXT NOT NULL
          )
        ''');
      },
    );
  }
}
