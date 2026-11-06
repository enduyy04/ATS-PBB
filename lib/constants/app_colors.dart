import 'package:flutter/material.dart';

/// Palet warna utama aplikasi Smart_Notes (Tema Navy & Hijau)
class AppColors {
  // Palet Utama: Navy & Hijau
  static const Color primary = Color(0xFF1B365D);       // Navy utama (Classic Navy Blue)
  static const Color primaryDark = Color(0xFF0F233D);   // Navy pekat
  static const Color primaryLight = Color(0xFF2B4C7E);  // Navy medium / slate
  static const Color secondary = Color(0xFF10B981);     // Hijau utama (Emerald Green)
  static const Color secondaryLight = Color(0xFF34D399);// Hijau muda
  static const Color secondaryDark = Color(0xFF059669); // Hijau tua / Forest
  
  static const Color background = Color(0xFFF6F8FA);    // Background terang bersih (Slate tint)
  static const Color card = Color(0xFFFFFFFF);          // Card putih
  static const Color textPrimary = Color(0xFF0F172A);   // Teks gelap utama (Slate Navy)

  // Variasi Teks & Aksen
  static const Color textSecondary = Color(0xFF475569); // Teks sekunder (Slate 600)
  static const Color textMuted = Color(0xFF94A3B8);     // Teks redup (Slate 400)
  static const Color border = Color(0xFFE2E8F0);        // Garis batas halus (Slate 200)
  static const Color divider = Color(0xFFEEF2F6);       // Pemisah

  // Feedback & Status
  static const Color success = Color(0xFF10B981);       // Hijau sukses
  static const Color warning = Color(0xFFF59E0B);       // Kuning peringatan
  static const Color danger = Color(0xFFEF4444);        // Merah hapus/error
  static const Color favorite = Color(0xFFFFB800);      // Bintang favorit kuning emas

  // Mode Gelap (Dark Mode support Navy Theme)
  static const Color darkBackground = Color(0xFF0A131F); // Navy Gelap Pekat
  static const Color darkCard = Color(0xFF122338);       // Navy Card
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF1D3557);     // Navy Border

  // Warna Kategori Catatan (Aksen & Soft Background)
  static const Map<String, CategoryColor> categoryColors = {
    'Semua': CategoryColor(
      accent: Color(0xFF1B365D), // Navy
      softBackground: Color(0xFFE8EEF5),
    ),
    'Kuliah': CategoryColor(
      accent: Color(0xFF1B365D), // Navy
      softBackground: Color(0xFFEFF4F9),
    ),
    'Pekerjaan': CategoryColor(
      accent: Color(0xFF0F766E), // Teal / Hijau Laut
      softBackground: Color(0xFFF0FDFA),
    ),
    'Pribadi': CategoryColor(
      accent: Color(0xFF10B981), // Hijau Emerald
      softBackground: Color(0xFFECFDF5),
    ),
    'Ide': CategoryColor(
      accent: Color(0xFFF59E0B), // Kuning Emas
      softBackground: Color(0xFFFFFBEB),
    ),
    'Tugas': CategoryColor(
      accent: Color(0xFF059669), // Hijau Tua
      softBackground: Color(0xFFECFDF5),
    ),
  };

  // Pilihan Warna Kustom Kartu Catatan
  static const List<ColorOption> noteColorOptions = [
    ColorOption(name: 'Navy Lembut', color: Color(0xFFEFF4F9), accent: Color(0xFF1B365D)),
    ColorOption(name: 'Hijau Sejuk', color: Color(0xFFECFDF5), accent: Color(0xFF10B981)),
    ColorOption(name: 'Biru Lembut', color: Color(0xFFEFF6FF), accent: Color(0xFF3B82F6)),
    ColorOption(name: 'Kuning Hangat', color: Color(0xFFFFFBEB), accent: Color(0xFFF59E0B)),
    ColorOption(name: 'Hijau Mint', color: Color(0xFFF0FDF4), accent: Color(0xFF16A34A)),
    ColorOption(name: 'Putih Bersih', color: Color(0xFFFFFFFF), accent: Color(0xFF1B365D)),
  ];
}

class CategoryColor {
  final Color accent;
  final Color softBackground;

  const CategoryColor({
    required this.accent,
    required this.softBackground,
  });
}

class ColorOption {
  final String name;
  final Color color;
  final Color accent;

  const ColorOption({
    required this.name,
    required this.color,
    required this.accent,
  });
}

