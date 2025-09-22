import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logosophy/database/notes/models/note.dart';
import 'package:logosophy/database/notes/notes_provider.dart';
import 'package:intl/intl.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  // State for the list of notes displayed
  List<Note> _filteredNotes = [];
  String? _selectedBookId;
  int? page;
  DateTime? _afterDate;
  DateTime? _beforeDate;
  final _pageController = TextEditingController();

  // State for editing existing notes and creating new ones
  Map<String, TextEditingController> _editingControllers = {};
  final _newNoteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    _pageController.dispose();
    _newNoteController.dispose();
    for (var controller in _editingControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Fetches notes from the provider based on current filters and rebuilds the UI
  void _applyFilters() {
    final notifier = ref.read(notesNotifierProvider.notifier);
    setState(() {
      // Get the filtered notes
      _filteredNotes = notifier.getNotes(
        bookId: _selectedBookId,
        page: page,
        after: _afterDate,
        before: _beforeDate,
      );
      // Sort them by page and then by creation date
      _filteredNotes.sort((a, b) {
        final pageA = a.page ?? -1;
        final pageB = b.page ?? -1;
        if (pageA != pageB) return pageA.compareTo(pageB);
        return (b.createdAt ?? DateTime(0)).compareTo(
          a.createdAt ?? DateTime(0),
        );
      });
      // Rebuild the text controllers for the new list of notes
      _rebuildEditingControllers();
    });
  }

  /// Clears all filters and reloads the notes list
  void _clearFilters() {
    setState(() {
      _selectedBookId = null;
      _afterDate = null;
      _beforeDate = null;
      _pageController.clear();
    });
    _applyFilters();
  }

  /// Manages the lifecycle of text editing controllers
  void _rebuildEditingControllers() {
    // Dispose old controllers first
    for (var c in _editingControllers.values) {
      c.dispose();
    }
    // Create new controllers for the currently filtered notes
    _editingControllers = {
      for (var note in _filteredNotes)
        note.id: TextEditingController(text: note.note),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Anotações')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFilterSection(),
            const Divider(height: 24),
            _buildNotesList(),
            const Divider(height: 24),
            _buildNewNoteSection(),
          ],
        ),
      ),
    );
  }

  /// UI Section for filtering notes
  Widget _buildFilterSection() {
    // Get unique book IDs from the notes to populate the dropdown
    final allNotes = ref.watch(notesNotifierProvider).notes.values;
    final bookIds = allNotes
        .map((e) => e.bookId)
        .whereType<String>()
        .toSet()
        .toList();

    return ExpansionTile(
      title: const Text('Filtros'),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedBookId,
                      hint: const Text('Filtrar por Livro'),
                      items: bookIds
                          .map(
                            (id) =>
                                DropdownMenuItem(value: id, child: Text(id)),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedBookId = value),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      controller: _pageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Página'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(
                      _afterDate == null
                          ? 'Criado Após...'
                          : DateFormat('dd/MM/yy').format(_afterDate!),
                    ),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) setState(() => _afterDate = date);
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(
                      _beforeDate == null
                          ? 'Criado Antes de...'
                          : DateFormat('dd/MM/yy').format(_beforeDate!),
                    ),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) setState(() => _beforeDate = date);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _clearFilters,
                    child: const Text('Limpar Filtros'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _applyFilters,
                    child: const Text('Aplicar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// UI Section for displaying the list of filtered notes
  Widget _buildNotesList() {
    return Expanded(
      child: _filteredNotes.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma anotação encontrada com os filtros selecionados.',
              ),
            )
          : ListView.builder(
              itemCount: _filteredNotes.length,
              itemBuilder: (context, index) {
                final note = _filteredNotes[index];
                return _buildNoteCard(note);
              },
            ),
    );
  }

  /// A single card for an existing note, allowing editing and deletion
  Widget _buildNoteCard(Note note) {
    final controller = _editingControllers[note.id];
    if (controller == null) return const SizedBox.shrink(); // Safety check

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.bookId != null
                  ? 'Livro ${note.bookId}, Página ${note.page}'
                  : 'Anotação Geral',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (note.createdAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(note.createdAt!),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _handleDeleteNote(note),
                ),
                ElevatedButton(
                  onPressed: () => _handleSaveNote(note, controller.text),
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// UI Section for creating a new, general-purpose note
  Widget _buildNewNoteSection() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Criar Anotação Geral',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _newNoteController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Escreva sua anotação aqui...',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _handleAddNewNote,
                  child: const Text('Salvar Nova Anotação'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Handler Methods ---

  void _handleSaveNote(Note note, String updatedText) {
    if (updatedText.trim().isEmpty || updatedText.trim() == note.note) return;
    ref
        .read(notesNotifierProvider.notifier)
        .saveNote(id: note.id, noteText: updatedText.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Anotação atualizada!'),
        backgroundColor: Colors.green,
      ),
    );
    FocusScope.of(context).unfocus();
  }

  void _handleDeleteNote(Note note) {
    ref.read(notesNotifierProvider.notifier).deleteNote(id: note.id);
    // Refresh the list after deletion
    _applyFilters();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Anotação deletada.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleAddNewNote() {
    final newText = _newNoteController.text.trim();
    if (newText.isEmpty) return;
    ref
        .read(notesNotifierProvider.notifier)
        .saveNote(
          noteText: newText,
          bookId: null, // General note
          page: null, // General note
        );
    _newNoteController.clear();
    FocusScope.of(context).unfocus();
    // Refresh the list to show the new note
    _applyFilters();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nova anotação salva!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
