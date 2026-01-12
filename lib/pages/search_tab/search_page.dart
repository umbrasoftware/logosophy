import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logosophy/database/search_history/history_provider.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/pages/books_tab/pdf_reader.dart';
import 'package:logosophy/pages/search_tab/search_result_class.dart';
import 'package:logosophy/pages/search_tab/utils.dart';
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
      final queryResults = await SearchUtils.similaritySearch(embeddings!, 20);
      final data = List<Map<String, dynamic>>.from(queryResults!);
      final results = data.map((item) => SearchResult.fromJson(item)).toList();

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
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder(
      future: getMappings(),
      builder: (context, asyncSnapshot) {
        return Scaffold(
          appBar: AppBar(title: Text(t.navBar.search)),
          // drawer: _buildDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: t.searchPage.typeYourSearch,
                    labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search, color: colorScheme.onSurface),
                      onPressed: () => _performSearch(_searchController.text),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: colorScheme.primary, width: 2),
                    ),
                  ),
                  style: TextStyle(color: colorScheme.onSurface),
                  onSubmitted: (value) => _performSearch(value),
                ),
                const SizedBox(height: 20),
                Expanded(child: _buildResultsView(colorScheme)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultsView(ColorScheme colorScheme) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: colorScheme.primary));
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(_errorMessage!, style: TextStyle(color: colorScheme.error)),
      );
    }

    if (_searchResults.isEmpty && _searchController.text.isNotEmpty) {
      return Center(
        child: Text(t.searchPage.noResultFound, style: TextStyle(color: colorScheme.onSurface)),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Text(t.searchPage.startSearch, style: TextStyle(color: colorScheme.onSurfaceVariant)),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        final bookTitle = _getBookTitle(result.bookId);

        return GestureDetector(
          onTap: () async {
            final appDir = await getApplicationDocumentsDirectory();
            final pdfPath = p.join(appDir.path, 'books', 'pt-BR', '${result.bookId}.pdf');

            if (context.mounted) {
              context.push('/pdfviewer', extra: ReaderArgs(pdfPath, page: result.page));
            }
          },
          child: Card(
            color: colorScheme.surfaceContainer,
            margin: const EdgeInsets.only(bottom: 12.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookTitle,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.onSurface),
                  ),
                  Text(
                    t.bookPage.page(page: result.page),
                    style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceDim,
                      borderRadius: BorderRadius.circular(6.0),
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                    child: Text(
                      result.content,
                      style: TextStyle(fontSize: 13, color: colorScheme.onSurface, fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Drawer _buildDrawer() {
    final colorScheme = Theme.of(context).colorScheme;
    final results = ref.watch(historyProvider);
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: colorScheme.surfaceContainer),
              child: Center(
                child: Text(
                  "Pesquisas salvas",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  selectionColor: colorScheme.onSurface,
                ),
              ),
            ),
            ListView.separated(
              itemCount: results.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 12);
              },
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    print('oi');
                  },
                  child: Card(
                    color: colorScheme.surfaceContainer,
                    margin: const EdgeInsets.all(6.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(results[index].madeAt!, style: TextStyle(fontSize: 11, color: colorScheme.onSurface)),
                          Text(
                            results[index].content,
                            style: TextStyle(
                              fontSize: 18,
                              color: colorScheme.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                //return ListTile(title: Text("11/01/2026 21:09"), subtitle: Text());
              },
            ),
          ],
        ),
      ),
    );
  }
}
