import 'dart:async';

import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../widgets/auth_input.dart';
import 'forgot_password_page.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  /// Opsional: isi otomatis kolom email (mis. setelah register).
  final String initialEmail;

  const LoginPage({super.key, this.initialEmail = ''});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  static const int _maxAttempts = 5;
  static const int _lockSeconds = 30;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  int _failedAttempts = 0;
  int _remainingLock = 0;
  Timer? _lockTimer;

  late final AnimationController _entryController;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  bool get _isLocked => _remainingLock > 0;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _entryController, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOut));
    _entryController.forward();

    _emailController.text = widget.initialEmail;
    _loadRememberedEmail();
  }

  Future<void> _loadRememberedEmail() async {
    if (widget.initialEmail.isNotEmpty) return;
    final email = await AuthService.instance.getRememberedEmail();
    if (!mounted || email == null || email.isEmpty) return;
    setState(() {
      _emailController.text = email;
      _rememberMe = true;
    });
  }

  @override
  void dispose() {
    _lockTimer?.cancel();
    _entryController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _startLock() {
    setState(() => _remainingLock = _lockSeconds);
    _lockTimer?.cancel();
    _lockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _remainingLock--);
      if (_remainingLock <= 0) {
        timer.cancel();
        setState(() => _failedAttempts = 0);
      }
    });
  }

  Future<void> _login() async {
    if (_isLocked || _isLoading) return;

    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final success =
        await AuthService.instance.login(email, _passwordController.text);

    if (!mounted) return;

    if (success) {
      if (_rememberMe) {
        await AuthService.instance.saveRememberedEmail(email);
      } else {
        await AuthService.instance.clearRememberedEmail();
      }
      if (!mounted) return;

      setState(() => _isLoading = false);
      NotificationService.instance.showLogin();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      _failedAttempts++;
      setState(() => _isLoading = false);

      if (_failedAttempts >= _maxAttempts) {
        _startLock();
        NotificationService.instance.showError(
          'Terlalu banyak percobaan. Coba lagi dalam $_lockSeconds detik.',
        );
      } else {
        NotificationService.instance.showError(
          'Email atau kata sandi salah. '
          'Sisa percobaan: ${_maxAttempts - _failedAttempts}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Navigator.of(context).canPop() ? AppBar() : null,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              color: authLightCyan,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(
                              Icons.storefront_rounded,
                              size: 44,
                              color: authPrimaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Selamat Datang',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: authTextColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Masuk ke akun MikroHub UMKM Anda',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF777777),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: authInputDecoration(
                            label: 'Email',
                            icon: Icons.email_outlined,
                          ),
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            if (text.isEmpty) return 'Email wajib diisi';
                            final valid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                .hasMatch(text);
                            if (!valid) return 'Format email tidak valid';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Kata sandi
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _login(),
                          decoration: authInputDecoration(
                            label: 'Kata sandi',
                            icon: Icons.lock_outline_rounded,
                            suffix: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF9AA0A6),
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Kata sandi wajib diisi';
                            }
                            if (value.length < 6) {
                              return 'Kata sandi minimal 6 karakter';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),

                        // Ingat saya & Lupa kata sandi
                        Row(
                          children: [
                            SizedBox(
                              width: 28,
                              height: 28,
                              child: Checkbox(
                                value: _rememberMe,
                                activeColor: authPrimaryColor,
                                onChanged: (v) =>
                                    setState(() => _rememberMe = v ?? false),
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _rememberMe = !_rememberMe),
                              child: const Text(
                                'Ingat saya',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ForgotPasswordPage(
                                      initialEmail:
                                          _emailController.text.trim(),
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Lupa kata sandi?',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: authPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Tombol masuk
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: (_isLoading || _isLocked) ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: authPrimaryColor,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: _isLocked
                                  ? const Color(0xFFBDBDBD)
                                  : const Color(0xFF9EDEE0),
                              disabledForegroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    _isLocked
                                        ? 'Coba lagi dalam $_remainingLock dtk'
                                        : 'Masuk',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Link ke halaman daftar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Belum punya akun?',
                              style: TextStyle(fontSize: 13),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const RegisterPage(),
                                ),
                              ),
                              child: const Text(
                                'Daftar',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: authPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Info akun demo (hapus jika tidak diperlukan)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6FBFB),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: authLightCyan),
                          ),
                          child: const Text(
                            'Akun demo\nadmin@mikrohub.com / 123456\nuser@mikrohub.com / user123',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: Color(0xFF777777),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
