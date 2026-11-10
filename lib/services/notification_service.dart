import 'package:flutter/material.dart';

/// Pop up singkat (in-app) yang tetap tampil walau pindah halaman.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  /// Dipasang di MaterialApp (scaffoldMessengerKey).
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static const Color _green = Color(0xFF2E9E5B);
  static const Color _red = Color(0xFFE5484D);

  void showLogin() => showSuccess('Login berhasil');

  void showLogout() => _show(
        message: 'Logout berhasil',
        color: _red,
        icon: Icons.logout_rounded,
      );

  void showSuccess(String message) => _show(
        message: message,
        color: _green,
        icon: Icons.check_circle_rounded,
      );

  void showError(String message) => _show(
        message: message,
        color: _red,
        icon: Icons.error_rounded,
      );

  void _show({
    required String message,
    required Color color,
    required IconData icon,
  }) {
    final messenger = messengerKey.currentState;
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: color,
          elevation: 4,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
