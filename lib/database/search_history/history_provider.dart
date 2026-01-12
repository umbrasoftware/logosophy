import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:logosophy/pages/search_tab/search_result_class.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'history_provider.g.dart';

/// Provider responsable for holding the search history. The state is always sorted by
/// the most recent.
@Riverpod(keepAlive: true)
class HistoryNotifier extends _$HistoryNotifier {
  final _logger = Logger('HistoryNotifier');
  static const String prefsName = 'history';
  static const int maxHistory = 20;
  late SharedPreferencesWithCache _prefs;

  @override
  List<SearchResult> build() {
    return [];
  }

  /// Initializes the provider. Must be called before everything else.
  Future<void> init() async {
    _prefs = await SharedPreferencesWithCache.create(cacheOptions: const SharedPreferencesWithCacheOptions());
    final data = _prefs.getString(prefsName);

    if (data == null || data.isEmpty) {
      await _prefs.setString(prefsName, json.encode({}));
    } else {
      final decoded = json.decode(data) as Map<String, dynamic>;
      _setJsonIntoState(decoded);
    }
  }

  /// Clear this Prefs data.
  Future<void> clear() async {
    await _prefs.setString(prefsName, "");
    state = [];
  }

  /// Receives a history already decoded in JSON, sorts it and sets into the state.
  Future<void> _setJsonIntoState(Map<String, dynamic> decoded) async {
    List<SearchResult> newState = [];
    for (final map in decoded.entries) {
      final timestamp = map.key;
      newState.add(
        SearchResult(
          score: map.value[timestamp]["score"],
          content: map.value[timestamp]["content"],
          page: map.value[timestamp]["page"],
          bookId: map.value[timestamp]["bookId"],
          madeAt: timestamp,
        ),
      );
    }
    newState.sort((a, b) => DateTime.parse(b.madeAt!).compareTo(DateTime.parse(a.madeAt!)));
    await _prefs.setString(prefsName, jsonEncode(decoded));
    state = newState;
  }

  /// Add a new [SearchResult] into the history.
  Future<void> addHistory(SearchResult result) async {
    final history = _prefs.getString(prefsName);
    if (history == null) {
      _logger.severe("Prefs was null while trying to add to history.");
      return;
    }

    final newState = state.toList();
    if (state.length == maxHistory) {
      newState.removeLast();
    }

    final historyDecoded = jsonDecode(history);
    final resultMap = result.toJson();
    historyDecoded[resultMap["mateAt"]] = resultMap..remove("madeAt");

    _setJsonIntoState(historyDecoded);
  }

  /// Delete a [SearchResult] from the history.
  Future<void> deleteSearchResult(String timestamp) async {
    final history = _prefs.getString(prefsName);
    if (history == null) {
      _logger.severe("Prefs was null while trying to delete a history.");
      return;
    }

    final historyDecoded = json.decode(history) as Map<String, dynamic>;
    historyDecoded.remove(timestamp);

    await _setJsonIntoState(historyDecoded);
  }
}
