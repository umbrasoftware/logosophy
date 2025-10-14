import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/pages/books_tab/pdf_viewer_args.dart';
import 'package:logosophy/pages/search_tab/search_result.dart';
import 'package:logosophy/utils/search_utils.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchResult> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;
  late Map<String, dynamic> mappings;

  /// Retorna o título do livro com base no book_id, usando o mapa fornecido.
  String _getBookTitle(String bookId) {
    try {
      // O caminho no JSON é 'pt-BR' -> 'ID.pdf' -> 'title'
      final pdfFileName = '$bookId.pdf';
      return mappings['pt-BR'][pdfFileName]['title'] ?? t.searchPage.unkownBook;
    } catch (e) {
      // Retorna um valor padrão caso a chave não seja encontrada
      return t.searchPage.unkownBook;
    }
  }

  /// Simula a busca de embeddings. Substitua este método pela sua chamada real.
  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final embeddings = await SearchUtils.createEmbedding(query);
      final queryResults = await SearchUtils.similaritySearch(embeddings!, 10);
      final data = List<Map<String, dynamic>>.from(queryResults!);
      final results = data.map((item) => SearchResult.fromMap(item)).toList();

      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getMappings() async {
    final appDir = await getApplicationDocumentsDirectory();
    final booksDir = Directory(p.join(appDir.path, 'books'));
    final mappingsFile = File(p.join(booksDir.path, 'mappings.json'));

    final content = await mappingsFile.readAsString();
    mappings = jsonDecode(content);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getMappings(),
      builder: (context, asyncSnapshot) {
        return Scaffold(
          appBar: AppBar(title: Text(t.navBar.search)),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: t.searchPage.typeYourSearch,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _performSearch(_searchController.text),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onSubmitted: (value) => _performSearch(value),
                ),
                const SizedBox(height: 20),

                // Área de resultados
                Expanded(child: _buildResultsView()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultsView() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (_searchResults.isEmpty && _searchController.text.isNotEmpty) {
      return Center(child: Text(t.searchPage.noResultFound));
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          t.searchPage.startSearch,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        final bookTitle = _getBookTitle(result.bookId);

        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          child: ListTile(
            title: Text(
              bookTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${t.bookPage.page(page: result.page)}\n"${result.content}"',
            ),
            onTap: () async {
              final appDir = await getApplicationDocumentsDirectory();
              final pdfPath = p.join(
                appDir.path,
                'books',
                'pt-BR',
                '${result.bookId}.pdf',
              );

              final pdfFile = File(pdfPath);

              if (context.mounted) {
                final args = PdfViewerArgs(file: pdfFile, page: result.page);
                context.push('/pdfviewer', extra: args);
              }
            },
          ),
        );
      },
    );
  }
}
