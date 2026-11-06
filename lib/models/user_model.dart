/// Model data pengguna untuk otentikasi dummy Smart_Notes
class UserModel {
  final String username;
  final String fullName;
  final String nim;
  final String email;
  final String prodi;
  final String kelas;
  final String semester;

  UserModel({
    required this.username,
    required this.fullName,
    required this.nim,
    required this.email,
    required this.prodi,
    required this.kelas,
    required this.semester,
  });

  /// Inisialisasi data profil default mahasiswa
  factory UserModel.defaultUser() {
    return UserModel(
      username: 'nama_pengguna',
      fullName: 'Nama Pengguna',
      nim: '2301082001',
      email: 'pengguna@mahasiswa.ac.id',
      prodi: 'Teknologi Rekayasa Perangkat Lunak',
      kelas: 'TRPL 3A',
      semester: 'Semester 5 (Ganjil 2026/2027)',
    );
  }

  UserModel copyWith({
    String? username,
    String? fullName,
    String? nim,
    String? email,
    String? prodi,
    String? kelas,
    String? semester,
  }) {
    return UserModel(
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      nim: nim ?? this.nim,
      email: email ?? this.email,
      prodi: prodi ?? this.prodi,
      kelas: kelas ?? this.kelas,
      semester: semester ?? this.semester,
    );
  }
}

