
import 'package:flutter/material.dart';

import '../services/notification_service.dart';
import 'welcome_page.dart';
import '../services/auth_service.dart';

const Color primaryColor = Color(0xFF5CC8CC);
const Color lightColor = Color(0xFFEAF8F8);
const Color textColor = Color(0xFF333333);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool notificationEnabled = true;

  // Menampilkan dialog informasi
  void showMenuDialog(String title, String description) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Tutup',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  // Edit profil
  void editProfile() {
    showMenuDialog(
      'Edit Profil',
      'Ubah nama, email, foto profil, dan informasi akun pengguna.',
    );
  }

  // Banner profil menggunakan Stack
  Widget profileBanner() {
    return Container(
      height: 115,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF55C5C9),
            Color(0xFF91DDDF),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              // Foto profil
              Container(
                width: 68,
                height: 68,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: primaryColor,
                  size: 43,
                ),
              ),

              const SizedBox(width: 14),

              // Informasi pengguna
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Devin Gunawan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'dummy@gmail.com',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Pengolah Bantuan Bisnis',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Tombol edit di kanan banner
          Positioned(
            right: 0,
            top: 30,
            child: IconButton(
              onPressed: editProfile,
              tooltip: 'Edit Profil',
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 21,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Judul kategori menu
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        bottom: 10,
        top: 20,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF777777),
        ),
      ),
    );
  }

  // Widget setiap menu
  Widget menuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.white,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
            ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: lightColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 21,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                )
              : null,
          trailing: trailing ??
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF777777),
              ),
            onTap: onTap,
          ),
        ),

        if (showDivider)
          const Padding(
            padding: EdgeInsets.only(
              left: 68,
              right: 14,
            ),
            child: Divider(
              height: 1,
              color: Color(0xFFE0E0E0),
            ),
          ),
      ],
    );
  }

  // Container daftar menu
  Widget menuContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFEEEEEE),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // Bagian Akun Saya
  Widget settingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle('Akun Saya'),

        menuContainer([
          // 1. Informasi Usaha
          menuItem(
            icon: Icons.storefront_outlined,
            title: 'Informasi Usaha',
            subtitle: 'Usaha Maju Jaya',
            onTap: () {
              showMenuDialog(
                'Informasi Usaha',
                'Kelola informasi usaha, kategori bisnis, '
                    'deskripsi, alamat, dan informasi UMKM.',
              );
            },
          ),

          // 2. Bahasa dan Zona Waktu
          menuItem(
            icon: Icons.language_outlined,
            title: 'Bahasa dan Zona Waktu',
            subtitle: 'Atur bahasa dan zona waktu',
            onTap: () {
              showMenuDialog(
                'Bahasa dan Zona Waktu',
                'Atur bahasa aplikasi dan zona waktu '
                    'yang digunakan oleh MikroHub.',
              );
            },
          ),

          // 3. Notifikasi
          menuItem(
            icon: Icons.notifications_none,
            title: 'Notifikasi',
            subtitle: 'Atur pemberitahuan aplikasi',
            onTap: () {
              showMenuDialog(
                'Notifikasi',
                'Atur preferensi notifikasi MikroHub.',
              );
            },
          ),

          // 4. Pengaturan
          menuItem(
            icon: Icons.settings_outlined,
            title: 'Pengaturan',
            subtitle: 'Keamanan, sandi, dan preferensi',
            showDivider: false,
            onTap: () {
              showMenuDialog(
                'Pengaturan',
                'Atur preferensi dan konfigurasi '
                    'aplikasi MikroHub.',
              );
            },
          ),
        ]),
      ],
    );
  }

  // Bagian Help
  Widget helpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle('Bantuan'),

        menuContainer([
          // 1. Pusat Bantuan
          menuItem(
            icon: Icons.help_outline,
            title: 'Pusat Bantuan',
            onTap: () {
              showMenuDialog(
                'Pusat Bantuan',
                'Temukan panduan penggunaan MikroHub, '
                    'pertanyaan umum, dan bantuan '
                    'untuk menghubungi tim support.',
              );
            },
          ),

          // 2. Tentang MikroHub
          menuItem(
            icon: Icons.info_outline,
            title: 'Tentang MikroHub',
            showDivider: false,
            onTap: () {
              showMenuDialog(
                'Tentang MikroHub',
                'MikroHub UMKM merupakan platform yang '
                    'mempertemukan pelaku UMKM dengan '
                    'Developer App, pengolah bantuan bisnis, '
                    'dan penyedia solusi digital lainnya.\n\n'
                    'Versi aplikasi: 1.0.0',
              );
            },
          ),
        ]),
      ],
    );
  }

  // Tombol keluar
  Widget logoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Keluar'),
              content: const Text(
                'Apakah Anda yakin ingin keluar dari akun?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    // Tutup dialog
                    Navigator.pop(context);

                    // Notifikasi logout berhasil
                    AuthService.instance.logout();
                    NotificationService.instance.showLogout();

                    // Kembali ke halaman awal & hapus semua halaman sebelumnya
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const WelcomePage(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Keluar',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        icon: const Icon(
          Icons.logout,
          size: 18,
        ),
        label: const Text(
          'Keluar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.redAccent,
          side: const BorderSide(
            color: Colors.redAccent,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Stack(
          children: [
            // Konten utama halaman profil
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                18,
                12,
                18,
                25,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul halaman
                  const Text(
                    'Profil',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Banner profil
                  profileBanner(),

                  // Akun Saya
                  settingsSection(),

                  // Help
                  helpSection(),

                  const SizedBox(height: 25),

                  // Tombol keluar
                  logoutButton(),

                  const SizedBox(height: 15),

                  // Versi aplikasi
                  const Center(
                    child: Text(
                      'MikroHub v1.0.0',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
