import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Importe o pacote
import '../../data/model/livro_model.dart';
import '../../data/repository/livro_repository.dart';
import '../viewmodel/livro_viewmodel.dart';

class CadastroLivroPage extends StatefulWidget {
  const CadastroLivroPage({super.key});

  @override
  CadastroLivroPageState createState() => CadastroLivroPageState();
}

class CadastroLivroPageState extends State<CadastroLivroPage> {
  final _formKey = GlobalKey<FormState>();
  final tituloController = TextEditingController();
  final autorController = TextEditingController();
  final sinopseController = TextEditingController();
  double avaliacao = 0.0; // Avaliação inicial
  final LivroViewmodel _viewModel = LivroViewmodel(LivroRepository());

  Future<void> saveLivro() async {
    try {
      if (_formKey.currentState!.validate()) {
        final livro = Livro(
          titulo: tituloController.text,
          autor: autorController.text,
          descricao: sinopseController.text,
          avaliacao: avaliacao.toInt(),
        );

        await _viewModel.addLivro(livro);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Livro adicionado com sucesso!')),
          );
          Navigator.pop(context, true); // Retorna "true" para indicar sucesso
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao salvar o livro: ${e.toString()}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Livro', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  labelStyle: TextStyle(color: Colors.teal.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal.shade700),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o título do livro';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: autorController,
                decoration: InputDecoration(
                  labelText: 'Autor',
                  labelStyle: TextStyle(color: Colors.teal.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal.shade700),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o autor do livro';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: sinopseController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Sinopse', // Alterado para "Sinopse"
                  labelStyle: TextStyle(color: Colors.teal.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal.shade700),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a sinopse do livro';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              RatingBar.builder(
                initialRating: avaliacao,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    avaliacao = rating;
                  });
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: saveLivro,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Salvar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}