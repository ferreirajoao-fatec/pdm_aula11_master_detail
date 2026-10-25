class NoticiaModel {
  final int id;
  final String titulo;
  final String resumo;
  final String conteudoCompleto;
  final String autor;
  final String urlImagem;

  NoticiaModel({
    required this.id,
    required this.titulo,
    required this.resumo,
    required this.conteudoCompleto,
    required this.autor,
    required this.urlImagem,
  });

  factory NoticiaModel.fromJson(Map<String, dynamic> json) {
    final String? body = json['body'];
    return NoticiaModel(
      id: json['id'] ?? 0,
      titulo: json['title'] ?? 'Sem título',
      // Evita RangeError quando o texto tem menos de 40 caracteres
      resumo: body != null ? (body.length > 40 ? body.substring(0, 40) + '...' : body) : '',
      conteudoCompleto: body ?? 'Sem conteúdo disponível.',
      autor: 'Autor ID ' + (json['userId']?.toString() ?? '1'),
      urlImagem: 'https://picsum.photos/seed/noticia${json['id'] ?? 0}/600/300',
    );
  }
}
