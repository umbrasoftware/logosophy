import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/database/search_filter/search_filter_provider.dart';
import 'package:logosophy/database/search_history/history_model.dart';
import 'package:logosophy/database/search_history/history_provider.dart';
import 'package:logosophy/database/settings/settings_provider.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/pages/books_tab/pdf_reader.dart';
import 'package:logosophy/database/search_history/search_model.dart';
import 'package:logosophy/pages/search_tab/filter_sheet.dart';
import 'package:logosophy/pages/search_tab/utils.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _logger = Logger('SearchPage');
  final TextEditingController _searchController = TextEditingController();
  List<SearchResult> _searchResults = [];
  bool _isLoading = false;
  bool _isFilterActive = false;
  String? _errorMessage;
  late Map<String, dynamic> mappings;
  late List<History> _history;

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyProvider);
    return historyAsync.when(
      loading: () => Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) {
        _logger.shout("$err, $stack");
        return Scaffold(
          body: Center(
            child: Text(err.toString(), style: TextStyle(color: Colors.red)),
          ),
        );
      },
      data: (historyData) {
        _history = historyData;

        final filter = ref.watch(searchFilterProvider);
        _isFilterActive = filter.includeOnlyIds.isNotEmpty || filter.excludeOnlyIds.isNotEmpty;

        final colorScheme = Theme.of(context).colorScheme;
        return FutureBuilder(
          future: getMappings(),
          builder: (context, asyncSnapshot) {
            return Scaffold(
              appBar: AppBar(
                title: Text(t.navBar.search),
                actions: [
                  IconButton(
                    onPressed: _buildFilterSheet,
                    icon: Icon(Icons.filter_list_alt, color: _isFilterActive ? colorScheme.primary : null),
                  ),
                ],
              ),
              drawer: _buildDrawer(),
              body: _buildBody(colorScheme),
            );
          },
        );
      },
    );
  }

  /// Build the main page body.
  Padding _buildBody(ColorScheme colorScheme) {
    return Padding(
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
    );
  }

  /// Performs the search.
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
      final queryResults = await SearchUtils.similaritySearch(embeddings!, 20, ref);
      final data = List<Map<String, dynamic>>.from(queryResults!);
      final results = data.map((item) => SearchResult.fromJson(item)).toList();

      final history = History(query: query, timestamp: DateTime.now(), results: results, wasFiltered: _isFilterActive);
      await ref.read(historyProvider.notifier).addHistory(history);

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

  /// Shows the results on the screen.
  Widget _buildResultsView(ColorScheme colorScheme) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: .spaceEvenly,
          children: [
            _isFilterActive ? Text(t.filter.activateFilters) : SizedBox.shrink(),
            CircularProgressIndicator(color: colorScheme.primary),
          ],
        ),
      );
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
        final bookTitle = SearchUtils.getBookTitle(result.bookId, mappings);

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

  /// Build the Drawer, that shows the seach history.
  Drawer _buildDrawer() {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(color: colorScheme.surfaceContainer),
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              crossAxisAlignment: .end,
              children: [
                Icon(Icons.history, color: colorScheme.primary),
                const SizedBox(width: 4.0),
                Text(
                  t.searchPage.searchHistory,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                ),
                Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete),
                  iconSize: 28,
                  color: Colors.red,
                  onPressed: () async {
                    await ref.read(historyProvider.notifier).clear();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _history.isEmpty
                ? Center(
                    child: Text(t.searchPage.noHistoryYet, style: TextStyle(color: colorScheme.onSurfaceVariant)),
                  )
                : _buildSearchWidgets(colorScheme),
          ),
        ],
      ),
    );
  }

  /// Build the search history widgets.
  ListView _buildSearchWidgets(ColorScheme colorScheme) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final item = _history[index];
        return ListTile(
          title: Text(_formatDate(item), style: TextStyle(fontSize: 12, color: colorScheme.outline)),
          subtitle: Text(
            item.query,
            style: TextStyle(fontSize: 15, color: colorScheme.onSurface, fontWeight: FontWeight.w500),
            overflow: .clip,
          ),
          leading: item.wasFiltered ? Icon(Icons.filter_list_alt, color: colorScheme.primary) : null,
          trailing: IconButton(
            icon: Icon(Icons.close, size: 20, color: Colors.red),
            onPressed: () async {
              await ref.read(historyProvider.notifier).deleteHistoryItem(item.timestamp);
            },
          ),
          onTap: () {
            _searchController.text = item.query;
            setState(() {
              _searchResults = item.results;
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  /// Gets the book mappings from storage.
  Future<void> getMappings() async {
    final appDir = await getApplicationDocumentsDirectory();
    final booksDir = Directory(p.join(appDir.path, 'books'));
    final mappingsFile = File(p.join(booksDir.path, 'mappings.json'));

    final content = await mappingsFile.readAsString();
    mappings = jsonDecode(content);
  }

  /// Formats the date for display, given a [History] item.
  String _formatDate(History item) {
    final language = ref.watch(settingsProvider).requireValue.language;

    final date = DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY, language).format(item.timestamp);
    final time = DateFormat(DateFormat.HOUR24_MINUTE, language).format(item.timestamp);

    return "$date $time";
  }

  /// Calls the BottomSheet to let the use choose the filters.
  void _buildFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterSheet(mappings: mappings);
      },
    );
  }
}
