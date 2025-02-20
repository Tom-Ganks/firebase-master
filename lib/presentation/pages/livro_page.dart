import 'package:flutter/material.dart';
import 'package:app_gerenciamento_de_tarefas/data/model/livro_model.dart';
import 'package:app_gerenciamento_de_tarefas/data/repository/livro_repository.dart';
import 'package:app_gerenciamento_de_tarefas/presentation/viewmodel/livro_viewmodel.dart';
import 'cadastro_livro_page.dart';
import 'login_page.dart';

class LivroPage extends StatefulWidget {
  const LivroPage({super.key});

  @override
  LivroPageState createState() => LivroPageState();
}

class LivroPageState extends State<LivroPage> {
  final LivroViewmodel _viewModel = LivroViewmodel(LivroRepository());
  late Future<List<Livro>> _livrosFuture;

  @override
  void initState() {
    super.initState();
    _livrosFuture = _viewModel.getLivros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Livros', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
      ),
      body: FutureBuilder<List<Livro>>(
        future: _livrosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum livro cadastrado.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final livro = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(livro.titulo),
                    subtitle: Text(livro.autor),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _viewModel.deleteLivro(livro.id!);
                        setState(() {
                          _livrosFuture = _viewModel.getLivros();
                        });
                      },
                    ),
                    onTap: () {
                      // Navegar para a página de edição do livro
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CadastroLivroPage()),
          );
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}