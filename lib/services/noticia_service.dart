import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comentario_model.dart';
import '../models/noticia_model.dart';

class NoticiaService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String _endpoint = '$_baseUrl/posts';

  Future<List<NoticiaModel>> buscarNoticias() async {
    final response = await http.get(Uri.parse(_endpoint));

    if (response.statusCode == 200) {
      final List<dynamic> listaJson = jsonDecode(response.body);
      return listaJson.map((item) => NoticiaModel.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao carregar notícias');
    }
  }

  // Desafio Avançado: segunda chamada à API para os comentários da notícia
  Future<List<ComentarioModel>> buscarComentarios(int noticiaId) async {
    final response = await http.get(Uri.parse('$_endpoint/$noticiaId/comments'));

    if (response.statusCode == 200) {
      final List<dynamic> listaJson = jsonDecode(response.body);
      return listaJson.map((item) => ComentarioModel.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao carregar comentários');
    }
  }
}
