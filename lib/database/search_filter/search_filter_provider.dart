import 'package:logosophy/database/search_filter/search_filter_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_filter_provider.g.dart';

/// Provider responsible for managing the state of the seach filters.
@Riverpod(keepAlive: true)
class SearchFilterNotifier extends _$SearchFilterNotifier {
  @override
  SearchFilter build() {
    return SearchFilter(includeOnlyIds: [], excludeOnlyIds: []);
  }

  /// Adds a book in the include filter.
  void addToInclude(String bookId) {
    final newList = [...state.includeOnlyIds, bookId];
    state = state.copyWith(includeOnlyIds: newList, excludeOnlyIds: []);
  }

  /// Removes a book from the include filter.
  void removeFromInclude(String bookId) {
    final newList = state.includeOnlyIds.where((id) => id != bookId).toList();
    state = state.copyWith(includeOnlyIds: newList);
  }

  /// Adds a book in the exclude filter.
  void addToExclude(String bookId) {
    final newList = [...state.excludeOnlyIds, bookId];
    state = state.copyWith(excludeOnlyIds: newList, includeOnlyIds: []);
  }

  /// Removes a book from the exclude filter.
  void removeFromExclude(String bookId) {
    final newList = state.excludeOnlyIds.where((id) => id != bookId).toList();
    state = state.copyWith(excludeOnlyIds: newList);
  }

  /// Clear all the filters.
  void clear() {
    state = state.copyWith(excludeOnlyIds: [], includeOnlyIds: []);
  }
}
