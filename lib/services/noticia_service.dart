import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comentario_model.dart';
import '../models/noticia_model.dart';

class NoticiaService {
  // Dados em JSON hospedados no próprio repositório (pasta api/)
  static const String _baseUrl =
      'https://raw.githubusercontent.com/ferreirajoao-fatec/pdm_aula11_master_detail/main/api';
  static const String _endpoint = '$_baseUrl/noticias.json';

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
    final response = await http.get(Uri.parse('$_baseUrl/comentarios/$noticiaId.json'));

    if (response.statusCode == 200) {
      final List<dynamic> listaJson = jsonDecode(response.body);
      return listaJson.map((item) => ComentarioModel.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao carregar comentários');
    }
  }
}
