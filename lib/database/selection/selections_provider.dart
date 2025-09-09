import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'selections_classes.dart';

part 'selections_provider.g.dart';

@Riverpod(keepAlive: true)
class SelectionsProvider extends _$SelectionsProvider {
  @override
  Selections build() {
    return Selections(bookSelections: {});
  }
}
