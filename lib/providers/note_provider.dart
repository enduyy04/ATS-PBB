import 'package:flutter/foundation.dart';
import '../models/note_model.dart';

/// Provider utama untuk mengelola state catatan di Smart_Notes
class NoteProvider extends ChangeNotifier {
  // Penyimpanan sementara data catatan (In-Memory Dummy Data)
  final List<Note> _notes = [];

  // Filter & Pencarian
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  bool _showOnlyFavorites = false;

  // Daftar Kategori yang didukung
  final List<String> _categories = [
    'Semua',
    'Kuliah',
    'Pekerjaan',
    'Pribadi',
    'Ide',
    'Tugas',
  ];

  NoteProvider() {
    _initDummyData();
  }

  /// Inisialisasi data dummy awal yang realistis dan kaya konten
  void _initDummyData() {
    final now = DateTime.now();

    _notes.addAll([
      Note(
        id: 'note_1',
        title: 'Catatan Kuliah Pemrograman Mobile (Flutter)',
        content:
            'Materi Asesmen Tengah Semester (ATS):\n'
            '1. Arsitektur Antarmuka (Material 3 UI/UX)\n'
            '2. State Management berbasis ChangeNotifier & Provider\n'
            '3. Navigasi multi-halaman modular\n'
            '4. Penanganan Exception & Validasi input form\n\n'
            'Semua data dikelola sementara di Frontend tanpa backend/database eksternal.',
        category: 'Kuliah',
        colorValue: 0xFFEFF4F9, // Soft Navy
        isFavorite: true,
        createdAt: now.subtract(const Duration(hours: 3)),
        updatedAt: now.subtract(const Duration(minutes: 45)),
      ),
      Note(
        id: 'note_2',
        title: 'Ide Proyek Akhir: Smart Campus App',
        content:
            'Konsep aplikasi mobile untuk mempermudah kehidupan mahasiswa di kampus:\n'
            '• Presensi kuliah cepat dengan token dinamis\n'
            '• Notifikasi jadwal praktikum laboratorium otomatis\n'
            '• Peminjaman inventaris alat praktikum IoT\n'
            '• Diskusi forum tugas kelompok antar mahasiswa TRPL.',
        category: 'Ide',
        colorValue: 0xFFFFFBEB, // Soft Amber
        isFavorite: true,
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
      ),
      Note(
        id: 'note_3',
        title: 'Jadwal Praktikum TRPL Semester Ini',
        content:
            'Jadwal Kuliah Mingguan TRPL 3A:\n'
            '• Senin 08.00 - 11.30 : Basis Data Lanjut (Lab 301)\n'
            '• Rabu 13.00 - 16.30 : Pemrograman Perangkat Bergerak (Lab Mobile)\n'
            '• Kamis 09.00 - 12.00 : Rekayasa Kebutuhan Perangkat Lunak\n'
            '• Jumat 14.00 - 16.30 : Desain Antarmuka Pengguna (UI/UX)',
        category: 'Kuliah',
        colorValue: 0xFFEFF6FF,
        isFavorite: false,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      Note(
        id: 'note_4',
        title: 'Daftar Tugas Sprint Proyek Aplikasi',
        content:
            'Checklist pengerjaan frontend:\n'
            '[x] Buat Splash Screen & Login Screen\n'
            '[x] Desain Dashboard dengan Statistik & Pencarian\n'
            '[x] Form Tambah/Edit Catatan dengan validasi\n'
            '[x] Halaman Detail Catatan dengan konfirmasi hapus\n'
            '[x] Halaman Profil Pengguna Mahasiswa\n'
            '[ ] Rekam video vlog demonstrasi aplikasi',
        category: 'Tugas',
        colorValue: 0xFFECFDF5, // Soft Hijau
        isFavorite: true,
        createdAt: now.subtract(const Duration(days: 3, hours: 4)),
      ),
      Note(
        id: 'note_5',
        title: 'Persiapan Presentasi & Demo ATS PPB',
        content:
            'Poin penting saat melakukan vlog demonstrasi:\n'
            '1. Jelaskan arsitektur folder (models, providers, screens, widgets)\n'
            '2. Tunjukkan fungsionalitas CRUD secara live (Tambah, Edit, Hapus, Favorit)\n'
            '3. Tunjukkan pencarian teks dan filter kategori yang responsif\n'
            '4. Tunjukkan validasi form jika input dikosongkan.',
        category: 'Pekerjaan',
        colorValue: 0xFFEFF4F9, // Soft Navy
        isFavorite: false,
        createdAt: now.subtract(const Duration(days: 4)),
      ),
      Note(
        id: 'note_6',
        title: 'Tips Produktivitas Coding Flutter',
        content:
            '• Gunakan widget const semaksimal mungkin untuk optimasi performa rebuild\n'
            '• Manfaatkan Consumer dan Selector pada Provider agar rendering hemat\n'
            '• Terapkan validasi Form dengan GlobalKey<FormState>\n'
            '• Selalu gunakan ScaffoldMessenger untuk menampilkan SnackBar feedback.',
        category: 'Pribadi',
        colorValue: 0xFFECFDF5, // Soft Emerald
        isFavorite: false,
        createdAt: now.subtract(const Duration(days: 5)),
      ),
    ]);
  }

  // =================== GETTERS ===================

  /// Daftar semua catatan tanpa filter
  List<Note> get allNotes => List.unmodifiable(_notes);

  /// Daftar kategori yang tersedia
  List<String> get categories => List.unmodifiable(_categories);

  /// Filter kategori yang sedang aktif
  String get selectedCategory => _selectedCategory;

  /// Query pencarian yang sedang aktif
  String get searchQuery => _searchQuery;

  /// Status apakah hanya menampilkan catatan favorit
  bool get showOnlyFavorites => _showOnlyFavorites;

  /// Daftar catatan yang telah disaring berdasarkan pencarian dan filter
  List<Note> get notes {
    return _notes.where((note) {
      // Filter Kategori
      final matchesCategory = _selectedCategory == 'Semua' ||
          note.category.toLowerCase() == _selectedCategory.toLowerCase();

      // Filter Favorit
      final matchesFavorite = !_showOnlyFavorites || note.isFavorite;

      // Filter Pencarian (judul atau isi)
      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query);

      return matchesCategory && matchesFavorite && matchesSearch;
    }).toList();
  }

