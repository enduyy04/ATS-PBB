# Smart_Notes 📱✨
**Aplikasi Manajemen Catatan Mahasiswa Modern berbasis Flutter (Frontend Only)**  
*Disusun untuk Asesmen Tengah Semester (ATS) Praktikum Pemrograman Perangkat Bergerak (RPL317)*  
*Program Studi Teknologi Rekayasa Perangkat Lunak (TRPL)*
ko
---

## 📌 1. Deskripsi Proyek
**Smart_Notes** adalah aplikasi mobile pintar untuk pencatatan materi kuliah, tugas, ide proyek, dan jadwal praktikum. Aplikasi ini dibangun secara murni pada sisi **Frontend** menggunakan Flutter dan Dart dengan konsep **Material Design 3**, pengelolaan state dinamis dengan **ChangeNotifier & Provider**, serta memanfaatkan in-memory dummy data tanpa ketergantungan pada backend maupun database eksternal (MySQL/SQLite/Firebase).

Aplikasi dirancang responsif, mempertahankan state saat rotasi layar maupun pergantian halaman, serta memiliki navigasi modular dan penanganan error/validasi input yang lengkap.

-

## 🎨 2. Palet Warna & Desain UI/UX
Mengikuti standar palet warna yang telah ditentukan:
- **Ungu Utama (`#6C4DDA`)**: Warna primer pada AppBar, tombol utama, dan branding.
- **Ungu Muda (`#9279F0`)**: Aksen gradient dan highlight elemen aktif.
- **Background (`#F7F6FC`)**: Latar belakang bersih dan ramah di mata.
- **Card (`#FFFFFF`)**: Kartu dengan *rounded corner* (`BorderRadius.circular(20)`).
- **Teks Utama (`#24213A`)**: Tipografi tajam, profesional, dan mudah dibaca.
- **Dukungan Dark Mode**: Otomatis beradaptasi dengan kenyamanan visual di malam hari.

---

## 📱 3. Enam (6) Halaman Aplikasi
Aplikasi dilengkapi minimal 6 halaman dengan navigasi interaktif:
1. **Splash Screen (`splash_screen.dart`)**:
   - Branding animasi scale & fade logo Smart_Notes.
   - Timer otomatis (2.5 detik) menuju Login Screen serta tombol pintas "Mulai Sekarang".
2. **Login Screen (`login_screen.dart`)**:
   - Form autentikasi dummy mahasiswa.
   - Validasi input (username & kata sandi tidak boleh kosong).
   - Fitur *obscure text* (tampilkan/sembunyikan password) & remember me.
   - Tombol **⚡ Masuk Instan (Akun Demo)** untuk pengujian 1-klik dosen.
3. **Dashboard Screen (`dashboard_screen.dart`)**:
   - Header salam personal dan avatar mahasiswa (navigasi ke profil).
   - Kartu statistik ringkasan otomatis (Total Catatan, Favorit, Kategori Aktif).
   - Bilah pencarian real-time (berdasarkan judul dan isi catatan).
   - Filter chip kategori interaktif dengan badge hitungan data.
   - Filter cepat catatan favorit.
   - Daftar catatan (*RecyclerView/ListView*) dengan kartu modern.
   - Floating Action Button (FAB) "+ Catatan Baru".
   - Tampilan *Empty State* ketika hasil pencarian atau catatan kosong.
4. **Tambah/Edit Catatan (`note_form_screen.dart`)**:
   - Formulir dinamis untuk membuat catatan baru atau menyunting catatan yang ada.
   - Validasi wajib isi pada Judul dan Konten Catatan.
   - Pemilihan kategori (*Kuliah, Pekerjaan, Pribadi, Ide, Tugas*).
   - Pemilihan palet warna aksen kartu catatan.
   - Switch untuk menandai catatan sebagai favorit.
5. **Detail Catatan (`note_detail_screen.dart`)**:
   - Tampilan isi catatan lengkap dengan tipografi proporsional.
   - Badge kategori, tanggal pembuatan, jumlah kata, dan jumlah karakter.
   - Tombol toggle favorit di AppBar dengan pembaruan instan.
   - Tombol Edit (membuka formulir dengan data terisi).
   - Tombol Hapus dengan **AlertDialog Konfirmasi** sebelum penghapusan permanen.
   - Tombol cepat salin isi ke clipboard.
6. **Profile Screen (`profile_screen.dart`)**:
   - Identitas mahasiswa (Nama, NIM: 2301082001, Prodi TRPL, Kelas TRPL 3A).
   - Statistik riwayat aktivitas pencatatan.
   - Informasi akademik mata kuliah ATS PPB (RPL317).
   - Toggle switch **Mode Gelap (Dark Mode)** secara real-time.
   - Tombol Logout dengan konfirmasi dialog untuk kembali ke halaman Login.

