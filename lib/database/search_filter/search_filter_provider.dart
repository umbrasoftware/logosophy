import 'package:logosophy/database/search_filter/search_filter_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_filter_provider.g.dart';

@Riverpod(keepAlive: true)
class SearchFilterNotifier extends _$SearchFilterNotifier {
  @override
  SearchFilter build() {
    return SearchFilter(includeOnlyIds: [], excludeOnlyIds: []);
  }

  void addToInclude(String bookId) {
    final newList = [...state.includeOnlyIds, bookId];
    state = state.copyWith(includeOnlyIds: newList, excludeOnlyIds: []);
  }

  void removeFromInclude(String bookId) {
    final newList = state.includeOnlyIds.where((id) => id != bookId).toList();
    state = state.copyWith(includeOnlyIds: newList);
  }

  void addToExclude(String bookId) {
    final newList = [...state.excludeOnlyIds, bookId];
    state = state.copyWith(excludeOnlyIds: newList, includeOnlyIds: []);
  }

  void removeFromExclude(String bookId) {
    final newList = state.excludeOnlyIds.where((id) => id != bookId).toList();
    state = state.copyWith(excludeOnlyIds: newList);
  }

  void clear() {
    state = state.copyWith(excludeOnlyIds: [], includeOnlyIds: []);
  }
}
