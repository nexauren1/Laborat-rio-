import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const bool demoMode = bool.fromEnvironment('DEMO_MODE', defaultValue: false);
const String storageKey = 'noteflow.notes.v1';
const String themeKey = 'noteflow.dark_mode.v1';
const Color brandColor = Color(0xFF6658E8);

const List<String> noteCategories = <String>[
  'Personal',
  'Work',
  'Ideas',
  'Study',
  'Other',
];

const List<Color> noteColors = <Color>[
  Color(0xFFECE8FF),
  Color(0xFFFFE9E1),
  Color(0xFFE1F4E9),
  Color(0xFFFFF1C9),
  Color(0xFFE1EFFD),
  Color(0xFFF8E3F2),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  List<Note> notes = Note.decodeList(preferences.getString(storageKey));

  if (!preferences.containsKey(storageKey) && demoMode) {
    notes = sampleNotes();
    await preferences.setString(storageKey, Note.encodeList(notes));
  }

  runApp(
    NoteFlowApp(
      preferences: preferences,
      initialNotes: notes,
      initialDarkMode: preferences.getBool(themeKey) ?? false,
    ),
  );
}

class Note {
  const Note({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.colorValue,
    required this.pinned,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String body;
  final String category;
  final int colorValue;
  final bool pinned;
  final DateTime updatedAt;

  Note copyWith({
    String? title,
    String? body,
    String? category,
    int? colorValue,
    bool? pinned,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      category: category ?? this.category,
      colorValue: colorValue ?? this.colorValue,
      pinned: pinned ?? this.pinned,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toJson() => <String, Object?>{
        'id': id,
        'title': title,
        'body': body,
        'category': category,
        'colorValue': colorValue,
        'pinned': pinned,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String? ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      title: json['title'] as String? ?? 'Untitled note',
      body: json['body'] as String? ?? '',
      category: json['category'] as String? ?? 'Personal',
      colorValue: json['colorValue'] as int? ?? noteColors.first.toARGB32(),
      pinned: json['pinned'] as bool? ?? false,
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  static String encodeList(List<Note> notes) {
    return jsonEncode(notes.map((Note note) => note.toJson()).toList());
  }

  static List<Note> decodeList(String? raw) {
    if (raw == null || raw.isEmpty) {
      return <Note>[];
    }
    try {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(Note.fromJson)
          .toList();
    } catch (_) {
      return <Note>[];
    }
  }
}

List<Note> sampleNotes() {
  final DateTime now = DateTime.now();
  return <Note>[
    Note(
      id: 'demo-idea-01',
      title: 'The art of starting',
      body: 'Every big idea begins with one small step. Start before you feel ready.',
      category: 'Ideas',
      colorValue: 0xFFECE8FF,
      pinned: true,
      updatedAt: now.subtract(const Duration(minutes: 18)),
    ),
    Note(
      id: 'demo-personal-02',
      title: 'A little reminder',
      body: 'Take a breath. You are allowed to grow at your own pace.',
      category: 'Personal',
      colorValue: 0xFFFFE9E1,
      pinned: true,
      updatedAt: now.subtract(const Duration(hours: 2)),
    ),
    Note(
      id: 'demo-work-03',
      title: 'Weekly priorities',
      body: '01  Build with intention\n02  Keep things simple\n03  Make time to learn',
      category: 'Work',
      colorValue: 0xFFE1F4E9,
      pinned: false,
      updatedAt: now.subtract(const Duration(hours: 5)),
    ),
    Note(
      id: 'demo-study-04',
      title: 'Things to explore',
      body: 'Design systems\nFlutter animations\nBetter writing habits',
      category: 'Study',
      colorValue: 0xFFFFF1C9,
      pinned: false,
      updatedAt: now.subtract(const Duration(days: 1)),
    ),
    Note(
      id: 'demo-idea-05',
      title: 'An idea for later',
      body: 'A tiny daily journal with one question that helps you reflect.',
      category: 'Ideas',
      colorValue: 0xFFE1EFFD,
      pinned: false,
      updatedAt: now.subtract(const Duration(days: 2)),
    ),
    Note(
      id: 'demo-personal-06',
      title: 'Slow mornings',
      body: 'Less scrolling. A warm drink. A few quiet minutes before the day begins.',
      category: 'Personal',
      colorValue: 0xFFF8E3F2,
      pinned: false,
      updatedAt: now.subtract(const Duration(days: 3)),
    ),
  ];
}

ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: brandColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF8F8FC),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF8F8FC),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE9E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: brandColor, width: 1.4),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: brandColor.withOpacity(0.12),
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
        (Set<WidgetState> states) => TextStyle(
          fontSize: 12,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
        ),
      ),
    ),
  );
}

