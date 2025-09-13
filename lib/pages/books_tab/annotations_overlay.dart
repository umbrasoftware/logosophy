// annotations_overlay.dart

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AnnotationsOverlay extends StatefulWidget {
  final PdfViewerController controller;
  final VoidCallback onClose;

  const AnnotationsOverlay({
    super.key,
    required this.controller,
    required this.onClose,
  });

  @override
  State<AnnotationsOverlay> createState() => _AnnotationsOverlayState();
}

class _AnnotationsOverlayState extends State<AnnotationsOverlay> {
  late List<Annotation> annotations;

  @override
  void initState() {
    super.initState();
    // Pega a lista inicial de anotações do controller.
    annotations = widget.controller.getAnnotations();
  }

  @override
  Widget build(BuildContext context) {
    // Usamos um GestureDetector para capturar toques fora do card e fechar o overlay
    return GestureDetector(
      onTap: widget.onClose, // Chama a função para esconder
      child: Container(
        // Fundo semi-transparente para focar no overlay
        color: Colors.black.withAlpha(126),
        child: Center(
          // Center alinha nosso card no meio da tela
          child: GestureDetector(
            onTap: () {}, // Impede que o toque no card feche o overlay
            child: SizedBox(
              // Define o tamanho do nosso card
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    // 1. CABEÇALHO (Não rolável)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Anotações do livro',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: widget.onClose, // Botão para fechar
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    // 2. CORPO (Rolável)
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: annotations.length,
                        itemBuilder: (context, index) {
                          final annotation = annotations[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              trailing: IconButton(
                                onPressed: () {
                                  // Remove a anotação do controller e atualiza o estado
                                  // para reconstruir a lista.
                                  setState(() {
                                    widget.controller.removeAnnotation(
                                      annotation,
                                    );
                                    annotations.removeAt(index);
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                              ),
                              title: Text('Página ${annotation.pageNumber}'),
                              subtitle: Text(
                                annotation.name ?? 'error',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
