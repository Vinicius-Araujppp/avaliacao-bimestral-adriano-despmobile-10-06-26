class Contato {
  final int? id;
  final String nome;
  final String telefone;
  final String email;

  const Contato({
    this.id,
    required this.nome,
    required this.telefone,
    required this.email,
  });

  Contato copyWith({
    int? id,
    String? nome,
    String? telefone,
    String? email,
  }) {
    return Contato(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'telefone': telefone,
      'email': email,
    };
  }

  factory Contato.fromMap(Map<String, dynamic> map) {
    return Contato(
      id: _parseId(map['id']),
      nome: map['nome']?.toString() ?? '',
      telefone: map['telefone']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
    );
  }

  static int? _parseId(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  @override
  String toString() {
    return 'Contato{id: $id, nome: $nome, telefone: $telefone, email: $email}';
  }
}
