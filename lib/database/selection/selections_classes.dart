import 'dart:ui';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/// This class represents all selections for a book. Chuncky boy!
class Selections {
  /// Armazena as seleções deste livro, organizadas por página.
  ///
  /// - A chave (`String`) é o número da página onde as seleções foram feitas.
  /// - O valor (`List<PdfSelection>`) é a lista de seleções daquela página.
  ///
  /// ### Exemplo da estrutura:
  /// ```json
  /// {
  ///   "15": [SelectionSpan(), SelectionSpan()],
  ///   "28": [SelectionSpan()]
  /// }
  /// ```
  final Map<String, List<SelectionSpan>> bookSelections;

  Selections({required this.bookSelections});
}

// As funções adaptadoras continuam as mesmas da resposta anterior
Map<String, dynamic> pdfTextLineToJson(PdfTextLine line) {
  return {
    'bounds': {
      'left': line.bounds.left,
      'top': line.bounds.top,
      'right': line.bounds.right,
      'bottom': line.bounds.bottom,
    },
    'text': line.text,
    'pageNumber': line.pageNumber,
  };
}

PdfTextLine pdfTextLineFromJson(Map<String, dynamic> json) {
  final boundsMap = json['bounds'] as Map<String, dynamic>;
  final bounds = Rect.fromLTRB(
    (boundsMap['left'] as num).toDouble(),
    (boundsMap['top'] as num).toDouble(),
    (boundsMap['right'] as num).toDouble(),
    (boundsMap['bottom'] as num).toDouble(),
  );
  return PdfTextLine(bounds, json['text'] as String, json['pageNumber'] as int);
}

/// Função auxiliar para comparar duas listas de PdfTextLine pelos seus valores.
bool _arePdfTextLineListsEqual(List<PdfTextLine> a, List<PdfTextLine> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i].bounds != b[i].bounds ||
        a[i].text != b[i].text ||
        a[i].pageNumber != b[i].pageNumber) {
      return false;
    }
  }
  return true;
}

class SelectionSpan {
  final List<PdfTextLine> textLines;
  final String type;
  final int pageNumber;
  final int color;
  final double opacity;

  SelectionSpan({
    required this.textLines,
    required this.type,
    required this.pageNumber,
    required this.color,
    required this.opacity,
  });

  factory SelectionSpan.fromJson(Map<String, dynamic> json) {
    var linesList = json['textLines'] as List;
    List<PdfTextLine> textLines = linesList
        .map((item) => pdfTextLineFromJson(item as Map<String, dynamic>))
        .toList();
    return SelectionSpan(
      textLines: textLines,
      type: json['type'] as String,
      pageNumber: json['pageNumber'] as int,
      color: json['color'] as int,
      opacity: (json['opacity'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'textLines': textLines.map((line) => pdfTextLineToJson(line)).toList(),
      'type': type,
      'pageNumber': pageNumber,
      'color': color,
      'opacity': opacity,
    };
  }

  SelectionSpan copyWith({
    List<PdfTextLine>? textLines,
    String? type,
    int? pageNumber,
    int? color,
    double? opacity,
  }) {
    return SelectionSpan(
      textLines: textLines ?? this.textLines,
      type: type ?? this.type,
      pageNumber: pageNumber ?? this.pageNumber,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
    );
  }

  @override
  String toString() {
    return 'SelectionSpan(type: $type, pageNumber: $pageNumber, textLines: ${textLines.length} lines)';
  }

  /// **MÉTODO DE IGUALDADE CORRIGIDO**
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SelectionSpan &&
        other.type == type &&
        other.pageNumber == pageNumber &&
        other.color == color &&
        other.opacity == opacity &&
        // Usamos nossa função auxiliar para comparar as listas manualmente
        _arePdfTextLineListsEqual(other.textLines, textLines);
  }

  @override
  int get hashCode {
    // Usar Object.hash é a forma moderna e segura de combinar hash codes.
    return Object.hash(
      type,
      pageNumber,
      color,
      opacity,
      Object.hashAll(textLines), // Garante que a ordem da lista importa no hash
    );
  }
}
