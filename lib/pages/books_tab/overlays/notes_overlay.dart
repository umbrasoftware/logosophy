import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logosophy/database/notes/models/note.dart';
import 'package:logosophy/database/notes/notes_provider.dart';
import 'package:logosophy/gen/strings.g.dart';

class NotesOverlay extends ConsumerStatefulWidget {
  final VoidCallback onClose;
  final String bookId;
  final String page;

  const NotesOverlay({
    super.key,
    required this.onClose,
    required this.bookId,
    required this.page,
  });

  @override
  ConsumerState<NotesOverlay> createState() => _NotesOverlayState();
}

class _NotesOverlayState extends ConsumerState<NotesOverlay> {
  late Map<String, TextEditingController> _editingControllers;
  final _newNoteController = TextEditingController();
  OverlayEntry? _confirmationDialogOverlay;

  late List<Note> _notes;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = int.parse(widget.page);
    _loadAndPrepareNotes();
  }

  void _loadAndPrepareNotes() {
    _notes = ref
        .read(notesNotifierProvider.notifier)
        .getNotes(bookId: widget.bookId);

    _notes.sort((a, b) {
      final pageA = a.page ?? 0;
      final pageB = b.page ?? 0;
      return pageA.compareTo(pageB);
    });

    _editingControllers = {
      for (var note in _notes) note.id: TextEditingController(text: note.note),
    };
  }

  @override
  void dispose() {
    for (var controller in _editingControllers.values) {
      controller.dispose();
    }
    _newNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClose,
      child: Container(
        color: Colors.black.withAlpha(126),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.8,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleBar(),
                    const Divider(height: 20),
                    _buildExistingNotesList(),
                    const Divider(height: 20),
                    _buildNewNoteSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          t.bookPage.bookAnnotations,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        IconButton(icon: const Icon(Icons.close), onPressed: widget.onClose),
      ],
    );
  }

  Widget _buildExistingNotesList() {
    return Expanded(
      child: _notes.isEmpty
          ? Center(child: Text(t.notesPage.noBookNotes))
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return _buildNoteCard(note);
              },
            ),
    );
  }

  Widget _buildNoteCard(Note note) {
    final controller = _editingControllers[note.id]!;
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.bookPage.page(page: note.page ?? 'N/A'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: t.notesPage.editNote,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _handleDeleteNote(note),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save, size: 18),
                  label: Text(t.btnActions.save),
                  onPressed: () => _handleSaveNote(note, controller.text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewNoteSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.notesPage.newNote(page: _currentPage),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _newNoteController,
            maxLines: 3,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: t.notesPage.writeNotes,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text(t.btnActions.clear),
                onPressed: () => _newNoteController.clear(),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: Text(t.btnActions.add),
                onPressed: _handleAddNewNote,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleSaveNote(Note note, String updatedText) {
    if (updatedText.trim().isEmpty || updatedText == note.note) return;

    ref
        .read(notesNotifierProvider.notifier)
        .saveNote(id: note.id, noteText: updatedText);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.notesPage.noteUpdated),
        backgroundColor: Colors.green,
      ),
    );
    FocusScope.of(context).unfocus();
  }

  void _handleDeleteNote(Note note) {
    _showConfirmationDialog(note);
  }

  void _hideConfirmationDialog() {
    _confirmationDialogOverlay?.remove();
    _confirmationDialogOverlay = null;
  }

  void _showConfirmationDialog(Note note) {
    final overlay = Overlay.of(context);

    _confirmationDialogOverlay = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black.withAlpha(150),
        child: Center(
          child: AlertDialog(
            title: Text(t.btnActions.confirmDelete),
            content: Text(t.notesPage.confirmDelete),
            actions: [
              TextButton(
                onPressed: _hideConfirmationDialog,
                child: Text(t.btnActions.cancel),
              ),
              TextButton(
                child: Text(
                  t.btnActions.delete,
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  ref
                      .read(notesNotifierProvider.notifier)
                      .deleteNote(id: note.id);
                  setState(() {
                    _editingControllers.remove(note.id)?.dispose();
                    _notes.removeWhere((n) => n.id == note.id);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(t.notesPage.noteDeleted),
                      backgroundColor: Colors.red,
                    ),
                  );
                  _hideConfirmationDialog();
                },
              ),
            ],
          ),
        ),
      ),
    );
    overlay.insert(_confirmationDialogOverlay!);
  }

  void _handleAddNewNote() {
    final newText = _newNoteController.text.trim();
    if (newText.isEmpty) return;

    ref
        .read(notesNotifierProvider.notifier)
        .saveNote(noteText: newText, bookId: widget.bookId, page: _currentPage);

    _newNoteController.clear();
    FocusScope.of(context).unfocus();

    setState(() {
      _loadAndPrepareNotes();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.notesPage.newNoteSaved),
        backgroundColor: Colors.green,
      ),
    );
  }
}
