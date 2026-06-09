import 'package:flutter/material.dart';

import '../../components/editor.dart';
import '../../models/contato.dart';

class FormularioContato extends StatefulWidget {
  final Contato? contato;

  const FormularioContato({super.key, this.contato});

  @override
  State<FormularioContato> createState() => FormularioContatoState();
}

class FormularioContatoState extends State<FormularioContato> {
  static const _rotuloNome = 'Nome';
  static const _dicaNome = 'Ex: Joao Silva';
  static const _rotuloTelefone = 'Telefone';
  static const _dicaTelefone = '(11) 99999-9999';
  static const _rotuloEmail = 'Email';
  static const _dicaEmail = 'exemplo@email.com';

  late final TextEditingController _controladorCampoNome;
  late final TextEditingController _controladorCampoTelefone;
  late final TextEditingController _controladorCampoEmail;

  bool get _editando => widget.contato != null;

  @override
  void initState() {
    super.initState();
    _controladorCampoNome = TextEditingController(text: widget.contato?.nome);
    _controladorCampoTelefone = TextEditingController(text: widget.contato?.telefone);
    _controladorCampoEmail = TextEditingController(text: widget.contato?.email);
  }

  @override
  void dispose() {
    _controladorCampoNome.dispose();
    _controladorCampoTelefone.dispose();
    _controladorCampoEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Atualizar Contato' : 'Adicionar Contato'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Editor(
              controlador: _controladorCampoNome,
              rotulo: _rotuloNome,
              dica: _dicaNome,
              icone: Icons.person,
            ),
            Editor(
              controlador: _controladorCampoTelefone,
              rotulo: _rotuloTelefone,
              dica: _dicaTelefone,
              icone: Icons.phone,
              tipoTeclado: TextInputType.phone,
            ),
            Editor(
              controlador: _controladorCampoEmail,
              rotulo: _rotuloEmail,
              dica: _dicaEmail,
              icone: Icons.email,
              tipoTeclado: TextInputType.emailAddress,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: Text(_editando ? 'Atualizar' : 'Salvar'),
                  onPressed: _salvarContato,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _salvarContato() {
    final nome = _controladorCampoNome.text.trim();
    final telefone = _controladorCampoTelefone.text.trim();
    final email = _controladorCampoEmail.text.trim();

    if (nome.isEmpty || telefone.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos.')),
      );
      return;
    }

    Navigator.pop(
      context,
      Contato(
        id: widget.contato?.id,
        nome: nome,
        telefone: telefone,
        email: email,
      ),
    );
  }
}
