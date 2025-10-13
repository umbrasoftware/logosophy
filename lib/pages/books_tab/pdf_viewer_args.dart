import 'dart:io';

class PdfViewerArgs {
  final File file;
  final int? page;

  PdfViewerArgs({required this.file, this.page});
}
