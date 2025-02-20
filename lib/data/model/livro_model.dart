class Livro {
  String? id;
  String titulo;
  String autor;
  String descricao;
  int avaliacao; // Avaliação de 1 a 5 estrelas
  String? capaUrl; // URL da imagem da capa do livro

  Livro({
    this.id,
    required this.titulo,
    required this.autor,
    required this.descricao,
    required this.avaliacao,
    this.capaUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'autor': autor,
      'descricao': descricao,
      'avaliacao': avaliacao,
      'capaUrl': capaUrl,
    };
  }
}
