// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider responsible for managing the state of the seach filters.

@ProviderFor(SearchFilterNotifier)
const searchFilterProvider = SearchFilterNotifierProvider._();

/// Provider responsible for managing the state of the seach filters.
final class SearchFilterNotifierProvider
    extends $NotifierProvider<SearchFilterNotifier, SearchFilter> {
  /// Provider responsible for managing the state of the seach filters.
  const SearchFilterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchFilterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchFilterNotifierHash();

  @$internal
  @override
  SearchFilterNotifier create() => SearchFilterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchFilter>(value),
    );
  }
}

String _$searchFilterNotifierHash() =>
    r'8e1d4d50668d29215c8b7e1932b91cfc57952078';

/// Provider responsible for managing the state of the seach filters.

abstract class _$SearchFilterNotifier extends $Notifier<SearchFilter> {
  SearchFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SearchFilter, SearchFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SearchFilter, SearchFilter>,
              SearchFilter,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
