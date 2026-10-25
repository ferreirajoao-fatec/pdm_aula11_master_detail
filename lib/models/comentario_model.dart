class ComentarioModel {
  final int id;
  final String nome;
  final String email;
  final String texto;

  ComentarioModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.texto,
  });

  factory ComentarioModel.fromJson(Map<String, dynamic> json) {
    return ComentarioModel(
      id: json['id'] ?? 0,
      nome: json['name'] ?? 'Anônimo',
      email: json['email'] ?? '',
      texto: json['body'] ?? '',
    );
  }
}
