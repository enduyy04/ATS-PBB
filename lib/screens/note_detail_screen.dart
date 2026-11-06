import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/note_provider.dart';
import 'note_form_screen.dart';

/// Halaman 5: Detail Catatan dengan aksi favorit, edit, dan hapus permanen
class NoteDetailScreen extends StatelessWidget {
  final String noteId;

  const NoteDetailScreen({
    super.key,
    required this.noteId,
  });

  void _showDeleteConfirmation(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 26),
            SizedBox(width: 10),
            Text('Hapus Catatan?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Catatan "$title" akan dihapus secara permanen. Apakah Anda yakin?',
          style: const TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              final noteProvider = Provider.of<NoteProvider>(context, listen: false);
              noteProvider.deleteNote(noteId);

              // Kembali ke dashboard
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Catatan "$title" berhasil dihapus'),
                  backgroundColor: AppColors.danger,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String title, String content) {
    Clipboard.setData(ClipboardData(text: '$title\n\n$content'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Isi catatan disalin ke clipboard!'),
          ],
        ),
        backgroundColor: AppColors.primary,
        duration: Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final noteProvider = context.watch<NoteProvider>();
    final note = noteProvider.getNoteById(noteId);

    // Jika catatan baru saja dihapus
    if (note == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Catatan')),
        body: const Center(
          child: Text('Catatan ini sudah dihapus atau tidak ditemukan.'),
        ),
      );
    }

    final catColor = AppColors.categoryColors[note.category] ??
        const CategoryColor(
          accent: AppColors.primary,
          softBackground: Color(0xFFEFF4F9),
        );

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Detail Catatan'),
        actions: [
          // Toggle Favorit
          IconButton(
            icon: Icon(
              note.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
              color: note.isFavorite ? AppColors.favorite : null,
              size: 26,
            ),
            tooltip: 'Favorit',
            onPressed: () {
              noteProvider.toggleFavorite(note.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    note.isFavorite
                        ? 'Dihapus dari catatan favorit'
                        : 'Ditambahkan ke catatan favorit ⭐',
                  ),
                  duration: const Duration(milliseconds: 1200),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),

          // Edit Catatan
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 22),
            tooltip: 'Edit',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NoteFormScreen(note: note),
                ),
              );
            },
          ),

          // Hapus Catatan
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 22),
            tooltip: 'Hapus',
            onPressed: () => _showDeleteConfirmation(context, note.title),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge Kategori & Waktu Dibuat
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : catColor.softBackground,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: catColor.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          note.category,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: catColor.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    note.formattedCreatedAt,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Judul Catatan
              Text(
                note.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  letterSpacing: -0.4,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 14),

              Divider(
                color: isDark ? AppColors.darkBorder : AppColors.border,
                thickness: 1,
              ),

              const SizedBox(height: 16),

              // Card Isi Catatan Lengkap
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                    width: 1,
                  ),
                ),
                child: SelectableText(
                  note.content,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.7,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    letterSpacing: 0.1,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Kartu Informasi Meta Catatan
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard.withValues(alpha: 0.5) : AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetaItem(
                      icon: Icons.text_fields_rounded,
                      label: 'Kata',
                      value: '${note.wordCount}',
                      isDark: isDark,
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                    _buildMetaItem(
                      icon: Icons.format_size_rounded,
                      label: 'Karakter',
                      value: '${note.characterCount}',
                      isDark: isDark,
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                    _buildMetaItem(
                      icon: note.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                      label: 'Status',
                      value: note.isFavorite ? 'Favorit' : 'Biasa',
                      isDark: isDark,
                      accent: note.isFavorite ? AppColors.favorite : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tombol Salin Cepat
              Center(
                child: OutlinedButton.icon(
                  onPressed: () => _copyToClipboard(context, note.title, note.content),
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: const Text('Salin Isi Catatan'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.secondary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetaItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
    Color? accent,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 18,
          color: accent ?? (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: accent ?? (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
