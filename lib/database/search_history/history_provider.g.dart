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
    extends $NotifierProvider<HistoryNotifier, List<History>> {
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<History> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<History>>(value),
    );
  }
}

String _$historyNotifierHash() => r'c9a542f4ae6da86fb4af0333be4083eea09e310f';

/// Provider responsable for holding the search history. The state is always sorted by
/// the most recent.

abstract class _$HistoryNotifier extends $Notifier<List<History>> {
  List<History> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<History>, List<History>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<History>, List<History>>,
              List<History>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
