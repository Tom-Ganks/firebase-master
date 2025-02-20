import '../../data/model/livro_model.dart';
import '../../data/repository/livro_repository.dart';

class LivroViewmodel {
  final LivroRepository repository;

  LivroViewmodel(this.repository);

  Future<void> addLivro(Livro livro) async {
    await repository.insertLivro(livro);
  }

  Future<List<Livro>> getLivros() async {
    return await repository.getLivros();
  }

  Future<void> updateLivro(String id, Livro livro) async {
    await repository.updateLivro(id, livro);
  }

  Future<void> deleteLivro(String id) async {
    await repository.deleteLivro(id);
  }
}