---

## ⚡ 4. Fitur-Fitur Dinamis (State Management)
Dikelola menggunakan `ChangeNotifier` dan `Provider`:
1. **Tambah Catatan**: Menambahkan catatan baru langsung ke daftar teratas tanpa reload.
2. **Tampilkan Daftar Catatan**: Rendering real-time menggunakan `ListView.builder`.
3. **Edit Catatan**: Memperbarui judul, isi, kategori, dan warna catatan secara langsung.
4. **Hapus Catatan**: Menghapus catatan dengan dialog konfirmasi dan notifikasi SnackBar.
5. **Pencarian Real-Time**: Menyaring catatan berdasarkan kesesuaian judul maupun teks isi secara instan.
6. **Filter Kategori**: Menyaring catatan berdasarkan kategori aktif beserta badge jumlah item.
7. **Tandai Favorit**: Mengubah status bintang favorit secara langsung dari kartu maupun halaman detail.
8. **Statistik Otomatis**: Menghitung total catatan, jumlah favorit, dan kategori secara reaktif.

---

## 📂 5. Struktur Direktori Proyek
```
smart_notes/
├── lib/
│   ├── constants/
│   │   ├── app_colors.dart        # Definisi palet warna ungu & tema
│   │   └── app_theme.dart         # Konfigurasi Material 3 Light & Dark
│   ├── models/
│   │   ├── note_model.dart        # Model data catatan & helper formatting
│   │   └── user_model.dart        # Model data profil mahasiswa
│   ├── providers/
│   │   ├── auth_provider.dart     # State manajemen autentikasi dummy
│   │   ├── note_provider.dart     # State manajemen catatan & CRUD filter
│   │   └── theme_provider.dart    # State manajemen Dark/Light mode
│   ├── screens/
│   │   ├── splash_screen.dart     # Halaman 1: Splash Screen
│   │   ├── login_screen.dart      # Halaman 2: Login Form & Validasi
│   │   ├── dashboard_screen.dart  # Halaman 3: Dashboard & Statistik
│   │   ├── note_form_screen.dart  # Halaman 4: Tambah/Edit Catatan
│   │   ├── note_detail_screen.dart# Halaman 5: Detail & Konfirmasi Hapus
│   │   └── profile_screen.dart    # Halaman 6: Profil & Pengaturan
│   ├── widgets/
│   │   ├── category_chip.dart     # Widget Chip Kategori & badge
│   │   ├── custom_button.dart     # Widget Tombol utama & loading
│   │   ├── custom_search_bar.dart # Widget Search Bar dinamis
│   │   ├── empty_state.dart       # Widget tampilan saat data nihil
│   │   ├── note_card.dart         # Widget Card Catatan interaktif
│   │   └── stat_card.dart         # Widget Kartu Statistik
│   └── main.dart                  # Titik masuk utama & MultiProvider setup
├── test/
│   └── widget_test.dart           # Unit test & Widget test
└── pubspec.yaml                   # Konfigurasi dependensi Flutter
```

---

## 🚀 6. Cara Menjalankan Proyek
1. Buka folder proyek di Visual Studio Code atau terminal:
   ```bash
   cd C:\Users\gendu\.gemini\antigravity\scratch\smart_notes
   ```
2. Pastikan paket dependensi terpasang:
   ```bash
   flutter pub get
   ```
3. Jalankan aplikasi pada emulator atau perangkat:
   ```bash
   flutter run
   ```
4. Atau jalankan unit test untuk verifikasi fungsionalitas:
   ```bash
   flutter test
   ```

---

## 👨‍💻 7. Petunjuk Pembuatan Laporan & Rekaman Vlog ATS
1. **Langkah Kerja**: Tuliskan arsitektur folder (model-provider-screen-widget), palet warna Material 3, dan alur data in-memory.
2. **Video Vlog Real-Time**:
   - Buka aplikasi dari Splash Screen -> Login (tunjukkan validasi kosong & login instan).
   - Jelaskan statistik dashboard dan dummy data awal.
   - Demonstrasikan pencarian kata kunci dan filter kategori.
   - Tambah catatan baru, periksa penambahan statistik secara otomatis.
   - Buka detail catatan, lakukan penyuntingan (edit), dan uji coba fitur hapus dengan konfirmasi.
   - Masuk ke profil pengguna, demonstrasikan toggle Mode Gelap (Dark Mode), dan logout.
