import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

/// Provider untuk manajemen autentikasi dummy pengguna
class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Login dengan username dan password
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulasi delay proses autentikasi (responsif & mulus)
    await Future.delayed(const Duration(milliseconds: 600));

    // Validasi dummy: tidak boleh kosong
    if (username.trim().isEmpty || password.trim().isEmpty) {
      _errorMessage = 'Username dan kata sandi tidak boleh kosong.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Berhasil login
    final cleanUsername = username.trim();
    _currentUser = UserModel.defaultUser().copyWith(
      username: cleanUsername,
      fullName: cleanUsername.toLowerCase() == 'nama_pengguna'
          ? 'Nama Pengguna'
          : cleanUsername,
    );
    _isAuthenticated = true;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
    return true;
  }

  /// Login instan menggunakan akun demo mahasiswa (mempermudah pengujian dosen)
  Future<bool> loginDemo() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 400));

    _currentUser = UserModel.defaultUser();
    _isAuthenticated = true;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  /// Logout dari aplikasi
  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Perbarui data profil pengguna
  void updateProfile({
    required String fullName,
    required String nim,
    required String email,
    required String prodi,
    required String kelas,
  }) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        fullName: fullName,
        nim: nim,
        email: email,
        prodi: prodi,
        kelas: kelas,
      );
      notifyListeners();
    }
  }
}

