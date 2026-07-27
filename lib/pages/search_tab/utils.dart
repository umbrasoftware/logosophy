import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:logosophy/providers/search_filter/search_filter_provider.dart';
import 'package:logosophy/gen/strings.g.dart';

/// A search failure carrying a message already translated for the user.
class SearchException implements Exception {
  final String message;

  SearchException(this.message);

  @override
  String toString() => message;
}

class SearchUtils {
  static final _logger = Logger('SearchUtils');

  /// Runs the semantic search for [query], returning at most [k] matches.
  ///
  /// Both the embedding and the vector search happen inside the `search` edge
  /// function, so no OpenAI credentials are shipped with the app. The function
  /// caps [k] and the query length on its side regardless of what is sent here.
  static Future<List<Map<String, dynamic>>> search(String query, int k, WidgetRef ref) async {
    final supabaseUrl = dotenv.env['SUPABASE_URL']!;
    final publishableKey = dotenv.env['SUPABASE_PUBLISHABLE_KEY']!;

    final url = Uri.parse('$supabaseUrl/functions/v1/search');

    final headers = {
      'apikey': publishableKey,
      'Authorization': 'Bearer $publishableKey',
      'Content-Type': 'application/json',
    };

    final filterState = ref.read(searchFilterProvider);
    final List<String>? includeList = filterState.includeOnlyIds.isNotEmpty ? filterState.includeOnlyIds : null;
    final List<String>? excludeList = filterState.excludeOnlyIds.isNotEmpty ? filterState.excludeOnlyIds : null;

    final body = jsonEncode({
      'query': query,
      'matchCount': k,
      'includeBookIds': includeList,
      'excludeBookIds': excludeList,
    });

    final http.Response response;
    try {
      response = await http.post(url, headers: headers, body: body);
    } catch (e) {
      _logger.warning('Error reaching search function: $e');
      throw SearchException(t.searchPage.searchError);
    }

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(jsonData.map((item) => Map<String, dynamic>.from(item)));
    }

    _logger.warning('Error calling search: ${response.statusCode}: ${response.body}');

    if (response.statusCode == 429) throw SearchException(t.searchPage.tooManyRequests);
    throw SearchException(t.searchPage.searchError);
  }

  /// Returns the book title given the `bookId`.
  static String getBookTitle(String bookId, Map<dynamic, dynamic> mappings) {
    final pdfFileName = '$bookId.pdf';
    return mappings['pt-BR'][pdfFileName]['title'] ?? t.searchPage.unkownBook;
  }
}
