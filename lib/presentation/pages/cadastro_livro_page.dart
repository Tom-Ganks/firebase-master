import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:app_gerenciamento_de_tarefas/data/model/livro_model.dart';
import 'package:app_gerenciamento_de_tarefas/presentation/viewmodel/livro_viewmodel.dart';
import '../../data/repository/livro_repository.dart';

class CadastroLivroPage extends StatefulWidget {
  final Livro? livro; // Livro a ser editado (opcional)

  const CadastroLivroPage({super.key, this.livro});

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

  @override
  void initState() {
    super.initState();
    // Se um livro foi passado, preencha os campos com os dados existentes
    if (widget.livro != null) {
      tituloController.text = widget.livro!.titulo;
      autorController.text = widget.livro!.autor;
      sinopseController.text = widget.livro!.descricao;
      avaliacao = widget.livro!.avaliacao.toDouble();
    }
  }

  Future<void> saveLivro() async {
    try {
      if (_formKey.currentState!.validate()) {
        final livro = Livro(
          id: widget.livro?.id, // Mantém o ID se estiver editando
          titulo: tituloController.text,
          autor: autorController.text,
          descricao: sinopseController.text,
          avaliacao: avaliacao.toInt(),
        );

        if (widget.livro == null) {
          // Adicionar novo livro
          await _viewModel.addLivro(livro);
        } else {
          // Atualizar livro existente
          await _viewModel.updateLivro(livro.id!, livro);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Livro salvo com sucesso!')),
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
        title: Text(
          widget.livro == null ? 'Cadastro de Livro' : 'Editar Livro',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Volta para a página anterior
          },
        ),
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
                  labelText: 'Sinopse',
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