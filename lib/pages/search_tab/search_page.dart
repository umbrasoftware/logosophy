import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logosophy/app_utils.dart';
import 'package:logosophy/providers/mappings/mappings_provider.dart';
import 'package:logosophy/providers/search_filter/search_filter_provider.dart';
import 'package:logosophy/providers/search_history/history_model.dart';
import 'package:logosophy/providers/search_history/history_provider.dart';
import 'package:logosophy/providers/settings/settings_model.dart';
import 'package:logosophy/providers/settings/settings_provider.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/pages/books_tab/pdf_reader.dart';
import 'package:logosophy/providers/search_history/search_model.dart';
import 'package:logosophy/pages/search_tab/filter_sheet.dart';
import 'package:logosophy/pages/search_tab/utils.dart';
import 'package:logosophy/theme.dart';
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
  bool _isFilterActive = false;
  int _filterCount = 0;
  String? _errorMessage;
  late Map<String, dynamic> _mappings;
  late List<History> _history;
  late Settings _settings;

  @override
  void initState() {
    super.initState();
    // Rebuild so the clear button appears only while there is text.
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final mappingsAsync = ref.watch(mappingsProvider);

    final loadingPage = AppUtils.buildLoadingPage([historyAsync, settingsAsync, mappingsAsync]);
    if (loadingPage != null) return loadingPage;

    final errorPage = AppUtils.buildErrorPage([historyAsync, settingsAsync, mappingsAsync]);
    if (errorPage != null) return errorPage;

    _history = historyAsync.requireValue;
    _settings = settingsAsync.requireValue;
    _mappings = mappingsAsync.requireValue;

    final filter = ref.watch(searchFilterProvider);
    _isFilterActive = filter.includeOnlyIds.isNotEmpty || filter.excludeOnlyIds.isNotEmpty;
    _filterCount = filter.includeOnlyIds.length + filter.excludeOnlyIds.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.navBar.search),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.history),
              tooltip: t.searchPage.searchHistory,
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: _buildDrawer(),
      body: _buildBody(),
    );
  }

  /// Build the main page body.
  Padding _buildBody() {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: t.searchPage.typeYourSearch,
              filled: true,
              fillColor: colorScheme.surfaceContainerLowest,
              prefixIcon: Icon(Icons.search, color: colorScheme.primary),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_searchController.text.isNotEmpty)
                    IconButton(icon: const Icon(Icons.clear), onPressed: _searchController.clear),
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: IconButton(
                      tooltip: t.filter.activateFilters,
                      icon: Badge(
                        isLabelVisible: _isFilterActive,
                        label: Text('$_filterCount'),
                        backgroundColor: colorScheme.primary,
                        textColor: colorScheme.onPrimary,
                        child: Icon(
                          Icons.tune,
                          color: _isFilterActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
                        ),
                      ),
                      onPressed: _buildFilterSheet,
                    ),
                  ),
                ],
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28.0),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28.0),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
            ),
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
        final bookTitle = SearchUtils.getBookTitle(result.bookId, _mappings);

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
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          bookTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15 + _settings.fontSize,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          t.bookPage.page(page: result.page),
                          style: TextStyle(
                            fontSize: 11 + _settings.fontSize,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                      border: Border(left: BorderSide(color: colorScheme.primary, width: 2)),
                    ),
                    child: Text(
                      result.content,
                      style: AuroraTheme.passage(fontSize: 13 + _settings.fontSize, color: colorScheme.onSurface),
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
            color: colorScheme.surfaceContainer,
            padding: EdgeInsets.fromLTRB(16, MediaQuery.paddingOf(context).top + 12, 4, 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                  child: const Icon(Icons.history, size: 18),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    t.searchPage.searchHistory,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                  ),
                ),
                if (_history.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: colorScheme.error,
                    tooltip: t.btnActions.delete,
                    onPressed: _confirmClearHistory,
                  ),
              ],
            ),
          ),
          Expanded(
            child: _history.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.history, size: 48, color: colorScheme.outlineVariant),
                        const SizedBox(height: 8.0),
                        Text(t.searchPage.noHistoryYet, style: TextStyle(color: colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  )
                : _buildSearchWidgets(colorScheme),
          ),
        ],
      ),
    );
  }

  /// Asks for confirmation before clearing the whole search history.
  Future<void> _confirmClearHistory() async {
    final colorScheme = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.btnActions.confirmDelete),
        content: Text(t.searchPage.searchHistory),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.btnActions.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: colorScheme.error, foregroundColor: colorScheme.onError),
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.btnActions.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(historyProvider.notifier).clear();
    }
  }

  /// Build the search history widgets.
  ListView _buildSearchWidgets(ColorScheme colorScheme) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      itemCount: _history.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, indent: 16, endIndent: 16, color: colorScheme.outlineVariant),
      itemBuilder: (context, index) {
        final item = _history[index];
        return ListTile(
          leading: Icon(
            item.wasFiltered ? Icons.tune : Icons.search,
            size: 20,
            color: item.wasFiltered ? colorScheme.primary : colorScheme.onSurfaceVariant,
          ),
          title: Text(
            item.query,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15 + _settings.fontSize,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            _formatDate(item),
            style: TextStyle(fontSize: 11 + _settings.fontSize, color: colorScheme.onSurfaceVariant),
          ),
          trailing: IconButton(
            icon: Icon(Icons.close, size: 18, color: colorScheme.onSurfaceVariant),
            tooltip: t.btnActions.delete,
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
        return FilterSheet();
      },
    );
  }
}
