class Pessoa {
  final int id;
  final String nome;

  Pessoa({required this.id, required this.nome});

  factory Pessoa.fromMap(Map<String, dynamic> map) {
    return Pessoa(
      id: map['id'] as int,
      nome: map['nome'] as String,
    );
  }
}
