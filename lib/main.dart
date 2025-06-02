import 'package:flutter/material.dart';
import 'api/helper.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await SupabaseHelper.initialize();
    runApp(const MyApp());
  } catch (e) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Erro ao conectar com o banco de dados: $e'),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gerenciador de Tarefas',
      home: HomePage(),
    );
  }
}
