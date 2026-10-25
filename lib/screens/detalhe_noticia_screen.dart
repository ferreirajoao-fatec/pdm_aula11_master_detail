import 'package:flutter/material.dart';
import '../models/comentario_model.dart';
import '../models/noticia_model.dart';
import '../services/noticia_service.dart';

class DetalheNoticiaScreen extends StatefulWidget {
  final NoticiaModel noticia;
  final bool favoritoInicial;

  const DetalheNoticiaScreen({super.key, required this.noticia, this.favoritoInicial = false});

  @override
  State<DetalheNoticiaScreen> createState() => _DetalheNoticiaScreenState();
}

class _DetalheNoticiaScreenState extends State<DetalheNoticiaScreen> {
  final _service = NoticiaService();
  late bool _favorito;
  late Future<List<ComentarioModel>> _futureComentarios;

  @override
  void initState() {
    super.initState();
    _favorito = widget.favoritoInicial;
    _futureComentarios = _service.buscarComentarios(widget.noticia.id);
  }

  @override
  Widget build(BuildContext context) {
    final noticia = widget.noticia;

    // Desafio Intermediário: ao sair da tela, devolve o estado de favorito via Navigator.pop
    return PopScope<bool>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) Navigator.pop(context, _favorito);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes da Notícia'),
          actions: [
            IconButton(
              icon: Icon(_favorito ? Icons.favorite : Icons.favorite_border),
              color: _favorito ? Colors.red : null,
              tooltip: _favorito ? 'Remover dos favoritos' : 'Favoritar',
              onPressed: () => setState(() => _favorito = !_favorito),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Desafio Básico: Hero com a mesma tag usada na lista
              Hero(
                tag: noticia.id,
                child: Image.network(
                  noticia.urlImagem,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(height: 180, color: Colors.grey[300], child: const Icon(Icons.image, size: 40)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.person, size: 16),
                      label: Text(noticia.autor),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      noticia.titulo,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 24),
                    Text(
                      noticia.conteudoCompleto,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                    ),
                    const Divider(height: 32),
                    Text('Comentários', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    _buildComentarios(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComentarios() {
    return FutureBuilder<List<ComentarioModel>>(
      future: _futureComentarios,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Text('Erro: ' + snapshot.error.toString(), style: const TextStyle(color: Colors.red));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('Nenhum comentário ainda.');
        }

        // Column em vez de ListView, pois já estamos dentro de um SingleChildScrollView
        return Column(
          children: snapshot.data!
              .map((comentario) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.comment, size: 18)),
                      title: Text(comentario.nome, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(comentario.email + '\n' + comentario.texto),
                      isThreeLine: true,
                    ),
                  ))
              .toList(),
        );
      },
    );
  }
}
