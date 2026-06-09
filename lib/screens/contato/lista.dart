import 'package:flutter/material.dart';

import '../../models/contato.dart';
import '../../repository/contato_repository.dart';
import '../../repository/tipo_persistencia.dart';
import 'formulario.dart';

class ListaContatos extends StatefulWidget {
  final TipoPersistencia tipoPersistencia;

  const ListaContatos({
    super.key,
    required this.tipoPersistencia,
  });

  @override
  State<ListaContatos> createState() => ListaContatosState();
}

class ListaContatosState extends State<ListaContatos> {
  late final ContatoRepository _repository;
  List<Contato> _contatos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _repository = ContatoRepository(tipo: widget.tipoPersistencia);
    _carregarContatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos - ${widget.tipoPersistencia.titulo}'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: _carregarContatos,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirCadastro,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_contatos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.contacts_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum contato cadastrado',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _contatos.length,
      itemBuilder: (context, indice) {
        final contato = _contatos[indice];
        return ItemContato(
          contato: contato,
          onEditar: () => _abrirEdicao(contato),
          onDeletar: () => _confirmarExclusao(contato),
        );
      },
    );
  }

  Future<void> _carregarContatos() async {
    setState(() => _carregando = true);

    try {
      final contatos = await _repository.listar();
      if (!mounted) return;
      setState(() => _contatos = contatos);
    } catch (erro) {
      _mostrarMensagem('Erro ao buscar dados: $erro');
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  Future<void> _abrirCadastro() async {
    final contato = await Navigator.push<Contato>(
      context,
      MaterialPageRoute(builder: (context) => const FormularioContato()),
    );

    if (contato == null) return;

    try {
      await _repository.cadastrar(contato);
      await _carregarContatos();
      _mostrarMensagem('Contato cadastrado com sucesso.');
    } catch (erro) {
      _mostrarMensagem('Erro ao cadastrar contato: $erro');
    }
  }

  Future<void> _abrirEdicao(Contato contato) async {
    final contatoAtualizado = await Navigator.push<Contato>(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioContato(contato: contato),
      ),
    );

    if (contatoAtualizado == null) return;

    try {
      await _repository.atualizar(contatoAtualizado);
      await _carregarContatos();
      _mostrarMensagem('Contato atualizado com sucesso.');
    } catch (erro) {
      _mostrarMensagem('Erro ao atualizar contato: $erro');
    }
  }

  Future<void> _confirmarExclusao(Contato contato) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir contato'),
        content: Text('Deseja excluir ${contato.nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar != true || contato.id == null) return;

    try {
      await _repository.deletar(contato.id!);
      await _carregarContatos();
      _mostrarMensagem('Contato deletado com sucesso.');
    } catch (erro) {
      _mostrarMensagem('Erro ao deletar contato: $erro');
    }
  }

  void _mostrarMensagem(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }
}

class ItemContato extends StatelessWidget {
  final Contato contato;
  final VoidCallback onEditar;
  final VoidCallback onDeletar;

  const ItemContato({
    super.key,
    required this.contato,
    required this.onEditar,
    required this.onDeletar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(contato.nome),
        subtitle: Text('${contato.telefone}\n${contato.email}'),
        isThreeLine: true,
        trailing: Wrap(
          spacing: 4,
          children: [
            IconButton(
              tooltip: 'Editar',
              onPressed: onEditar,
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              tooltip: 'Excluir',
              onPressed: onDeletar,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
