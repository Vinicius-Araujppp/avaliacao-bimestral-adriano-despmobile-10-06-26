import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/contato.dart';

class ContatoApiService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://sua-api-no-render.onrender.com',
  );

  final http.Client _client;

  ContatoApiService({http.Client? client}) : _client = client ?? http.Client();

  Uri _uri([String path = '']) {
    return Uri.parse('$baseUrl/contatos$path');
  }

  Future<List<Contato>> listar() async {
    final response = await _client.get(_uri());
    _validarResposta(response);

    final decoded = jsonDecode(response.body);
    final List<dynamic> data = decoded is List
        ? decoded
        : (decoded is Map<String, dynamic> ? decoded['data'] ?? [] : []);
    return data
        .map((item) => Contato.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<Contato> cadastrar(Contato contato) async {
    final response = await _client.post(
      _uri(),
      headers: _headers,
      body: jsonEncode(contato.toMap()),
    );
    _validarResposta(response);
    return Contato.fromMap(Map<String, dynamic>.from(jsonDecode(response.body)));
  }

  Future<Contato> atualizar(Contato contato) async {
    if (contato.id == null) {
      throw Exception('Contato remoto sem id para atualizacao.');
    }

    final response = await _client.put(
      _uri('/${contato.id}'),
      headers: _headers,
      body: jsonEncode(contato.toMap()),
    );
    _validarResposta(response);
    return Contato.fromMap(Map<String, dynamic>.from(jsonDecode(response.body)));
  }

  Future<void> deletar(int id) async {
    final response = await _client.delete(_uri('/$id'));
    _validarResposta(response);
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  void _validarResposta(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Erro na API (${response.statusCode}): ${response.body}',
      );
    }
  }
}
