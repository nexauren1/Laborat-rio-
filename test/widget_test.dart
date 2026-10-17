import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noteflow/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows NoteFlow branding and sample note', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      NoteFlowApp(
        preferences: preferences,
        initialNotes: <Note>[
          Note(
            id: 'test-note-1',
            title: 'The art of starting',
            body: 'Every big idea begins with one small step.',
            category: 'Ideas',
            colorValue: 0xFFECE8FF,
            pinned: true,
            updatedAt: DateTime(2026, 10, 17),
          ),
        ],
        initialDarkMode: false,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('NoteFlow'), findsOneWidget);
    expect(find.text('The art of starting'), findsOneWidget);
    expect(find.text('A calm place for every idea.'), findsOneWidget);
  });
}
