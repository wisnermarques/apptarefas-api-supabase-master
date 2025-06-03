import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/model/pessoa.dart';
import '../../data/model/tarefa.dart';
import '../../data/repository/pessoa_repository.dart';
import '../../data/repository/tarefa_repository.dart';
import '../viewmodel/pessoa_viewmodel.dart';
import '../viewmodel/tarefa_viewmodel.dart';

class EditTarefaPage extends StatefulWidget {
  final Tarefa tarefa;

  const EditTarefaPage({super.key, required this.tarefa});

  @override
  State<EditTarefaPage> createState() => _EditTarefaPageState();
}

class _EditTarefaPageState extends State<EditTarefaPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nomeController;
  late TextEditingController descricaoController;
  late TextEditingController dataInicioController;
  late TextEditingController dataFimController;
  final TarefaViewmodel _viewModel = TarefaViewmodel(TarefaRepository());
  final PessoaViewmodel _viewModelPessoa = PessoaViewmodel(PessoaRepository());
  late String _status;
  Pessoa? _pessoaSelecionada;
  List<Pessoa> _pessoas = [];

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.tarefa.nome);
    descricaoController = TextEditingController(text: widget.tarefa.descricao);
    _pessoaSelecionada = widget.tarefa.pessoa;
    // Inicializa os controladores de data
    dataInicioController = TextEditingController(
        text: widget.tarefa.dataInicio != null
            ? DateFormat('dd/MM/yyyy').format(widget.tarefa.dataInicio!)
            : '');

    dataFimController = TextEditingController(
        text: widget.tarefa.dataFim != null
            ? DateFormat('dd/MM/yyyy').format(widget.tarefa.dataFim!)
            : '');

    _status = widget.tarefa.status;

    carregarPessoas();
  }

  @override
  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
    dataInicioController.dispose();
    dataFimController.dispose();
    super.dispose();
  }

  Future<void> carregarPessoas() async {
    final pessoas = await _viewModelPessoa.getPessoa();
    if (mounted) {
      setState(() {
        _pessoas = pessoas;
      });
    }
  }

  Future<void> saveEdits() async {
    if (_formKey.currentState!.validate()) {
      // Parse das datas
      DateTime? dataInicio;
      if (dataInicioController.text.isNotEmpty) {
        dataInicio = DateFormat('dd/MM/yyyy').parse(dataInicioController.text);
      }

      DateTime? dataFim;
      if (dataFimController.text.isNotEmpty) {
        dataFim = DateFormat('dd/MM/yyyy').parse(dataFimController.text);
      }

      final updatedTarefa = Tarefa(
          id: widget.tarefa.id,
          nome: nomeController.text,
          descricao: descricaoController.text,
          status: _status,
          dataInicio: dataInicio,
          dataFim: dataFim,
          idPessoa: _pessoaSelecionada!.id);

      try {
        await _viewModel.updateTarefa(updatedTarefa);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tarefa atualizada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Erro ao atualizar a tarefa: ${e.toString()}',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tarefa'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Editar Tarefa',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  DropdownButtonFormField<int>(
                    value: _pessoaSelecionada?.id,
                    decoration: InputDecoration(
                      labelText: 'Usuário',
                      labelStyle: TextStyle(color: Colors.teal.shade700),
                      border: const OutlineInputBorder(),
                    ),
                    items: _pessoas.map((Pessoa pessoa) {
                      return DropdownMenuItem<int>(
                        value: pessoa.id,
                        child: Text(pessoa.nome),
                      );
                    }).toList(),
                    onChanged: (int? novoId) {
                      setState(() {
                        _pessoaSelecionada =
                            _pessoas.firstWhere((p) => p.id == novoId);
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
                  ElevatedButton.icon(
                    onPressed: saveEdits,
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
        ),
      ),
    );
  }
}
