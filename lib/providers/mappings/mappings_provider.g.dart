// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mappings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider responsable for holding the mappings file state, which contains data for books
/// of all languages.

@ProviderFor(MappingsNotifier)
const mappingsProvider = MappingsNotifierProvider._();

/// Provider responsable for holding the mappings file state, which contains data for books
/// of all languages.
final class MappingsNotifierProvider
    extends $AsyncNotifierProvider<MappingsNotifier, Map<String, dynamic>> {
  /// Provider responsable for holding the mappings file state, which contains data for books
  /// of all languages.
  const MappingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mappingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mappingsNotifierHash();

  @$internal
  @override
  MappingsNotifier create() => MappingsNotifier();
}

String _$mappingsNotifierHash() => r'66877916565dbc5ed2f9f5f6da2825bc93148590';

/// Provider responsable for holding the mappings file state, which contains data for books
/// of all languages.

abstract class _$MappingsNotifier extends $AsyncNotifier<Map<String, dynamic>> {
  FutureOr<Map<String, dynamic>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<Map<String, dynamic>>, Map<String, dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<String, dynamic>>,
                Map<String, dynamic>
              >,
              AsyncValue<Map<String, dynamic>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
