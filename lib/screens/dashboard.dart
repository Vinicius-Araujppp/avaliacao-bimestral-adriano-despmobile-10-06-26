import 'package:flutter/material.dart';

import '../repository/tipo_persistencia.dart';
import 'contato/lista.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Escolha onde persistir os contatos',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _OpcaoPersistencia(
            tipo: TipoPersistencia.local,
            icon: Icons.storage,
            onTap: () => _abrirLista(context, TipoPersistencia.local),
          ),
          const SizedBox(height: 12),
          _OpcaoPersistencia(
            tipo: TipoPersistencia.remota,
            icon: Icons.cloud_sync,
            onTap: () => _abrirLista(context, TipoPersistencia.remota),
          ),
        ],
      ),
    );
  }

  void _abrirLista(BuildContext context, TipoPersistencia tipo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaContatos(tipoPersistencia: tipo),
      ),
    );
  }
}

class _OpcaoPersistencia extends StatelessWidget {
  final TipoPersistencia tipo;
  final IconData icon;
  final VoidCallback onTap;

  const _OpcaoPersistencia({
    required this.tipo,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(tipo.titulo),
        subtitle: Text(tipo.descricao),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
