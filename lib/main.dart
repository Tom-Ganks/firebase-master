import 'package:app_gerenciamento_de_tarefas/presentation/pages/livro_page.dart';
import 'package:app_gerenciamento_de_tarefas/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Livros',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const LoginPage(),
      routes: {
        '/home': (context) => const LivroPage(),
      },
    );
  }
}
