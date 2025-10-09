// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annotations_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AnnotationsNotifier)
const annotationsProvider = AnnotationsNotifierProvider._();

final class AnnotationsNotifierProvider
    extends $NotifierProvider<AnnotationsNotifier, AnnotationsState> {
  const AnnotationsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'annotationsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$annotationsNotifierHash();

  @$internal
  @override
  AnnotationsNotifier create() => AnnotationsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnnotationsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnnotationsState>(value),
    );
  }
}

String _$annotationsNotifierHash() =>
    r'51330d8a9c6a84c1dcda41087b32116f77101cfc';

abstract class _$AnnotationsNotifier extends $Notifier<AnnotationsState> {
  AnnotationsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AnnotationsState, AnnotationsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AnnotationsState, AnnotationsState>,
              AnnotationsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
