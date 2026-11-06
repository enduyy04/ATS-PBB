import 'package:flutter_test/flutter_test.dart';
import 'package:smart_notes/main.dart';
import 'package:smart_notes/providers/note_provider.dart';

void main() {
  testWidgets('SmartNotesApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartNotesApp());
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Smart_Notes'), findsOneWidget);
    expect(find.text('Catat Cepat, Rapi, & Pintar'), findsOneWidget);
  });

  test('NoteProvider CRUD & Filter unit tests', () {
    final provider = NoteProvider();

    // 1. Initial dummy notes check
    expect(provider.totalNotesCount, greaterThanOrEqualTo(5));
    final initialCount = provider.totalNotesCount;

    // 2. Add note
    provider.addNote(
      title: 'Catatan Baru Test',
      content: 'Isi catatan uji coba unit test',
      category: 'Kuliah',
      isFavorite: true,
    );
    expect(provider.totalNotesCount, equals(initialCount + 1));
    expect(provider.notes.first.title, equals('Catatan Baru Test'));

    // 3. Search note
    provider.setSearchQuery('uji coba');
    expect(provider.notes.length, equals(1));
    provider.setSearchQuery('');

    // 4. Filter category
    provider.setSelectedCategory('Kuliah');
    expect(provider.notes.every((n) => n.category == 'Kuliah'), isTrue);

    // 5. Toggle favorite
    final testNoteId = provider.notes.first.id;
    final initialFav = provider.notes.first.isFavorite;
    provider.toggleFavorite(testNoteId);
    expect(provider.getNoteById(testNoteId)?.isFavorite, equals(!initialFav));

    // 6. Delete note
    final countBeforeDelete = provider.totalNotesCount;
    provider.deleteNote(testNoteId);
    expect(provider.totalNotesCount, equals(countBeforeDelete - 1));
  });
}
