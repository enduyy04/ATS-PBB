import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/note_provider.dart';
import '../providers/theme_provider.dart';
import 'login_screen.dart';

/// Halaman 6: Profile Screen dengan informasi mahasiswa, statistik, preferensi tema, dan logout
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'NP';
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: AppColors.danger, size: 24),
            SizedBox(width: 10),
            Text('Keluar Akun?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari sesi aplikasi Smart_Notes?',
          style: TextStyle(fontSize: 14, height: 1.4),
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
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              authProvider.logout();

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Anda telah keluar dari aplikasi.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Keluar'),
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
    final themeProvider = context.watch<ThemeProvider>();

    final user = authProvider.currentUser;
    final name = user?.fullName ?? 'Nama Pengguna';
    final nim = user?.nim ?? '2301082001';
    final prodi = user?.prodi ?? 'Teknologi Rekayasa Perangkat Lunak';
    final kelas = user?.kelas ?? 'TRPL 3A';

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Profil Pengguna'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Kartu Avatar & Identitas Mahasiswa
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Avatar Bulat
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(name),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Nama Lengkap
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),

                    // NIM & Kelas
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'NIM: $nim • $kelas',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      prodi,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Statistik Ringkas Mahasiswa
              Container(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCol(
                      count: '${noteProvider.totalNotesCount}',
                      label: 'Catatan',
                      isDark: isDark,
                    ),
                    Container(
                      height: 36,
                      width: 1,
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                    _buildStatCol(
                      count: '${noteProvider.favoriteNotesCount}',
                      label: 'Favorit',
                      isDark: isDark,
                      accentColor: AppColors.favorite,
                    ),
                    Container(
                      height: 36,
                      width: 1,
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                    _buildStatCol(
                      count: '${noteProvider.activeCategoriesCount}',
                      label: 'Kategori',
                      isDark: isDark,
                      accentColor: AppColors.success,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Bagian Preferensi Aplikasi
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pengaturan & Tampilan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                child: Column(
                  children: [
                    // Switch Mode Gelap (Live State Change)
                    SwitchListTile(
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.dark_mode_outlined, color: AppColors.primary, size: 20),
                      ),
                      title: const Text('Mode Gelap (Dark Mode)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      subtitle: const Text('Ubah tema antarmuka aplikasi', style: TextStyle(fontSize: 12)),
                      value: themeProvider.isDarkMode,
                      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.primary;
                        }
                        return Colors.grey.shade400;
                      }),
                      onChanged: (val) {
                        themeProvider.toggleTheme(val);
                      },
                    ),
                    Divider(color: isDark ? AppColors.darkBorder : AppColors.border, height: 1),

                    // Informasi Akademik ATS PPB
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.school_outlined, color: AppColors.success, size: 20),
                      ),
                      title: const Text('Asesmen Tengah Semester (ATS)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      subtitle: const Text('PPB Praktikum • TRPL 2026/2027', style: TextStyle(fontSize: 12)),
                      trailing: const Icon(Icons.info_outline_rounded, size: 18),
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'Smart_Notes',
                          applicationVersion: '1.0.0 (ATS Edition)',
                          applicationIcon: const Icon(Icons.note_alt_rounded, size: 40, color: AppColors.primary),
                          children: const [
                            Text('Aplikasi Smart_Notes dibangun untuk memenuhi kriteria Asesmen Tengah Semester Praktikum Pemrograman Perangkat Bergerak.'),
                            SizedBox(height: 8),
                            Text('Dosen Pengampu: Ahmadi Irmansyah Lubis, Iqbal Afif, Agus Riady.'),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tombol Logout
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(Icons.logout_rounded, color: AppColors.danger, size: 20),
                  label: const Text(
                    'Keluar dari Akun',
                    style: TextStyle(
                      color: AppColors.danger,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.danger, width: 1.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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

  Widget _buildStatCol({
    required String count,
    required String label,
    required bool isDark,
    Color? accentColor,
  }) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: accentColor ?? (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
