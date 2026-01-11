class SearchResult {
  final double score;
  final String content;
  final int page;
  final String bookId;

  SearchResult({required this.score, required this.content, required this.page, required this.bookId});

  factory SearchResult.fromMap(Map<String, dynamic> map) {
    // Acessando os metadados aninhados
    final metadata = map['metadata'] as Map<String, dynamic>;

    return SearchResult(
      score: (map['similarity'] as num).toDouble(),
      content: map['content'] as String,
      page: metadata['page'] as int,
      bookId: metadata['book_id'] as String,
    );
  }
}
