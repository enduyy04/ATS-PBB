import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/note_model.dart';

/// Kartu catatan modern dengan rounded corner, badge kategori, dan status favorit
class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onToggleFavorite,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final catColor = AppColors.categoryColors[note.category] ??
        const CategoryColor(
          accent: AppColors.primary,
          softBackground: Color(0xFFEFF4F9),
        );

    // Warna background card: jika custom pastel dipilih dan bukan dark mode
    final cardBgColor = isDark
        ? AppColors.darkCard
        : (note.colorValue != 0xFFFFFFFF
            ? Color(note.colorValue)
            : Colors.white);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder
              : (note.isFavorite
                  ? AppColors.secondary.withValues(alpha: 0.6)
                  : AppColors.border),
          width: note.isFavorite ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Baris Atas: Kategori Pill + Tombol Favorit + Menu
                Row(
                  children: [
                    // Badge Kategori
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : catColor.softBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: catColor.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            note.category,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: catColor.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),

                    // Tombol Favorit
                    IconButton(
                      icon: Icon(
                        note.isFavorite
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: note.isFavorite
                            ? AppColors.favorite
                            : (isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
                        size: 24,
                      ),
                      visualDensity: VisualDensity.compact,
                      splashRadius: 20,
                      onPressed: onToggleFavorite,
                      tooltip: note.isFavorite
                          ? 'Hapus dari favorit'
                          : 'Tandai sebagai favorit',
                    ),

                    // Menu Opsi Lainnya (Edit / Hapus)
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        size: 20,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      onSelected: (value) {
                        if (value == 'edit') onEdit();
                        if (value == 'delete') onDelete();
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                              SizedBox(width: 10),
                              Text('Edit Catatan', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.danger),
                              SizedBox(width: 10),
                              Text('Hapus', style: TextStyle(fontSize: 14, color: AppColors.danger)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Judul Catatan
                Text(
                  note.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                // Isi Cuplikan Catatan
                Text(
                  note.content,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 14),

                // Footer: Waktu & Jumlah Kata
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          note.shortDate,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${note.wordCount} kata',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                      ),
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
}
