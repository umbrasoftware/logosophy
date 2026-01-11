import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchUtils {
  static final _logger = Logger('SearchUtils');
  final supabase = Supabase.instance.client;

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

  static Future<List<Map<String, dynamic>>?> similaritySearch(List<double> queryEmbedding, int k) async {
    final supabaseUrl = dotenv.env['SUPABASE_URL']!;
    final supabaseAnonKey = dotenv.env['SUPABASE_SERVICE_KEY']!;

    final url = Uri.parse('$supabaseUrl/rest/v1/rpc/match_documents');

    final headers = {
      'apikey': supabaseAnonKey,
      'Authorization': 'Bearer $supabaseAnonKey',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({'query_embedding': queryEmbedding, 'match_count': k, 'filter': {}});
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
}
