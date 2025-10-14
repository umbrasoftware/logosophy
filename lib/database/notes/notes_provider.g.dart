// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NotesNotifier)
const notesProvider = NotesNotifierProvider._();

final class NotesNotifierProvider
    extends $NotifierProvider<NotesNotifier, NotesState> {
  const NotesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notesNotifierHash();

  @$internal
  @override
  NotesNotifier create() => NotesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotesState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotesState>(value),
    );
  }
}

String _$notesNotifierHash() => r'76d0666003a09826f9d0760c9227f16b5615613d';

abstract class _$NotesNotifier extends $Notifier<NotesState> {
  NotesState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<NotesState, NotesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NotesState, NotesState>,
              NotesState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