  /// Statistik: Total semua catatan
  int get totalNotesCount => _notes.length;

  /// Statistik: Jumlah catatan favorit
  int get favoriteNotesCount => _notes.where((n) => n.isFavorite).length;

  /// Statistik: Jumlah kategori aktif yang memiliki minimal 1 catatan
  int get activeCategoriesCount {
    final set = _notes.map((n) => n.category).toSet();
    return set.length;
  }

  /// Hitung jumlah catatan untuk kategori tertentu
  int getCategoryCount(String category) {
    if (category == 'Semua') {
      return _notes.length;
    }
    return _notes.where((n) => n.category == category).length;
  }

  /// Ambil satu catatan berdasarkan ID
  Note? getNoteById(String id) {
    try {
      return _notes.firstWhere((note) => note.id == id);
    } catch (_) {
      return null;
    }
  }

  // =================== ACTIONS / FITUR DINAMIS ===================

  /// 1. Tambah Catatan Baru
  void addNote({
    required String title,
    required String content,
    required String category,
    int colorValue = 0xFFFFFFFF,
    bool isFavorite = false,
  }) {
    final newNote = Note(
      id: 'note_${DateTime.now().millisecondsSinceEpoch}',
      title: title.trim(),
      content: content.trim(),
      category: category,
      colorValue: colorValue,
      isFavorite: isFavorite,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Tambahkan di awal list agar catatan terbaru muncul paling atas
    _notes.insert(0, newNote);
    notifyListeners();
  }

  /// 2. Edit / Perbarui Catatan yang sudah ada
  bool updateNote({
    required String id,
    required String title,
    required String content,
    required String category,
    int? colorValue,
    bool? isFavorite,
  }) {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      final existing = _notes[index];
      _notes[index] = existing.copyWith(
        title: title.trim(),
        content: content.trim(),
        category: category,
        colorValue: colorValue ?? existing.colorValue,
        isFavorite: isFavorite ?? existing.isFavorite,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  /// 3. Hapus Catatan berdasarkan ID
  bool deleteNote(String id) {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes.removeAt(index);
      notifyListeners();
      return true;
    }
    return false;
  }

  /// 4. Toggle Status Favorit
  void toggleFavorite(String id) {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      final existing = _notes[index];
      _notes[index] = existing.copyWith(
        isFavorite: !existing.isFavorite,
      );
      notifyListeners();
    }
  }

  /// 5. Ubah Query Pencarian
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// 6. Ubah Filter Kategori
  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// 7. Toggle Filter Khusus Favorit
  void toggleShowOnlyFavorites() {
    _showOnlyFavorites = !_showOnlyFavorites;
    notifyListeners();
  }

  /// Reset semua filter ke kondisi awal
  void resetFilters() {
    _searchQuery = '';
    _selectedCategory = 'Semua';
    _showOnlyFavorites = false;
    notifyListeners();
  }
}

