import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:logosophy/main.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mappings_provider.g.dart';

/// Provider responsable for holding the mappings file state, which contains data for books
/// of all languages.
@Riverpod(keepAlive: true)
class MappingsNotifier extends _$MappingsNotifier {
  final _logger = Logger('MappingsProvider');

  @override
  Future<Map<String, dynamic>> build() async {
    final appDocumentsDir = await getApplicationDocumentsDirectory();
    final booksDir = Directory(p.join(appDocumentsDir.path, 'books'));
    if (!await booksDir.exists()) await booksDir.create(recursive: true);

    final mappingsFile = File(p.join(booksDir.path, 'mappings.json'));
    if (!await mappingsFile.exists()) {
      _logger.info("mappings.json does not exists. Downloading...");
      final storage = supabase.client.storage;
      final mappingsBytes = await storage.from('books').download('mapping.json');
      await mappingsFile.writeAsBytes(mappingsBytes);
    }

    final mappingString = await mappingsFile.readAsString();
    return jsonDecode(mappingString);
  }
}
