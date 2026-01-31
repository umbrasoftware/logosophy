// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider responsable for holding the search history. The state is always sorted by
/// the most recent.

@ProviderFor(HistoryNotifier)
const historyProvider = HistoryNotifierProvider._();

/// Provider responsable for holding the search history. The state is always sorted by
/// the most recent.
final class HistoryNotifierProvider
    extends $AsyncNotifierProvider<HistoryNotifier, List<History>> {
  /// Provider responsable for holding the search history. The state is always sorted by
  /// the most recent.
  const HistoryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyNotifierHash();

  @$internal
  @override
  HistoryNotifier create() => HistoryNotifier();
}

String _$historyNotifierHash() => r'c2f626c3fee0158e73dff72ab4736428f6ed2114';

/// Provider responsable for holding the search history. The state is always sorted by
/// the most recent.

abstract class _$HistoryNotifier extends $AsyncNotifier<List<History>> {
  FutureOr<List<History>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<History>>, List<History>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<History>>, List<History>>,
              AsyncValue<List<History>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
