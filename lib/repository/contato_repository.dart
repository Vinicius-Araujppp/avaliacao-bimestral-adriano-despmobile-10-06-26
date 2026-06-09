import 'package:sqflite/sqflite.dart';

import '../db/app_database.dart';
import '../models/contato.dart';
import '../services/contato_api_service.dart';
import 'tipo_persistencia.dart';

class ContatoRepository {
  final TipoPersistencia tipo;
  final AppDatabase _database;
  final ContatoApiService _apiService;

  ContatoRepository({
    required this.tipo,
    AppDatabase? database,
    ContatoApiService? apiService,
  })  : _database = database ?? AppDatabase(),
        _apiService = apiService ?? ContatoApiService();

  Future<List<Contato>> listar() {
    return tipo == TipoPersistencia.local ? _listarLocal() : _apiService.listar();
  }

  Future<Contato> cadastrar(Contato contato) {
    return tipo == TipoPersistencia.local
        ? _cadastrarLocal(contato)
        : _apiService.cadastrar(contato);
  }

  Future<Contato> atualizar(Contato contato) {
    return tipo == TipoPersistencia.local
        ? _atualizarLocal(contato)
        : _apiService.atualizar(contato);
  }

  Future<void> deletar(int id) {
    return tipo == TipoPersistencia.local ? _deletarLocal(id) : _apiService.deletar(id);
  }

  Future<List<Contato>> _listarLocal() async {
    final Database db = await _database.database;
    final maps = await db.query(
      AppDatabase.contatosTable,
      orderBy: 'nome COLLATE NOCASE',
    );
    return maps.map(Contato.fromMap).toList();
  }

  Future<Contato> _cadastrarLocal(Contato contato) async {
    final Database db = await _database.database;
    final id = await db.insert(
      AppDatabase.contatosTable,
      contato.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return contato.copyWith(id: id);
  }

  Future<Contato> _atualizarLocal(Contato contato) async {
    if (contato.id == null) {
      throw Exception('Contato local sem id para atualizacao.');
    }

    final Database db = await _database.database;
    await db.update(
      AppDatabase.contatosTable,
      contato.toMap(),
      where: 'id = ?',
      whereArgs: [contato.id],
    );
    return contato;
  }

  Future<void> _deletarLocal(int id) async {
    final Database db = await _database.database;
    await db.delete(
      AppDatabase.contatosTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
