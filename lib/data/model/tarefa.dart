class Tarefa {
  final int? id;
  final String nome;
  final String descricao;
  final String status;
  final DateTime? dataInicio; // Alterado para DateTime
  final DateTime? dataFim; // Alterado para DateTime

  Tarefa({
    this.id,
    required this.nome,
    this.descricao = '', // Valor padrão para descrição
    required this.status,
    this.dataInicio, // Agora pode ser null
    this.dataFim, // Agora pode ser null
  });

  // Converte para Map (útil para operações com Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'status': status,
      'data_inicio':
          dataInicio?.toIso8601String(), // Convertendo para ISO String
      'data_fim': dataFim?.toIso8601String(), // Convertendo para ISO String
    };
  }

  // Factory method para criar a partir de um Map (útil para leitura do Supabase)
  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      descricao: map['descricao'] as String? ?? '',
      status: map['status'] as String,
      dataInicio: map['data_inicio'] != null
          ? DateTime.parse(map['data_inicio'] as String)
          : null,
      dataFim: map['data_fim'] != null
          ? DateTime.parse(map['data_fim'] as String)
          : null,
    );
  }
}
