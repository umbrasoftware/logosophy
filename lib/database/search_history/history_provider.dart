import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:logosophy/database/search_history/history_model.dart';
import 'package:logosophy/pages/search_tab/search_model.dart';
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
  List<History> build() {
    return [];
  }

  /// Initializes the provider. Must be called before everything else.
  Future<void> init() async {
    _prefs = await SharedPreferencesWithCache.create(cacheOptions: const SharedPreferencesWithCacheOptions());
    final history = _prefs.getStringList(prefsName);

    if (history == null || history.isEmpty) {
      await _prefs.setStringList(prefsName, []);
    } else {
      await _setPrefsIntoState(history);
    }
  }

  /// Receives a history already decoded in JSON, sorts it and sets into the state.
  Future<void> _setPrefsIntoState(List<String> historyPrefs) async {
    try {
      List<History> newState = [];
      for (final entry in historyPrefs) {
        final entryDecoded = jsonDecode(entry);
        final query = entryDecoded["query"];
        final timestamp = entryDecoded["timestamp"];

        final List<SearchResult> results = [];
        for (final result in entryDecoded["results"]) {
          final resultMap = jsonDecode(result);
          results.add(
            SearchResult(
              similarity: resultMap["similarity"] as double,
              content: resultMap["content"] as String,
              page: resultMap["page"] as int,
              bookId: resultMap["bookId"] as String,
            ),
          );
        }

        newState.add(History(query: query, timestamp: timestamp, results: results));
      }
      newState.sort((a, b) => DateTime.parse(b.timestamp).compareTo(DateTime.parse(a.timestamp)));
      state = newState;
    } catch (e) {
      _logger.shout(e.toString());
      rethrow;
    }
  }

  /// Add a new [History] into the history.
  Future<void> addHistory(History result) async {
    final history = _prefs.getStringList(prefsName);
    if (history == null) {
      _logger.severe("Prefs was null while trying to add to history.");
      return;
    }

    if (history.length == maxHistory) {
      history.removeLast();
    }

    // Check if this query already exists.
    if (state.any((e) => e.query == result.query)) return;

    final resultJson = <String, dynamic>{};
    resultJson["query"] = result.query;
    resultJson["timestamp"] = result.timestamp;

    final List<Map<String, dynamic>> resultsInJson = [];
    for (final entry in result.results) {
      final entryMap = {
        "similarity": entry.similarity,
        "content": entry.content,
        "page": entry.page,
        "bookId": entry.bookId,
      };
      resultsInJson.add(entryMap);
    }
    resultJson["results"] = resultsInJson;
    history.add(jsonEncode(resultJson));

    // Settings the states and sorting.
    await _prefs.setStringList(prefsName, history);
    state = [...state, result];
    await _sortAndSet();
  }

  /// Sorts and saves the data on SharedPreferences and the Provider state.
  Future<void> _sortAndSet() async {
    // Sorts the history list of Strings and set its to the Prefs.
    final historyPrefs = _prefs.getStringList(prefsName);
    if (historyPrefs == null || historyPrefs.isEmpty) {
      _logger.shout("History on SharedPrefs is null or empty while trying to sort.");
      return;
    }

    historyPrefs.sort((a, b) {
      final aJson = jsonDecode(a);
      final bJson = jsonDecode(b);
      return DateTime.parse(bJson["timestamp"]).compareTo(DateTime.parse(aJson["timestamp"]));
    });
    await _prefs.setStringList(prefsName, historyPrefs);

    // Sorts the history objects and set its to the state.
    final historyObjs = [...state];
    historyObjs.sort((a, b) => DateTime.parse(b.timestamp).compareTo(DateTime.parse(a.timestamp)));
    state = [...historyObjs];
  }

  /// Delete a [History] from the history and updates the SharedPrefs and Provider state.
  Future<void> deleteHistoryItem(String timestamp) async {
    final history = _prefs.getStringList(prefsName);
    if (history == null || history.isEmpty) {
      _logger.severe("Prefs was null while trying to delete a history.");
      return;
    }

    history.removeWhere((item) => item.contains(timestamp));
    await _prefs.setStringList(prefsName, history);

    final historyObjs = [...state];
    historyObjs.removeWhere((item) => item.timestamp == timestamp);
    state = historyObjs;
  }

  /// Clear this Prefs data.
  Future<void> clear() async {
    await _prefs.setStringList(prefsName, []);
    state = [];
  }
}
