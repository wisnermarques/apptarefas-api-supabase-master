import 'package:app_gerenciamento_de_tarefas/data/repository/tarefa_repository.dart';
import 'package:app_gerenciamento_de_tarefas/presentation/viewmodel/pessoa_viewmodel.dart';
import 'package:app_gerenciamento_de_tarefas/presentation/viewmodel/tarefa_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/model/pessoa.dart';
import '../../data/model/tarefa.dart';
import '../../data/repository/pessoa_repository.dart';

class CadastroTarefa extends StatefulWidget {
  const CadastroTarefa({super.key});

  @override
  State<CadastroTarefa> createState() => _CadastroTarefaState();
}

class _CadastroTarefaState extends State<CadastroTarefa> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final descricaoController = TextEditingController();
  final dataInicioController = TextEditingController();
  final dataFimController = TextEditingController();
  final TarefaViewmodel _viewModel = TarefaViewmodel(TarefaRepository());
  final PessoaViewmodel _viewModelPessoa = PessoaViewmodel(PessoaRepository());
  String _status = 'Pendente'; // Valor padrão para o status
  Pessoa? _pessoaSelecionada;
  List<Pessoa> _pessoas = [];

  // Método para salvar a tarefa
  Future<void> saveTarefa() async {
    try {
      if (_formKey.currentState!.validate()) {
        // Parse das datas
        final dataInicio = dataInicioController.text.isNotEmpty
            ? DateFormat('dd/MM/yyyy').parse(dataInicioController.text)
            : null;

        final dataFim = dataFimController.text.isNotEmpty
            ? DateFormat('dd/MM/yyyy').parse(dataFimController.text)
            : null;

        final tarefa = Tarefa(
            nome: nomeController.text,
            descricao: descricaoController.text,
            status: _status,
            dataInicio: dataInicio,
            dataFim: dataFim,
            idPessoa: _pessoaSelecionada?.id);

        await _viewModel.addTarefa(tarefa);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tarefa adicionada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Fecha a página após salvar
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao salvar a tarefa: ${e.toString()}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Método para exibir o calendário e formatar a data
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> carregarPessoas() async {
    final pessoas = await _viewModelPessoa.getPessoa();
    if (mounted) {
      setState(() {
        _pessoas = pessoas;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    carregarPessoas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Tarefas'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Cadastrar uma Tarefa',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Campo Nome
                      TextFormField(
                        controller: nomeController,
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          labelStyle: TextStyle(color: Colors.teal.shade700),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal.shade700),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor entre com um nome';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Campo Descrição
                      TextFormField(
                        controller: descricaoController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Descrição',
                          labelStyle: TextStyle(color: Colors.teal.shade700),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal.shade700),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Campo Status
                      DropdownButtonFormField<String>(
                        value: _status,
                        decoration: InputDecoration(
                          labelText: 'Status',
                          labelStyle: TextStyle(color: Colors.teal.shade700),
                          border: const OutlineInputBorder(),
                        ),
                        items: ['Pendente', 'Em andamento', 'Concluída']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _status = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      // Campo Data de Início
                      TextFormField(
                        controller: dataInicioController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Data de Início',
                          labelStyle: TextStyle(color: Colors.teal.shade700),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal.shade700),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () =>
                                _selectDate(context, dataInicioController),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor entre com a data de início';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Campo Data de Fim
                      TextFormField(
                        controller: dataFimController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Data de Fim',
                          labelStyle: TextStyle(color: Colors.teal.shade700),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal.shade700),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () =>
                                _selectDate(context, dataFimController),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<Pessoa>(
                        value: _pessoaSelecionada,
                        decoration: InputDecoration(
                          labelText: 'Usuário',
                          labelStyle: TextStyle(color: Colors.teal.shade700),
                          border: const OutlineInputBorder(),
                        ),
                        items: _pessoas.map((Pessoa pessoa) {
                          return DropdownMenuItem<Pessoa>(
                            value: pessoa,
                            child: Text(pessoa.nome),
                          );
                        }).toList(),
                        onChanged: (Pessoa? novaPessoa) {
                          setState(() {
                            _pessoaSelecionada = novaPessoa;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Por favor selecione um usuário';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 30),
                      // Botão de Salvar
                      ElevatedButton.icon(
                        onPressed: saveTarefa,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 30.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        icon: const Icon(Icons.save, size: 24),
                        label: const Text(
                          'Salvar',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
