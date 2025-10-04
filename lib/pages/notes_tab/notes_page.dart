import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logosophy/database/notes/models/note.dart';
import 'package:logosophy/database/notes/notes_provider.dart';
import 'package:logosophy/database/settings/settings_provider.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/utils/pdf_utils.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key, this.note});

  final Note? note;

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  String? _selectedBookId;
  DateTime? _afterDate;
  DateTime? _beforeDate;
  final _pageController = TextEditingController();
  Map<String, dynamic> mappings = {};
  bool _isLoading = true;

  /// Returns true if the page is for a specific book (from /note-editor).
  bool get isBookSpecificContext => widget.note != null;

  @override
  void initState() {
    super.initState();
    _selectedBookId = widget.note?.bookId;

    loadMappings().then((_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (isBookSpecificContext && widget.note!.id.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _showAddNewNoteModal(note: widget.note);
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
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

  void _applyFilters() {
    setState(() {});
  }

  void _clearFilters() {
    setState(() {
      if (!isBookSpecificContext) {
        _selectedBookId = null;
      }
      _afterDate = null;
      _beforeDate = null;
      _pageController.clear();
    });
  }

  void _showAddNewNoteModal({Note? note}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return BottomSheetNote(note: note, mappings: mappings);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notesState = ref.watch(notesNotifierProvider);
    final notifier = ref.read(notesNotifierProvider.notifier);

    final displayedNotes = notifier.getNotes(
      bookId: _selectedBookId,
      after: _afterDate,
      before: _beforeDate,
    );
    displayedNotes.sort((a, b) {
      final pageA = a.page ?? -1;
      final pageB = b.page ?? -1;
      if (pageA != pageB) return pageA.compareTo(pageB);
      return (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0));
    });

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(t.notesPage.myNotes)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final appBarTitle = isBookSpecificContext
        ? Text(_getBookTitle(_selectedBookId!) ?? t.notesPage.myNotes)
        : Text(t.notesPage.myNotes);

    return Scaffold(
      appBar: AppBar(title: appBarTitle),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final noteForModal = isBookSpecificContext
              ? Note(
                  id: '',
                  bookId: _selectedBookId,
                  updatedAt: null,
                  note: '',
                  page: null, // Page is not known here
                )
              : null;
          _showAddNewNoteModal(note: noteForModal);
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFilterSection(notesState.notes.values.toList()),
            const Divider(height: 24),
            _buildNotesList(displayedNotes),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(List<Note> allNotes) {
    final locale = ref.watch(settingsNotifierProvider).language;

    var bookIds = allNotes.map((e) => e.bookId).whereType<String>().toSet();
    var bookIdsList = bookIds.toList();
    bookIdsList.remove('');
    bookIdsList.insert(0, '');

    return ExpansionTile(
      initiallyExpanded: isBookSpecificContext,
      title: Text(t.notesPage.filters),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (!isBookSpecificContext) ...[
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedBookId ?? '',
                        hint: Text(t.notesPage.filterByBook),
                        items: bookIdsList
                            .map(
                              (id) => DropdownMenuItem(
                                value: id,
                                child: Text(
                                  _getBookTitle(id) ?? t.notesPage.allBooks,
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
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(
                      _afterDate == null
                          ? t.notesPage.afterDate
                          : DateFormat(
                              DateFormat.MONTH_DAY,
                              locale,
                            ).format(_afterDate!),
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
                          ? t.notesPage.beforeDate
                          : DateFormat(
                              DateFormat.MONTH_DAY,
                              locale,
                            ).format(_beforeDate!),
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
                    child: Text(t.notesPage.clearFilters),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _applyFilters,
                    child: Text(t.btnActions.apply),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesList(List<Note> notes) {
    return Expanded(
      child: notes.isEmpty
          ? Center(child: Text(t.notesPage.noNotesFound))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return _buildNoteCard(note);
              },
            ),
    );
  }

  String? _getBookTitle(String bookId) {
    if (bookId.isEmpty) return t.notesPage.allBooks;

    final locale = ref.read(settingsNotifierProvider).language;
    String? bookName = mappings[locale.toString()]?['$bookId.pdf']?['title'];
    if (bookName == null) return 'Unknown Book';

    if (bookName.contains('–')) {
      return bookName.split('–').last.trim();
    }
    return bookName;
  }

  Widget _buildNoteCard(Note note) {
    final locale = ref.watch(settingsNotifierProvider).language;
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
                      note.bookId != null
                          ? _getBookTitle(note.bookId!) ??
                                t.notesPage.generalNotes
                          : t.notesPage.generalNotes,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.clip,
                    ),
                    if (note.createdAt != null)
                      Row(
                        children: [
                          Text(
                            DateFormat(
                              DateFormat.YEAR_MONTH_DAY,
                              locale,
                            ).format(note.createdAt!),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            DateFormat(
                              DateFormat.HOUR_MINUTE,
                              locale,
                            ).format(note.createdAt!),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
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

  void _handleSaveNote(Note note) {
    _showAddNewNoteModal(note: note);
  }

  Future<void> _handleDeleteNote(Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.notesPage.deleteNote),
        content: Text(t.notesPage.deleteConfirmation),
        actions: [
          TextButton(
            child: Text(t.btnActions.cancel),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          ElevatedButton(
            child: Text(t.btnActions.delete),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(notesNotifierProvider.notifier).deleteNote(id: note.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.notesPage.noteDeletedSuccess),
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
  const BottomSheetNote({super.key, this.note, this.mappings});

  final Note? note;
  final Map<String, dynamic>? mappings;

  @override
  ConsumerState<BottomSheetNote> createState() => BottomSheetNoteState();
}

class BottomSheetNoteState extends ConsumerState<BottomSheetNote> {
  final _controller = TextEditingController();
  late String titleText;

  @override
  void initState() {
    super.initState();
    final note = widget.note;
    final locale = ref.read(settingsNotifierProvider).language;
    _controller.text = note?.note ?? '';

    if (note != null && note.id.isNotEmpty) {
      titleText = t.notesPage.editNote;
    } else if (note != null && note.bookId != null && note.bookId!.isNotEmpty) {
      final bookName = PDFUtils.getBookNameById(
        widget.mappings!,
        note.bookId!,
        locale.toString(),
      );
      titleText = t.notesPage.bookNoteAdd(bookName: bookName);
    } else {
      titleText = t.notesPage.generalNotes;
    }
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
        .saveNote(
          id: widget.note?.id,
          noteText: newText,
          bookId: widget.note?.bookId,
          page: widget.note?.page,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.notesPage.noteSaved),
        backgroundColor: Colors.green,
      ),
    );

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
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: t.notesPage.writeHere,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text(t.btnActions.cancel),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _handleAddNewNote,
                child: Text(t.btnActions.save),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
