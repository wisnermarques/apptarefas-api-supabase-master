import '../../data/model/pessoa.dart';
import '../../data/repository/pessoa_repository.dart';

class PessoaViewmodel {
  final PessoaRepository repository;

  PessoaViewmodel(this.repository);


  Future<List<Pessoa>> getPessoa() async {
    return await repository.getPessoas();
  }

}
