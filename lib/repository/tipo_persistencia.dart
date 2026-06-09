enum TipoPersistencia {
  local,
  remota,
}

extension TipoPersistenciaDescricao on TipoPersistencia {
  String get titulo {
    switch (this) {
      case TipoPersistencia.local:
        return 'SQLite local';
      case TipoPersistencia.remota:
        return 'API Render';
    }
  }

  String get descricao {
    switch (this) {
      case TipoPersistencia.local:
        return 'Persistencia local no aparelho';
      case TipoPersistencia.remota:
        return 'Persistencia remota via PostgreSQL no Render';
    }
  }
}
