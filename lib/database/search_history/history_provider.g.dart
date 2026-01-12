// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HistoryNotifier)
const historyProvider = HistoryNotifierProvider._();

final class HistoryNotifierProvider
    extends $NotifierProvider<HistoryNotifier, List<SearchResult>> {
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
  Override overrideWithValue(List<SearchResult> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SearchResult>>(value),
    );
  }
}

String _$historyNotifierHash() => r'109f5050e68582f248cbe06e765b0cd4ecfcbb99';

abstract class _$HistoryNotifier extends $Notifier<List<SearchResult>> {
  List<SearchResult> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<SearchResult>, List<SearchResult>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<SearchResult>, List<SearchResult>>,
              List<SearchResult>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
