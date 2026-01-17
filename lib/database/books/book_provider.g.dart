// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider responsable for holding the search history. The state is always sorted by
/// the most recent.

@ProviderFor(BookNotifier)
const bookProvider = BookNotifierProvider._();

/// Provider responsable for holding the search history. The state is always sorted by
/// the most recent.
final class BookNotifierProvider
    extends $AsyncNotifierProvider<BookNotifier, List<BookData>> {
  /// Provider responsable for holding the search history. The state is always sorted by
  /// the most recent.
  const BookNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookNotifierHash();

  @$internal
  @override
  BookNotifier create() => BookNotifier();
}

String _$bookNotifierHash() => r'6033331af7d62a8d021514acacdf14e71acba925';

/// Provider responsable for holding the search history. The state is always sorted by
/// the most recent.

abstract class _$BookNotifier extends $AsyncNotifier<List<BookData>> {
  FutureOr<List<BookData>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<BookData>>, List<BookData>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<BookData>>, List<BookData>>,
              AsyncValue<List<BookData>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
