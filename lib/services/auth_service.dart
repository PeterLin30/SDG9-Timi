import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Data akun yang didaftarkan pengguna.
class UserAccount {
  final String name;
  final String phone;
  final String email;
  final String role;
  final String password;

  const UserAccount({
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'email': email,
        'role': role,
        'password': password,
      };

  factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
        name: json['name'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        email: json['email'] as String? ?? '',
        role: json['role'] as String? ?? '',
        password: json['password'] as String? ?? '',
      );
}

/// Autentikasi tiruan (mock) tanpa backend + penyimpanan lokal akun & "Ingat saya".
/// Catatan: kata sandi disimpan apa adanya hanya untuk keperluan demo.
/// Pada aplikasi sungguhan, gunakan backend dan jangan simpan kata sandi di perangkat.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  // Akun demo. Ganti/tambah sesuai kebutuhan.
  static const Map<String, String> _demoAccounts = {
    'admin@mikrohub.com': '123456',
    'user@mikrohub.com': 'user123',
  };

  static const String _rememberKey = 'remembered_email';
  static const String _usersKey = 'registered_users';

  final List<UserAccount> _users = [];

  /// Akun yang sedang login (null jika akun demo atau belum login).
  UserAccount? currentUser;

  /// Panggil sekali di main() sebelum runApp.
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_usersKey);
      if (raw == null || raw.isEmpty) return;
      final list = jsonDecode(raw) as List<dynamic>;
      _users
        ..clear()
        ..addAll(
          list.map((e) => UserAccount.fromJson(e as Map<String, dynamic>)),
        );
    } catch (_) {}
  }

  String _normalize(String email) => email.trim().toLowerCase();

  UserAccount? _findUser(String email) {
    final key = _normalize(email);
    for (final u in _users) {
      if (u.email == key) return u;
    }
    return null;
  }

  bool isRegistered(String email) =>
      _demoAccounts.containsKey(_normalize(email)) ||
      _findUser(email) != null;

  /// Mendaftarkan akun baru. Mengembalikan pesan error, atau null jika berhasil.
  Future<String?> register({
    required String name,
    required String phone,
    required String email,
    required String role,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // simulasi jaringan

    if (isRegistered(email)) return 'Email sudah terdaftar';

    final phoneKey = phone.trim();
    if (_users.any((u) => u.phone == phoneKey)) {
      return 'Nomor telepon sudah terdaftar';
    }

    _users.add(UserAccount(
      name: name.trim(),
      phone: phoneKey,
      email: _normalize(email),
      role: role,
      password: password,
    ));

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _usersKey,
        jsonEncode(_users.map((u) => u.toJson()).toList()),
      );
    } catch (_) {}
    return null;
  }

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // simulasi jaringan
    final key = _normalize(email);

    if (_demoAccounts[key] == password) {
      currentUser = null;
      return true;
    }

    final user = _findUser(key);
    if (user != null && user.password == password) {
      currentUser = user;
      return true;
    }
    return false;
  }

  void logout() => currentUser = null;

  Future<void> sendResetLink(String email) async {
    await Future.delayed(const Duration(seconds: 1)); // simulasi jaringan
  }

  Future<String?> getRememberedEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_rememberKey);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveRememberedEmail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_rememberKey, email.trim());
    } catch (_) {}
  }

  Future<void> clearRememberedEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_rememberKey);
    } catch (_) {}
  }
}
