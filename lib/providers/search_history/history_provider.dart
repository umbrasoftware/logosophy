import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:logosophy/providers/search_history/history_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'history_provider.g.dart';

/// Provider responsable for holding the search history. The state is always sorted by
/// the most recent.
@Riverpod(keepAlive: true)
class HistoryNotifier extends _$HistoryNotifier {
  static const int maxHistory = 20;
  late Box<History> _box;

  @override
  Future<List<History>> build() async {
    _box = await Hive.openBox<History>('history');
    if (_box.isEmpty) {
      return [];
    } else {
      return _getState();
    }
  }

  /// Gets the state from the Hive box.
  Future<List<History>> _getState() async {
    List<History> newState = [];
    for (final history in _box.values) {
      newState.add(history);
    }
    newState.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return newState;
  }

  /// Add a new [History] into the history.
  Future<void> addHistory(History result) async {
    if (state.requireValue.any((e) => e.query == result.query)) return;

    final modifiableState = [...state.requireValue];
    while (_box.length >= maxHistory) {
      // Sort to find the oldest
      final entries = _box.toMap().entries.toList();
      entries.sort((a, b) => a.value.timestamp.compareTo(b.value.timestamp)); // Oldest first
      final oldestEntry = entries.first;

      await _box.delete(oldestEntry.key);
      modifiableState.removeWhere((e) => e.timestamp == oldestEntry.value.timestamp);
    }

    await _box.put(result.timestamp.toIso8601String(), result);
    modifiableState.add(result);
    modifiableState.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    state = AsyncData(modifiableState);
  }

  /// Delete a [History] from the history.
  Future<void> deleteHistoryItem(DateTime timestamp) async {
    final entries = _box.toMap().entries;
    final entryToDelete = entries.where((e) => e.value.timestamp == timestamp).firstOrNull;

    if (entryToDelete != null) {
      await _box.delete(entryToDelete.key);
    } else {
      // Fallback in case the exact timestamp wasn't found but we try the string
      await _box.delete(timestamp.toIso8601String());
    }

    final modifiableState = [...state.requireValue];
    modifiableState.removeWhere((item) => item.timestamp == timestamp);
    state = AsyncData(modifiableState);
  }

  /// Clear this box data.
  Future<void> clear() async {
    await _box.clear();
    state = AsyncData([]);
  }
}
