import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:logosophy/providers/search_filter/search_filter_provider.dart';
import 'package:logosophy/gen/strings.g.dart';

class SearchUtils {
  static final _logger = Logger('SearchUtils');

  /// Create the embeddings for a given text.
  static Future<List<double>?> createEmbedding(String text) async {
    final apiKey = dotenv.env['OPENAI_API_KEY']!;
    final url = Uri.parse('https://api.openai.com/v1/embeddings');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $apiKey'},
      body: jsonEncode({'model': 'text-embedding-3-small', 'input': text}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final embedding = data['data'][0]['embedding'];
      return List<double>.from(embedding);
    } else {
      _logger.warning('Error creating embeddings: ${response.statusCode}: ${response.body}');
      return null;
    }
  }

  /// Calls the Edge Function from Postgree database fo perform the similarity search.
  static Future<List<Map<String, dynamic>>?> similaritySearch(List<double> queryEmbedding, int k, WidgetRef ref) async {
    final supabaseUrl = dotenv.env['SUPABASE_URL']!;
    final supabaseAnonKey = dotenv.env['SUPABASE_SERVICE_KEY']!;

    final url = Uri.parse('$supabaseUrl/rest/v1/rpc/match_documents');

    final headers = {
      'apikey': supabaseAnonKey,
      'Authorization': 'Bearer $supabaseAnonKey',
      'Content-Type': 'application/json',
    };

    final filterState = ref.read(searchFilterProvider);
    final List<String>? includeList = filterState.includeOnlyIds.isNotEmpty ? filterState.includeOnlyIds : null;
    final List<String>? excludeList = filterState.excludeOnlyIds.isNotEmpty ? filterState.excludeOnlyIds : null;

    final body = jsonEncode({
      'query_embedding': queryEmbedding,
      'match_count': k,
      'include_book_ids': includeList,
      'exclude_book_ids': excludeList,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final results = List<Map<String, dynamic>>.from(jsonData.map((item) => Map<String, dynamic>.from(item)));
      return results;
    } else {
      _logger.warning('Error calling search: ${response.statusCode}: ${response.body}');
      return null;
    }
  }

  /// Returns the book title given the `bookId`.
  static String getBookTitle(String bookId, Map<dynamic, dynamic> mappings) {
    final pdfFileName = '$bookId.pdf';
    return mappings['pt-BR'][pdfFileName]['title'] ?? t.searchPage.unkownBook;
  }
}
