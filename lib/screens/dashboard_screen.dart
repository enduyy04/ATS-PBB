import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/note_model.dart';
import '../providers/auth_provider.dart';
import '../providers/note_provider.dart';
import '../widgets/category_chip.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_card.dart';
import '../widgets/stat_card.dart';
import 'note_detail_screen.dart';
import 'note_form_screen.dart';
import 'profile_screen.dart';

/// Halaman 3: Dashboard Screen dengan statistik dinamis, pencarian, dan filter
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'NP';
  }

  void _showDeleteConfirmation(BuildContext context, Note note) {
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
          'Catatan "${note.title}" akan dihapus dari aplikasi. Tindakan ini tidak dapat dibatalkan.',
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
              noteProvider.deleteNote(note.id);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Catatan "${note.title}" berhasil dihapus'),
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();
    final noteProvider = context.watch<NoteProvider>();

    final user = authProvider.currentUser;
    final userName = user != null
        ? (user.fullName.isNotEmpty ? user.fullName : user.username)
        : 'Nama Pengguna';
    final notes = noteProvider.notes;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Simulasi pull to refresh ringan
            await Future.delayed(const Duration(milliseconds: 300));
          },
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // 1. Header Profil & Salam
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Halo, $userName 👋',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                letterSpacing: -0.4,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Kelola catatan kuliah & tugas Anda',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Tombol Avatar Profil
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ProfileScreen()),
                          );
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _getInitials(userName),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Statistik Ringkasan Otomatis
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      StatCard(
                        title: 'Total Catatan',
                        value: '${noteProvider.totalNotesCount}',
                        icon: Icons.note_alt_outlined,
                        accentColor: AppColors.primary,
                        onTap: () => noteProvider.resetFilters(),
                      ),
                      const SizedBox(width: 10),
                      StatCard(
                        title: 'Favorit',
                        value: '${noteProvider.favoriteNotesCount}',
                        icon: Icons.star_rounded,
                        accentColor: AppColors.favorite,
                        onTap: () => noteProvider.toggleShowOnlyFavorites(),
                      ),
                      const SizedBox(width: 10),
                      StatCard(
                        title: 'Kategori Aktif',
                        value: '${noteProvider.activeCategoriesCount}',
                        icon: Icons.category_outlined,
                        accentColor: AppColors.success,
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 18)),

              // 3. Bilah Pencarian Real-Time
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomSearchBar(
                    query: noteProvider.searchQuery,
                    onChanged: (val) => noteProvider.setSearchQuery(val),
                    onClear: () => noteProvider.setSearchQuery(''),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 14)),

              // 4. Filter Kategori & Tombol Favorit
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 42,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      // Tombol Toggle Favorit Cepat
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          avatar: Icon(
                            noteProvider.showOnlyFavorites
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            size: 16,
                            color: noteProvider.showOnlyFavorites
                                ? Colors.white
                                : AppColors.favorite,
                          ),
                          label: Text(
                            'Favorit (${noteProvider.favoriteNotesCount})',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: noteProvider.showOnlyFavorites
                                  ? Colors.white
                                  : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                            ),
                          ),
                          selected: noteProvider.showOnlyFavorites,
                          selectedColor: AppColors.favorite,
                          backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                          side: BorderSide(
                            color: noteProvider.showOnlyFavorites
                                ? AppColors.favorite
                                : (isDark ? AppColors.darkBorder : AppColors.border),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onSelected: (_) => noteProvider.toggleShowOnlyFavorites(),
                        ),
                      ),

                      // Daftar Chip Kategori
                      ...noteProvider.categories.map((category) {
                        final isSelected = noteProvider.selectedCategory == category;
                        final count = noteProvider.getCategoryCount(category);

                        return CategoryFilterChip(
                          label: category,
                          count: count,
                          isSelected: isSelected,
                          onTap: () => noteProvider.setSelectedCategory(category),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // 5. Header List Catatan & Info Hasil
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        noteProvider.selectedCategory == 'Semua'
                            ? (noteProvider.showOnlyFavorites
                                ? 'Catatan Favorit'
                                : 'Semua Catatan')
                            : 'Kategori: ${noteProvider.selectedCategory}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${notes.length} item',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 8)),

              // 6. Daftar Catatan Dinamis (RecyclerView / ListView)
              if (notes.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyStateWidget(
                    title: noteProvider.searchQuery.isNotEmpty
                        ? 'Catatan Tidak Ditemukan'
                        : (noteProvider.showOnlyFavorites
                            ? 'Belum Ada Catatan Favorit'
                            : 'Belum Ada Catatan'),
                    subtitle: noteProvider.searchQuery.isNotEmpty
                        ? 'Tidak ditemukan catatan dengan kata kunci "${noteProvider.searchQuery}". Silakan coba kata kunci lain.'
                        : 'Mulai buat catatan kuliah atau tugas baru dengan menekan tombol tambah.',
                    icon: noteProvider.searchQuery.isNotEmpty
                        ? Icons.search_off_rounded
                        : Icons.note_alt_outlined,
                    buttonText: noteProvider.searchQuery.isNotEmpty
                        ? 'Reset Pencarian'
                        : '+ Tambah Catatan Baru',
                    onButtonPressed: () {
                      if (noteProvider.searchQuery.isNotEmpty ||
                          noteProvider.showOnlyFavorites ||
                          noteProvider.selectedCategory != 'Semua') {
                        noteProvider.resetFilters();
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const NoteFormScreen()),
                        );
                      }
                    },
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 80),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final note = notes[index];
                        return NoteCard(
                          key: ValueKey(note.id),
                          note: note,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => NoteDetailScreen(noteId: note.id),
                              ),
                            );
                          },
                          onToggleFavorite: () {
                            noteProvider.toggleFavorite(note.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  note.isFavorite
                                      ? 'Dihapus dari favorit'
                                      : 'Ditandai sebagai favorit ⭐',
                                ),
                                duration: const Duration(milliseconds: 1200),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          onEdit: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => NoteFormScreen(note: note),
                              ),
                            );
                          },
                          onDelete: () => _showDeleteConfirmation(context, note),
                        );
                      },
                      childCount: notes.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),

      // Floating Action Button: Tambah Catatan Baru
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NoteFormScreen()),
          );
        },
        backgroundColor: AppColors.secondary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Catatan Baru',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
