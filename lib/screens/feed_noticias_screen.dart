import 'package:flutter/material.dart';
import '../models/noticia_model.dart';
import '../services/noticia_service.dart';
import 'detalhe_noticia_screen.dart';

class FeedNoticiasScreen extends StatefulWidget {
  const FeedNoticiasScreen({super.key});

  @override
  State<FeedNoticiasScreen> createState() => _FeedNoticiasScreenState();
}

class _FeedNoticiasScreenState extends State<FeedNoticiasScreen> {
  final _service = NoticiaService();
  late Future<List<NoticiaModel>> _futureNoticias;
  final Set<int> _favoritos = {};

  @override
  void initState() {
    super.initState();
    _futureNoticias = _service.buscarNoticias();
  }

  Future<void> _abrirDetalhes(NoticiaModel item) async {
    final favorito = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => DetalheNoticiaScreen(
          noticia: item,
          favoritoInicial: _favoritos.contains(item.id),
        ),
      ),
    );

    // Desafio Intermediário: recebe o estado retornado pela tela de detalhes
    if (favorito == null) return;
    setState(() {
      favorito ? _favoritos.add(item.id) : _favoritos.remove(item.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Portal de Notícias'), centerTitle: true),
      body: FutureBuilder<List<NoticiaModel>>(
        future: _futureNoticias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ' + snapshot.error.toString()));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma notícia encontrada.'));
          }

          final noticias = snapshot.data!;
          return ListView.builder(
            itemCount: noticias.length,
            itemBuilder: (context, index) {
              final item = noticias[index];
              final favorito = _favoritos.contains(item.id);
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  // Desafio Básico: Hero com a mesma tag da tela de detalhes
                  leading: Hero(
                    tag: item.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        item.urlImagem,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 56,
                          height: 56,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image),
                        ),
                      ),
                    ),
                  ),
                  title: Text(item.titulo, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(item.resumo),
                  trailing: favorito
                      ? const Icon(Icons.favorite, color: Colors.red, size: 20)
                      : const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _abrirDetalhes(item),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
