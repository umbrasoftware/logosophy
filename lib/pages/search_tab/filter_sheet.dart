import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logosophy/providers/mappings/mappings_provider.dart';
import 'package:logosophy/providers/search_filter/search_filter_provider.dart';
import 'package:logosophy/gen/strings.g.dart';

class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key});

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  late Map<String, dynamic> _mappings;

  @override
  void initState() {
    _mappings = ref.read(mappingsProvider).requireValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final filter = ref.watch(searchFilterProvider);
    final filterNotifier = ref.read(searchFilterProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.onInverseSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SizedBox(
        height: 320,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                const SizedBox(height: 8),
                Text(
                  t.filter.includeOnly,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.onSurface),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 60),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceDim,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.add, size: 18),
                        label: Text(t.btnActions.add),
                        onPressed: () async => await chooseBook(true),
                        backgroundColor: colorScheme.primaryContainer,
                        side: BorderSide.none,
                      ),
                      ...filter.includeOnlyIds.map(
                        (bookId) => Chip(
                          label: Text(getBookTitle(bookId)),
                          onDeleted: () => filterNotifier.removeFromInclude(bookId),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                Text(
                  t.filter.excludeOnly,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.onSurface),
                ),
                const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 60),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceDim,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.add, size: 18),
                        label: Text(t.btnActions.add),
                        onPressed: () async => await chooseBook(false),
                      ),
                      ...filter.excludeOnlyIds.map(
                        (bookId) => Chip(
                          label: Text(getBookTitle(bookId)),
                          onDeleted: () => filterNotifier.removeFromExclude(bookId),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: () {
                    filterNotifier.clear();
                  },
                  child: Text(t.filter.clear),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Show a dialog for the user to choose a book and updates the filters.
  Future<void> chooseBook(bool isToInclude) async {
    final filterProvider = ref.read(searchFilterProvider.notifier);
    final filter = ref.read(searchFilterProvider);
    final bookId = await showPickBookDialog(context);

    if (bookId != null) {
      if (isToInclude ? !filter.includeOnlyIds.contains(bookId) : !filter.excludeOnlyIds.contains(bookId)) {
        isToInclude ? filterProvider.addToInclude(bookId) : filterProvider.addToExclude(bookId);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.filter.alreadyAdded(title: getBookTitle(bookId)))));
      }
    }
  }

  /// Using the mappings file, get a book title by it's id.
  String getBookTitle(String bookId) {
    return _mappings['pt-BR']['$bookId.pdf']['title'];
  }

  /// Shows the book dialog on the screen.
  Future<String?> showPickBookDialog(BuildContext context) async {
    final Map<String, dynamic> booksMap = _mappings['pt-BR'];
    final sortedEntries = booksMap.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t.filter.selectBook),
          contentPadding: const EdgeInsets.only(top: 12.0),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.separated(
              itemCount: sortedEntries.length,
              separatorBuilder: (ctx, i) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final entry = sortedEntries[index];
                final bookData = entry.value;
                final String bookTitle = bookData['title'];
                final String bookId = entry.key.replaceAll('.pdf', '');
                return ListTile(
                  leading: const Icon(Icons.book_outlined),
                  title: Text(bookTitle),
                  onTap: () {
                    Navigator.pop(context, bookId);
                  },
                );
              },
            ),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context, null), child: Text(t.btnActions.cancel))],
        );
      },
    );
  }
}
