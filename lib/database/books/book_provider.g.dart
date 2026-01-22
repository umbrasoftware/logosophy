// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider responsable for holding the book status. The state is always sorted by
/// the most recent. The Provider state is always sorted.

@ProviderFor(BookNotifier)
const bookProvider = BookNotifierProvider._();

/// Provider responsable for holding the book status. The state is always sorted by
/// the most recent. The Provider state is always sorted.
final class BookNotifierProvider
    extends $AsyncNotifierProvider<BookNotifier, List<BookData>> {
  /// Provider responsable for holding the book status. The state is always sorted by
  /// the most recent. The Provider state is always sorted.
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

String _$bookNotifierHash() => r'4a34d5a3df65983190957dc865eb2ef6f58e2ec3';

/// Provider responsable for holding the book status. The state is always sorted by
/// the most recent. The Provider state is always sorted.

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
