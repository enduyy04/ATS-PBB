import 'package:intl/intl.dart';

/// Model data catatan (Note) untuk Smart_Notes
class Note {
  final String id;
  final String title;
  final String content;
  final String category;
  final int colorValue; // Nilai warna latar kartu (ARGB int)
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.colorValue = 0xFFFFFFFF,
    this.isFavorite = false,
    required this.createdAt,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? createdAt;

  /// Hitung jumlah kata pada isi catatan
  int get wordCount {
    if (content.trim().isEmpty) return 0;
    return content.trim().split(RegExp(r'\s+')).length;
  }

  /// Hitung jumlah karakter pada isi catatan
  int get characterCount => content.length;

  /// Format tanggal pembuatan yang mudah dibaca (misal: 04 Nov 2026, 14:30)
  String get formattedCreatedAt {
    return DateFormat('dd MMM yyyy, HH:mm').format(createdAt);
  }

  /// Format tanggal update
  String get formattedUpdatedAt {
    return DateFormat('dd MMM yyyy, HH:mm').format(updatedAt);
  }

  /// Format tanggal ringkas (misal: 4 Nov)
  String get shortDate {
    final now = DateTime.now();
    if (createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day) {
      return 'Hari ini, ${DateFormat('HH:mm').format(createdAt)}';
    }
    return DateFormat('dd MMM yyyy').format(createdAt);
  }

  /// Salin catatan dengan modifikasi sebagian atribut (Immutability pattern)
  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    int? colorValue,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      colorValue: colorValue ?? this.colorValue,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

