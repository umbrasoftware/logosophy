import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logosophy/database/notes/models/note.dart';
import 'package:logosophy/database/notes/models/notes_state.dart';
import 'package:logosophy/database/notes/notes_provider.dart';
import 'package:intl/intl.dart';

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

  // --- LOCAL UI STATE FOR TEXT EDITING ---
  Map<String, TextEditingController> _editingControllers = {};

  @override
  void initState() {
    super.initState();
    // When the widget initializes, ensure controllers are built for the initial notes.
    // ref.read is used here because we only need the initial state to build controllers.
    _rebuildEditingControllers(
      ref.read(notesNotifierProvider).notes.values.toList(),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks.
    _pageController.dispose();
    _editingControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
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

  /// Safely disposes old controllers and creates new ones for the current list of notes.
  void _rebuildEditingControllers(List<Note> notes) {
    final noteIds = notes.map((n) => n.id).toSet();
    // First, remove and dispose controllers that are no longer needed.
    _editingControllers.removeWhere((id, controller) {
      if (!noteIds.contains(id)) {
        controller.dispose();
        return true;
      }
      return false;
    });

    // Then, create controllers for any new notes.
    for (var note in notes) {
      if (!_editingControllers.containsKey(note.id)) {
        _editingControllers[note.id] = TextEditingController(text: note.note);
      }
    }
  }

  /// Opens the modal bottom sheet to add a new general note.
  void _showAddNewNoteModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allows the sheet to resize when the keyboard appears.
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        // Use a separate, self-contained widget for the bottom sheet content.
        return _NewNoteBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- REACTIVE LOGIC ---
    // 1. Watch for any changes in the provider. If the state changes, this widget rebuilds.
    final notesState = ref.watch(notesNotifierProvider);
    final notifier = ref.read(notesNotifierProvider.notifier);

    // 2. Listen for changes to efficiently rebuild controllers only when note count changes.
    ref.listen<NotesState>(notesNotifierProvider, (previous, next) {
      if (previous?.notes.length != next.notes.length) {
        setState(() {
          _rebuildEditingControllers(next.notes.values.toList());
        });
      }
    });

    // 3. Calculate the list to be displayed here, directly in the build method.
    final pageAsInt = _pageController.text.isNotEmpty
        ? int.tryParse(_pageController.text)
        : null;
    final displayedNotes = notifier.getNotes(
      bookId: _selectedBookId,
      page: pageAsInt,
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
    final bookIds = allNotes
        .map((e) => e.bookId)
        .whereType<String>()
        .toSet()
        .toList();

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
                      value: _selectedBookId,
                      hint: const Text('Filter by Book'),
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
                      decoration: const InputDecoration(labelText: 'Page'),
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
                          ? 'Created After...'
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
                          ? 'Created Before...'
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

  /// A single card for an existing note, allowing editing and deletion.
  Widget _buildNoteCard(Note note) {
    final controller = _editingControllers[note.id];
    if (controller == null) return const SizedBox.shrink(); // Safety check.

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
                  ? 'Book ${note.bookId}, Page ${note.page}'
                  : 'General Note',
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
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- HANDLER METHODS ---

  void _handleSaveNote(Note note, String updatedText) {
    if (updatedText.trim().isEmpty || updatedText.trim() == note.note) return;
    ref
        .read(notesNotifierProvider.notifier)
        .saveNote(id: note.id, noteText: updatedText.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note updated!'),
        backgroundColor: Colors.green,
      ),
    );
    FocusScope.of(context).unfocus();
  }

  void _handleDeleteNote(Note note) {
    ref.read(notesNotifierProvider.notifier).deleteNote(id: note.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note deleted.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// =======================================================================
// WIDGET FOR THE BOTTOM SHEET CONTENT
// =======================================================================

class _NewNoteBottomSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_NewNoteBottomSheet> createState() =>
      _NewNoteBottomSheetState();
}

class _NewNoteBottomSheetState extends ConsumerState<_NewNoteBottomSheet> {
  final _controller = TextEditingController();

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
        .saveNote(
          noteText: newText,
          bookId: null, // General note
          page: null, // General note
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New note saved!'),
        backgroundColor: Colors.green,
      ),
    );

    // Close the bottom sheet after saving.
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Padding adjusts automatically when the keyboard appears.
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Makes the column take minimum necessary height.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create General Note',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            maxLines: 5,
            autofocus: true, // Opens the keyboard automatically.
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
                child: const Text('Save Note'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
