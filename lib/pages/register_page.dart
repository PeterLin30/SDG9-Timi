import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../widgets/auth_input.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static const List<String> _roles = ['Pemilik UMKM', 'Developer'];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _role;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agree = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_isLoading) return;
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    if (!_agree) {
      NotificationService.instance
          .showError('Setujui syarat & ketentuan terlebih dahulu');
      return;
    }

    setState(() => _isLoading = true);

    final error = await AuthService.instance.register(
      name: _nameController.text,
      phone: _phoneController.text.replaceAll(RegExp(r'[\s-]'), ''),
      email: _emailController.text,
      role: _role!,
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      NotificationService.instance.showError(error);
      return;
    }

    final email = _emailController.text.trim();
    NotificationService.instance
        .showSuccess('Pendaftaran berhasil. Silakan masuk.');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LoginPage(initialEmail: email)),
    );
  }

  // Syarat kata sandi: (label, terpenuhi?)
  List<(String, bool)> _passwordRules(String p) => [
        ('Minimal 8 karakter', p.length >= 8),
        ('Huruf besar (A-Z)', RegExp(r'[A-Z]').hasMatch(p)),
        ('Huruf kecil (a-z)', RegExp(r'[a-z]').hasMatch(p)),
        ('Angka (0-9)', RegExp(r'[0-9]').hasMatch(p)),
        ('Simbol (!@#\$%...)', RegExp(r'[^A-Za-z0-9]').hasMatch(p)),
      ];

  Widget _buildStrengthIndicator() {
    final rules = _passwordRules(_passwordController.text);
    final met = rules.where((r) => r.$2).length;

    late final String label;
    late final Color color;
    if (met <= 2) {
      label = 'Lemah';
      color = const Color(0xFFE5484D);
    } else if (met <= 4) {
      label = 'Sedang';
      color = const Color(0xFFF5A623);
    } else {
      label = 'Kuat';
      color = const Color(0xFF2E9E5B);
    }
    // Bar terisi: 1 = lemah, 2 = sedang, 3 = kuat
    final filled = met <= 2 ? 1 : (met <= 4 ? 2 : 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (int i = 0; i < 3; i++) ...[
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 5,
                  decoration: BoxDecoration(
                    color: i < filled ? color : const Color(0xFFE3E8E8),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              if (i < 2) const SizedBox(width: 6),
            ],
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            for (final r in rules)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    r.$2 ? Icons.check_circle_rounded : Icons.circle_outlined,
                    size: 14,
                    color: r.$2
                        ? const Color(0xFF2E9E5B)
                        : const Color(0xFF9AA0A6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    r.$1,
                    style: TextStyle(
                      fontSize: 12,
                      color: r.$2
                          ? const Color(0xFF2E9E5B)
                          : const Color(0xFF777777),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Daftar Akun')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Buat akun baru',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: authTextColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Lengkapi data diri Anda untuk bergabung di MikroHub UMKM',
                      style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
                    ),
                    const SizedBox(height: 24),

                    // Nama lengkap
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: authInputDecoration(
                        label: 'Nama lengkap',
                        icon: Icons.person_outline_rounded,
                      ),
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) return 'Nama wajib diisi';
                        if (text.length < 3) return 'Nama minimal 3 karakter';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Nomor telepon
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s-]')),
                      ],
                      decoration: authInputDecoration(
                        label: 'Nomor telepon',
                        icon: Icons.phone_outlined,
                      ),
                      validator: (value) {
                        final text =
                            (value ?? '').replaceAll(RegExp(r'[\s-]'), '');
                        if (text.isEmpty) return 'Nomor telepon wajib diisi';
                        final valid =
                            RegExp(r'^(\+62|62|0)8[0-9]{8,11}$').hasMatch(text);
                        if (!valid) {
                          return 'Nomor tidak valid (contoh: 081234567890)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

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

                    // Daftar sebagai
                    DropdownButtonFormField<String>(
                      value: _role,
                      isExpanded: true,
                      decoration: authInputDecoration(
                        label: 'Daftar sebagai',
                        icon: Icons.badge_outlined,
                      ),
                      items: _roles
                          .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                          .toList(),
                      onChanged: (v) => setState(() => _role = v),
                      validator: (v) => v == null ? 'Pilih salah satu' : null,
                    ),
                    const SizedBox(height: 16),

                    // Kata sandi
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => setState(() {}),
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
                        final met =
                            _passwordRules(value).where((r) => r.$2).length;
                        if (met <= 2) {
                          return 'Kata sandi terlalu lemah';
                        }
                        return null;
                      },
                    ),
                    if (_passwordController.text.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _buildStrengthIndicator(),
                    ],
                    const SizedBox(height: 16),

                    // Konfirmasi kata sandi
                    TextFormField(
                      controller: _confirmController,
                      obscureText: _obscureConfirm,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _register(),
                      decoration: authInputDecoration(
                        label: 'Konfirmasi kata sandi',
                        icon: Icons.lock_reset_rounded,
                        suffix: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF9AA0A6),
                          ),
                          onPressed: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konfirmasi kata sandi wajib diisi';
                        }
                        if (value != _passwordController.text) {
                          return 'Kata sandi tidak cocok';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Syarat & ketentuan
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: Checkbox(
                            value: _agree,
                            activeColor: authPrimaryColor,
                            onChanged: (v) =>
                                setState(() => _agree = v ?? false),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _agree = !_agree),
                            child: const Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                'Saya menyetujui syarat & ketentuan serta kebijakan privasi MikroHub UMKM',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Tombol daftar
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: authPrimaryColor,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFF9EDEE0),
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
                            : const Text(
                                'Daftar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Sudah punya akun?',
                          style: TextStyle(fontSize: 13),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          ),
                          child: const Text(
                            'Masuk',
                            style: TextStyle(
                              fontSize: 13,
                              color: authPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
