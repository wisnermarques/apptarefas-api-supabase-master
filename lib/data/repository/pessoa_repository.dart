import 'package:app_gerenciamento_de_tarefas/data/model/pessoa.dart';

import '../../api/helper.dart';

class PessoaRepository {


  Future<List<Pessoa>> getPessoas() async {
    try {
      final response = await SupabaseHelper.client
          .from('pessoa')
          .select('*');

      return (response as List).map((item) => Pessoa.fromMap(item)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar tarefas: $e');
    }
  }
}