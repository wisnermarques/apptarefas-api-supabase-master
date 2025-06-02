import '../../api/helper.dart';
import '../model/tarefa.dart';

class TarefaRepository {
  Future<void> insertTarefa(Tarefa tarefa) async {
    try {
      await SupabaseHelper.client.from('tarefas').insert(tarefa.toMap());
    } catch (e) {
      throw Exception('Erro ao criar tarefa: $e');
    }
  }

  Future<List<Tarefa>> getTarefas() async {
    try {
      final response = await SupabaseHelper.client
          .from('tarefas')
          .select('*, pessoa(*)') // 👈 Faz o JOIN!
          .order('data_inicio', ascending: false);

      return (response as List).map((item) => Tarefa.fromMap(item)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar tarefas: $e');
    }
  }

  Future<void> updateTarefa(Tarefa tarefa) async {
    try {
      await SupabaseHelper.client
          .from('tarefas')
          .update(tarefa.toMap())
          .eq('id', tarefa.id!);
    } catch (e) {
      throw Exception('Erro ao atualizar tarefa: $e');
    }
  }

  Future<void> deleteTarefa(int id) async {
    try {
      await SupabaseHelper.client.from('tarefas').delete().eq('id', id);
    } catch (e) {
      throw Exception('Erro ao deletar tarefa: $e');
    }
  }
}
