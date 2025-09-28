import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logosophy/database/notes/models/note.dart';
import 'package:logosophy/database/notes/notes_provider.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  // --- LOCAL UI STATE FOR FILTERS ---
  String? _selectedBookId;
  DateTime? _afterDate;
  DateTime? _beforeDate;
  final _pageController = TextEditingController();
  Map<String, dynamic> mappings = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMappings().then((_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks.
    _pageController.dispose();
    super.dispose();
  }

  Future<void> loadMappings() async {
    final appDir = await getApplicationDocumentsDirectory();
    final booksDir = Directory(p.join(appDir.path, 'books'));
    final mappingsFile = File(p.join(booksDir.path, 'mappings.json'));

    final content = await mappingsFile.readAsString();
    mappings = jsonDecode(content);
  }

  /// Called by the filter UI to trigger a rebuild with new filter values.
  void _applyFilters() {
    setState(() {});
  }

  /// Clears all filter values and triggers a rebuild.
  void _clearFilters() {
    setState(() {
      _selectedBookId = null;
      _afterDate = null;
      _beforeDate = null;
      _pageController.clear();
    });
  }

  /// Opens the modal bottom sheet to add a new general note.
  void _showAddNewNoteModal({Note? note}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        // Use a separate, self-contained widget for the bottom sheet content.
        return BottomSheetNote(note: note);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- REACTIVE LOGIC ---
    // 1. Watch for any changes in the provider. If the state changes, this widget rebuilds.
    final notesState = ref.watch(notesNotifierProvider);
    final notifier = ref.read(notesNotifierProvider.notifier);

    // 2. Calculate the list to be displayed here, directly in the build method.
    final displayedNotes = notifier.getNotes(
      bookId: _selectedBookId,
      after: _afterDate,
      before: _beforeDate,
    );
    // Sort the list for consistent display.
    displayedNotes.sort((a, b) {
      final pageA = a.page ?? -1;
      final pageB = b.page ?? -1;
      if (pageA != pageB) return pageA.compareTo(pageB);
      return (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0));
    });

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Notes')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Notes')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNewNoteModal,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFilterSection(notesState.notes.values.toList()),
            const Divider(height: 24),
            // The list of notes now takes up the remaining space.
            _buildNotesList(displayedNotes),
          ],
        ),
      ),
    );
  }

  // --- UI BUILDER METHODS ---

  /// UI Section for filtering notes.
  Widget _buildFilterSection(List<Note> allNotes) {
    // Get unique book IDs from the notes to populate the dropdown.
    var bookIds = allNotes
        .map((e) => e.bookId)
        .whereType<String>()
        .toSet()
        .toList();
    bookIds.insert(0, '');

    return ExpansionTile(
      title: const Text('Filters'),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedBookId ?? '',
                      hint: const Text('Filter by Book'),
                      items: bookIds
                          .map(
                            (id) => DropdownMenuItem(
                              value: id,
                              child: Text(
                                id.isEmpty
                                    ? 'Todos os livros'
                                    : mappings['pt-BR']['$id.pdf']?['title'],
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBookId = (value == null || value.isEmpty)
                              ? null
                              : value;
                        });
                      },
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
                          ? 'After...'
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
                          ? 'Before...'
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
                    child: const Text('Clear Filters'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _applyFilters,
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// UI Section for displaying the list of filtered notes.
  Widget _buildNotesList(List<Note> notes) {
    return Expanded(
      child: notes.isEmpty
          ? const Center(
              child: Text('No notes found with the selected filters.'),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return _buildNoteCard(note);
              },
            ),
    );
  }

  String getBookNameForCard(Note note) {
    String bookName;
    if (note.bookId != null) {
      bookName = mappings["pt-BR"]["${note.bookId}.pdf"]["title"];
      if (bookName.contains('–')) {
        bookName = bookName.split('–').last.trim();
      }
    } else {
      bookName = 'General Note';
    }
    return bookName;
  }

  /// A single card for an existing note, allowing editing and deletion.
  Widget _buildNoteCard(Note note) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getBookNameForCard(note),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.clip,
                    ),
                    if (note.createdAt != null)
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(note.createdAt!),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.edit_outlined),
                  onPressed: () => _handleSaveNote(note),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _handleDeleteNote(note),
                ),
              ],
            ),
            Text(
              note.note,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // --- HANDLER METHODS ---

  void _handleSaveNote(Note note) {
    _showAddNewNoteModal(note: note);
  }

  Future<void> _handleDeleteNote(Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          ElevatedButton(
            child: const Text('Delete'),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(notesNotifierProvider.notifier).deleteNote(id: note.id);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note deleted.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// =======================================================================
// WIDGET FOR THE BOTTOM SHEET CONTENT
// =======================================================================

class BottomSheetNote extends ConsumerStatefulWidget {
  const BottomSheetNote({super.key, this.note});

  final Note? note;

  @override
  ConsumerState<BottomSheetNote> createState() => BottomSheetNoteState();
}

class BottomSheetNoteState extends ConsumerState<BottomSheetNote> {
  final _controller = TextEditingController();
  late Note? note;
  late String titleText;

  @override
  void initState() {
    note = widget.note;
    if (note != null) {
      titleText = 'Edit note';
      _controller.text = note!.note;
    } else {
      titleText = 'Create General Note';
    }

    note != null ? _controller.text = note!.note : null;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleAddNewNote() {
    final newText = _controller.text.trim();
    if (newText.isEmpty) return;

    ref
        .read(notesNotifierProvider.notifier)
        .saveNote(noteText: newText, bookId: note?.bookId, page: note?.page);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note saved!'),
        backgroundColor: Colors.green,
      ),
    );

    // Close the bottom sheet after saving.
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titleText, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            maxLines: 8,
            autofocus: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Write your note here...',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () =>
                    Navigator.of(context).pop(), // Just close the sheet.
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _handleAddNewNote,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
