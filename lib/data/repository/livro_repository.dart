import '../../core/database.dart';
import '../model/livro_model.dart';

class LivroRepository {
  final String collection = 'livros';

  Future<void> insertLivro(Livro livro) async {
    await DatabaseHelper.addDocument(collection, livro.toMap());
  }

  Future<List<Livro>> getLivros() async {
    List<Map<String, dynamic>> livroMaps =
        await DatabaseHelper.getDocuments(collection);
    return livroMaps.map((map) {
      return Livro(
        id: map['id'],
        titulo: map['titulo'],
        autor: map['autor'],
        descricao: map['descricao'],
        avaliacao: map['avaliacao'],
        capaUrl: map['capaUrl'],
      );
    }).toList();
  }

  Future<void> updateLivro(String id, Livro livro) async {
    await DatabaseHelper.updateDocument(collection, id, livro.toMap());
  }

  Future<void> deleteLivro(String id) async {
    await DatabaseHelper.deleteDocument(collection, id);
  }
}
