import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppUtils {
  /// Returns a Scaffold if one or more of the [AsyncValue] is in the `.hasError` state.
  /// Returns null if all are OK.
  static Scaffold? buildErrorPage(List<AsyncValue> objs) {
    String err = '';
    for (final obj in objs) {
      if (obj.hasError) err += "${obj.error!.toString()}\n";
    }

    return err.isNotEmpty
        ? Scaffold(
            body: Center(
              child: Text(err, style: TextStyle(color: Colors.red)),
            ),
          )
        : null;
  }

  /// Returns a Scaffold if one or more of the [AsyncValue] is in the `.isLoading` state for the first time.
  /// Returns null if all are loaded.
  static Scaffold? buildLoadingPage(List<AsyncValue> objs) {
    bool isInitialLoading = false;
    for (final obj in objs) {
      if (obj.isLoading && !obj.hasValue) {
        isInitialLoading = true;
      }
    }

    return isInitialLoading ? const Scaffold(body: Center(child: CircularProgressIndicator())) : null;
  }
}
