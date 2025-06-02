import 'pessoa.dart';

class Tarefa {
  final int? id;
  final String nome;
  final String descricao;
  final String status;
  final DateTime? dataInicio;
  final DateTime? dataFim;
  final int? idPessoa;
  final Pessoa? pessoa; // 👈 Adicionado!

  Tarefa({
    this.id,
    required this.nome,
    this.descricao = '',
    required this.status,
    this.dataInicio,
    this.dataFim,
    this.idPessoa,
    this.pessoa,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'status': status,
      'data_inicio': dataInicio?.toIso8601String(),
      'data_fim': dataFim?.toIso8601String(),
      'id_pessoa': idPessoa,
    };
  }

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
      idPessoa: map['id_pessoa'] as int?,
      pessoa: map['pessoa'] != null ? Pessoa.fromMap(map['pessoa']) : null,
    );
  }
}