ThemeData darkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: brandColor,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF12131A),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF12131A),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E202A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF30323E)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFAAA0FF), width: 1.4),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF1A1B24),
      indicatorColor: const Color(0xFF8E82FF).withOpacity(0.22),
    ),
  );
}

class NoteFlowApp extends StatefulWidget {
  const NoteFlowApp({
    super.key,
    required this.preferences,
    required this.initialNotes,
    required this.initialDarkMode,
  });

  final SharedPreferences preferences;
  final List<Note> initialNotes;
  final bool initialDarkMode;

  @override
  State<NoteFlowApp> createState() => _NoteFlowAppState();
}

class _NoteFlowAppState extends State<NoteFlowApp> {
  late List<Note> _notes = List<Note>.of(widget.initialNotes);
  late bool _darkMode = widget.initialDarkMode;

  void _saveNotes(List<Note> updatedNotes) {
    setState(() => _notes = List<Note>.of(updatedNotes));
    widget.preferences.setString(storageKey, Note.encodeList(_notes));
  }

  void _toggleTheme() {
    setState(() => _darkMode = !_darkMode);
    widget.preferences.setBool(themeKey, _darkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteFlow',
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      home: NotesHome(
        notes: _notes,
        darkMode: _darkMode,
        onNotesChanged: _saveNotes,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class NotesHome extends StatefulWidget {
  const NotesHome({
    super.key,
    required this.notes,
    required this.darkMode,
    required this.onNotesChanged,
    required this.onToggleTheme,
  });

  final List<Note> notes;
  final bool darkMode;
  final ValueChanged<List<Note>> onNotesChanged;
  final VoidCallback onToggleTheme;

  @override
  State<NotesHome> createState() => _NotesHomeState();
}

class _NotesHomeState extends State<NotesHome> {
  final TextEditingController _searchController = TextEditingController();
  String _activeCategory = 'All';
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() => setState(() {});

  List<Note> get _visibleNotes {
    final String query = _searchController.text.trim().toLowerCase();
    final List<Note> result = widget.notes.where((Note note) {
      if (_selectedTab == 1 && !note.pinned) {
        return false;
      }
      if (_activeCategory != 'All' && note.category != _activeCategory) {
        return false;
      }
      if (query.isEmpty) {
        return true;
      }
      return note.title.toLowerCase().contains(query) ||
          note.body.toLowerCase().contains(query) ||
          note.category.toLowerCase().contains(query);
    }).toList();
    result.sort((Note a, Note b) {
      if (a.pinned != b.pinned) {
        return a.pinned ? -1 : 1;
      }
      return b.updatedAt.compareTo(a.updatedAt);
    });
    return result;
  }

  Future<void> _editNote([Note? note]) async {
    final Note? result = await showModalBottomSheet<Note>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (BuildContext context) => NoteEditorSheet(note: note),
    );

    if (result == null || !mounted) {
      return;
    }

    final List<Note> updated = List<Note>.of(widget.notes);
    final int index = updated.indexWhere((Note item) => item.id == result.id);
    if (index >= 0) {
      updated[index] = result;
    } else {
      updated.insert(0, result);
    }
    widget.onNotesChanged(updated);
  }

  void _togglePin(Note note) {
    final List<Note> updated = List<Note>.of(widget.notes);
    final int index = updated.indexWhere((Note item) => item.id == note.id);
    if (index < 0) {
      return;
    }
    updated[index] = note.copyWith(
      pinned: !note.pinned,
      updatedAt: DateTime.now(),
    );
    widget.onNotesChanged(updated);
  }

  Future<void> _deleteNote(Note note) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete this note?'),
        content: const Text('This note will be removed from this device.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !mounted) {
      return;
    }
    final List<Note> updated =
        widget.notes.where((Note item) => item.id != note.id).toList();
    widget.onNotesChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 76,
        titleSpacing: 20,
        title: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: brandColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: brandColor.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),
            const SizedBox(width: 11),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'NoteFlow',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 2),
                Text(
                  'A calm place to think',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            tooltip:
                widget.darkMode ? 'Switch to light mode' : 'Switch to dark mode',
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.darkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton.filledTonal(
              tooltip: 'New note',
              onPressed: () => _editNote(),
              icon: const Icon(Icons.add_rounded),
            ),
          ),
        ],
      ),
      body: _selectedTab == 2 ? _buildCategories(theme) : _buildNotes(theme),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedTab = index;
            if (index == 1) {
              _activeCategory = 'All';
            }
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.notes_rounded),
            selectedIcon: Icon(Icons.notes_rounded),
            label: 'Notes',
          ),
          NavigationDestination(
            icon: Icon(Icons.push_pin_outlined),
            selectedIcon: Icon(Icons.push_pin_rounded),
            label: 'Pinned',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Categories',
          ),
        ],
      ),
    );
  }

  Widget _buildNotes(ThemeData theme) {
    final List<Note> visibleNotes = _visibleNotes;
    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: brandColor.withOpacity(widget.darkMode ? 0.22 : 0.09),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    _selectedTab == 1 ? 'KEEP WHAT MATTERS CLOSE' : 'YOUR PERSONAL SPACE',
                    style: const TextStyle(
                      color: brandColor,
                      fontSize: 9,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _selectedTab == 1 ? 'Pinned for later.' : 'Your thoughts,',
                  style: TextStyle(
                    fontSize: 29,
                    height: 1.13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (_selectedTab != 1)
                  Text(
                    'well organized.',
                    style: TextStyle(
                      fontSize: 29,
                      height: 1.13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  _selectedTab == 1
                      ? 'Your important ideas, always within reach.'
                      : 'A calm place for every idea.',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: <Widget>[
                    _StatPill(
                      icon: Icons.sticky_note_2_outlined,
                      label: widget.notes.length.toString() +
                          (widget.notes.length == 1 ? ' note' : ' notes'),
                      darkMode: widget.darkMode,
                    ),
                    const SizedBox(width: 8),
                    _StatPill(
                      icon: Icons.offline_bolt_outlined,
                      label: 'Offline & private',
                      darkMode: widget.darkMode,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search your notes...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear search',
                            onPressed: _searchController.clear,
                            icon: const Icon(Icons.close_rounded),
                          ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      _categoryChip('All', theme),
                      for (final String category in noteCategories)
                        _categoryChip(category, theme),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    Text(
                      _activeCategory == 'All' ? 'Recent notes' : _activeCategory,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      visibleNotes.length.toString() + ' shown',
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (visibleNotes.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _emptyState(theme),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 2, 18, 22),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) => _noteCard(
                  visibleNotes[index],
                  theme,
                ),
                childCount: visibleNotes.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.sizeOf(context).width >= 700 ? 3 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio:
                    MediaQuery.sizeOf(context).width >= 700 ? 0.9 : 0.72,
              ),
            ),
          ),
      ],
    );
  }

  Widget _categoryChip(String category, ThemeData theme) {
    final bool selected = _activeCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(category == 'All' ? 'All notes' : category),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => setState(() => _activeCategory = category),
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? Colors.white : theme.colorScheme.onSurfaceVariant,
        ),
        backgroundColor:
            widget.darkMode ? const Color(0xFF20212A) : Colors.white,
        selectedColor: brandColor,
        side: BorderSide(
          color: selected
              ? brandColor
              : theme.colorScheme.outlineVariant.withOpacity(0.55),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5),
      ),
    );
  }

  Widget _emptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(36, 12, 36, 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: brandColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Icon(
                Icons.edit_note_rounded,
                color: brandColor,
                size: 38,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isNotEmpty
                  ? 'No notes found'
                  : 'A fresh page awaits',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w800,
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchController.text.isNotEmpty
                  ? 'Try another search or category.'
                  : 'Capture that thought before it slips away.',
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: () => _editNote(),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create a note'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _noteCard(Note note, ThemeData theme) {
    final Color storedColor = Color(note.colorValue);
    final Color background =
        widget.darkMode ? storedColor.withOpacity(0.19) : storedColor;
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: widget.darkMode
              ? Colors.white.withOpacity(0.07)
              : Colors.black.withOpacity(0.025),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => _editNote(note),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 13, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(
                            widget.darkMode ? 0.09 : 0.65,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          note.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: widget.darkMode
                                ? theme.colorScheme.onSurface
                                : const Color(0xFF454155),
                            fontWeight: FontWeight.w700,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 3),
                    SizedBox(
                      width: 29,
                      height: 29,
                      child: IconButton(
                        tooltip: note.pinned ? 'Unpin note' : 'Pin note',
                        padding: EdgeInsets.zero,
                        onPressed: () => _togglePin(note),
                        icon: Icon(
                          note.pinned
                              ? Icons.push_pin_rounded
                              : Icons.push_pin_outlined,
                          size: 17,
                          color: note.pinned ? brandColor : null,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 26,
                      height: 29,
                      child: PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        iconSize: 18,
                        tooltip: 'Note actions',
                        onSelected: (String value) {
                          if (value == 'edit') {
                            _editNote(note);
                          } else if (value == 'delete') {
                            _deleteNote(note);
                          } else if (value == 'pin') {
                            _togglePin(note);
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Text('Edit note'),
                          ),
                          PopupMenuItem<String>(
                            value: 'pin',
                            child: Text(note.pinned ? 'Unpin note' : 'Pin note'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Delete note'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  note.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.25,
                    color: widget.darkMode
                        ? theme.colorScheme.onSurface
                        : const Color(0xFF242331),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    note.body.isEmpty ? 'No additional details.' : note.body,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.45,
                      color: widget.darkMode
                          ? theme.colorScheme.onSurfaceVariant
                          : const Color(0xFF555466),
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.schedule_rounded,
                      size: 12,
                      color: widget.darkMode
                          ? theme.colorScheme.onSurfaceVariant
                          : const Color(0xFF737184),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        formatNoteDate(note.updatedAt),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          color: widget.darkMode
                              ? theme.colorScheme.onSurfaceVariant
                              : const Color(0xFF737184),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_outward_rounded,
                      size: 14,
                      color: Color(0xFF77718D),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories(ThemeData theme) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Make room for',
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                  ),
                ),
                const Text(
                  'every kind of thought.',
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  'Find notes grouped by what matters to you.',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final String category = noteCategories[index];
                final int count = widget.notes
                    .where((Note note) => note.category == category)
                    .length;
                final Color color = noteColors[index % noteColors.length];
                return Material(
                  color: widget.darkMode ? color.withOpacity(0.18) : color,
                  borderRadius: BorderRadius.circular(24),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      setState(() {
                        _selectedTab = 0;
                        _activeCategory = category;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.65),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              categoryIcon(category),
                              color: const Color(0xFF514A78),
                              size: 24,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            category,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF242331),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            count.toString() + (count == 1 ? ' note' : ' notes'),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF656174),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: noteCategories.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.sizeOf(context).width >= 700 ? 3 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.92,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.label,
    required this.darkMode,
  });

  final IconData icon;
  final String label;
  final bool darkMode;

  @override
  Widget build(BuildContext context) {
    final Color foreground = Theme.of(context).colorScheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: darkMode ? const Color(0xFF20212A) : Colors.white,
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.4),
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 13, color: foreground),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class NoteEditorSheet extends StatefulWidget {
  const NoteEditorSheet({super.key, this.note});

  final Note? note;

  @override
  State<NoteEditorSheet> createState() => _NoteEditorSheetState();
}

class _NoteEditorSheetState extends State<NoteEditorSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController =
      TextEditingController(text: widget.note?.title ?? '');
  late final TextEditingController _bodyController =
      TextEditingController(text: widget.note?.body ?? '');
  late String _category = widget.note?.category ?? 'Personal';
  late int _colorValue = widget.note?.colorValue ?? noteColors.first.toARGB32();
  late bool _pinned = widget.note?.pinned ?? false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final String title = _titleController.text.trim().isEmpty
        ? 'Untitled note'
        : _titleController.text.trim();
    final Note note = Note(
      id: widget.note?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      body: _bodyController.text.trim(),
      category: _category,
      colorValue: _colorValue,
      pinned: _pinned,
      updatedAt: DateTime.now(),
    );
    Navigator.of(context).pop(note);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 26),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        widget.note == null ? 'A new thought' : 'Edit your note',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.7,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  'Keep it simple. You can always come back to it.',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Give your thought a name',
                    prefixIcon: Icon(Icons.title_rounded),
                  ),
                  validator: (String? value) {
                    if ((value == null || value.trim().isEmpty) &&
                        _bodyController.text.trim().isEmpty) {
                      return 'Write a title or add a few details.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 13),
                TextFormField(
                  controller: _bodyController,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: 'Your note',
                    hintText: 'Start writing here...',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.notes_rounded),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'CATEGORY',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 10,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: noteCategories.contains(_category) ? _category : 'Other',
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.folder_outlined),
                  ),
                  items: noteCategories
                      .map(
                        (String category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() => _category = value);
                    }
                  },
                ),
                const SizedBox(height: 18),
                Text(
                  'COLOR',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 10,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: noteColors.map((Color color) {
                    final int value = color.toARGB32();
                    final bool selected = value == _colorValue;
                    return InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => setState(() => _colorValue = value),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected ? brandColor : Colors.transparent,
                            width: selected ? 3 : 1,
                          ),
                        ),
                        child: selected
                            ? const Icon(
                                Icons.check_rounded,
                                size: 18,
                                color: Color(0xFF39334D),
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Pin this note',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  subtitle: const Text('Keep it near the top of your notes.'),
                  value: _pinned,
                  onChanged: (bool value) => setState(() => _pinned = value),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _save,
                    icon: Icon(
                      widget.note == null ? Icons.add_rounded : Icons.check_rounded,
                    ),
                    label: Text(
                      widget.note == null ? 'Save note' : 'Save changes',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

IconData categoryIcon(String category) {
  switch (category) {
    case 'Personal':
      return Icons.person_outline_rounded;
    case 'Work':
      return Icons.work_outline_rounded;
    case 'Ideas':
      return Icons.lightbulb_outline_rounded;
    case 'Study':
      return Icons.school_outlined;
    default:
      return Icons.folder_open_outlined;
  }
}

String formatNoteDate(DateTime date) {
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime day = DateTime(date.year, date.month, date.day);
  if (day == today) {
    return 'Today';
  }
  if (day == today.subtract(const Duration(days: 1))) {
    return 'Yesterday';
  }
  const List<String> months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return date.day.toString() + ' ' + months[date.month - 1];
}
