import 'package:flutter/material.dart';
import 'package:app_gerenciamento_de_tarefas/data/model/livro_model.dart';
import 'package:app_gerenciamento_de_tarefas/data/repository/livro_repository.dart';
import 'package:app_gerenciamento_de_tarefas/presentation/viewmodel/livro_viewmodel.dart';
import 'cadastro_livro_page.dart';
import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importe o Firebase Auth

class LivroPage extends StatefulWidget {
  const LivroPage({super.key});

  @override
  LivroPageState createState() => LivroPageState();
}

class LivroPageState extends State<LivroPage> {
  final LivroViewmodel _viewModel = LivroViewmodel(LivroRepository());
  late Future<List<Livro>> _livrosFuture;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instância do Firebase Auth

  @override
  void initState() {
    super.initState();
    _livrosFuture = _viewModel.getLivros();
  }

  // Método para fazer logout
  Future<void> _logout() async {
    await _auth.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Livros', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.person, color: Colors.white), // Ícone de pessoa
          onPressed: () {
            // Mostrar um menu com a opção de logout
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Opções'),
                  content: const Text('Deseja fazer logout?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Fechar o diálogo
                      },
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _logout(); // Fazer logout
                      },
                      child: const Text('Logout', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                );
              },
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // Navegar para a página de edição do livro
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CadastroLivroPage(livro: livro),
                              ),
                            ).then((result) {
                              // Recarregar a lista após a edição
                              if (result == true) {
                                setState(() {
                                  _livrosFuture = _viewModel.getLivros();
                                });
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _viewModel.deleteLivro(livro.id!);
                            setState(() {
                              _livrosFuture = _viewModel.getLivros();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CadastroLivroPage()),
          );

          // Se um livro foi cadastrado, recarregue a lista
          if (result == true) {
            setState(() {
              _livrosFuture = _viewModel.getLivros();
            });
          }
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}