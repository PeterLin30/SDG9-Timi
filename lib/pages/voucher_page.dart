import 'package:flutter/material.dart';
import 'package:idn_finlogos/idn_finlogos.dart';
import 'package:flutter_svg/flutter_svg.dart';

const Color primaryColor = Color(0xFF5CC8CC);
const Color lightCyan = Color(0xFFC8F1F3);
const Color darkTeal = Color(0xFF397E82);
const Color textColor = Color(0xFF202124);

// =====================================================
// DATA VOUCHER
// =====================================================

class VoucherPage extends StatelessWidget {
  const VoucherPage({super.key});

  static const List<Map<String, String>> vouchers = [
    {
      'title': 'Promo OVO',
      'sponsor': 'OVO',
      'logo': 'ovo',
      'discount': '20%',
      'description': 'Diskon khusus pembayaran menggunakan OVO.',
      'usage': 'Gunakan OVO sebagai metode pembayaran.',
      'terms': 'Minimal transaksi Rp50.000.\nPembayaran wajib menggunakan OVO.',
      'validity': '31 Desember 2026',
    },
    {
      'title': 'Promo GoPay',
      'sponsor': 'GoPay',
      'logo': 'gopay',
      'discount': '15%',
      'description': 'Promo pembayaran menggunakan GoPay.',
      'usage': 'Gunakan GoPay untuk mendapatkan potongan harga.',
      'terms':
          'Minimal transaksi Rp30.000.\nPembayaran wajib menggunakan GoPay.',
      'validity': '31 Desember 2026',
    },
    {
      'title': 'Promo DANA',
      'sponsor': 'DANA',
      'logo': 'dana',
      'discount': '10%',
      'description': 'Diskon khusus transaksi menggunakan DANA.',
      'usage': 'Gunakan DANA sebagai metode pembayaran.',
      'terms':
          'Minimal transaksi Rp25.000.\nPembayaran wajib menggunakan DANA.',
      'validity': '30 November 2026',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Voucher Coupon',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [lightCyan, Color(0xFFE9FAFB)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.redeem_rounded, size: 44, color: darkTeal),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Voucher untuk Bisnismu!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Nikmati berbagai penawaran menarik dari partner MikroHub.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // TITLE
            const Text(
              'Voucher Tersedia',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              '${vouchers.length} voucher tersedia untuk kamu',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),

            const SizedBox(height: 16),

            // LIST VOUCHER
            Column(
              children: vouchers.map((voucher) {
                return _buildVoucherCard(context, voucher);
              }).toList(),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // VOUCHER CARD
  // =====================================================

  Widget _buildVoucherCard(BuildContext context, Map<String, String> voucher) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // ROW LOGO DAN INFORMASI
          Row(
            children: [
              _buildSponsorLogo(voucher['logo']!, size: 60),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      voucher['sponsor']!,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      voucher['title']!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'Diskon ${voucher['discount']}',
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: darkTeal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // MASA BERLAKU
          Row(
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                size: 16,
                color: Colors.grey,
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  'Berlaku hingga ${voucher['validity']}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          // DETAIL BUTTON
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VoucherDetailPage(voucher: voucher),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: darkTeal,
                side: const BorderSide(color: primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 11),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Detail Voucher',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// SPONSOR LOGO DARI PACKAGE PUB.DEV
// =====================================================

Widget _buildSponsorLogo(String logoSlug, {double size = 60}) {
  final logo = IdnFinLogos.get(logoSlug);

  return Container(
    width: size,
    height: size,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: logo == null
        ? const Icon(Icons.image_not_supported_outlined, color: Colors.grey)
        : SvgPicture.asset(
            logo.assetPath,
            fit: BoxFit.contain,
            semanticsLabel: logo.name,
          ),
  );
}

// =====================================================
// VOUCHER DETAIL PAGE
// =====================================================

class VoucherDetailPage extends StatelessWidget {
  final Map<String, String> voucher;

  const VoucherDetailPage({super.key, required this.voucher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text(
          'Detail Voucher',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER SPONSOR
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [lightCyan, Color(0xFFE9FAFB)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildSponsorLogo(voucher['logo']!, size: 85),

                  const SizedBox(height: 13),

                  Text(
                    voucher['sponsor']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Diskon ${voucher['discount']}',
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: darkTeal,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    voucher['description']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: textColor),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // DESKRIPSI
            _buildDetailSection(
              title: 'Deskripsi Voucher',
              icon: Icons.description_outlined,
              content: voucher['description']!,
            ),

            const SizedBox(height: 18),

            // KEGUNAAN
            _buildDetailSection(
              title: 'Kegunaan Voucher',
              icon: Icons.card_giftcard_rounded,
              content: voucher['usage']!,
            ),

            const SizedBox(height: 18),

            // SYARAT DAN KETENTUAN
            _buildDetailSection(
              title: 'Syarat & Ketentuan',
              icon: Icons.fact_check_outlined,
              content: voucher['terms']!,
            ),

            const SizedBox(height: 18),

            // MASA BERLAKU
            _buildDetailSection(
              title: 'Masa Berlaku',
              icon: Icons.calendar_month_rounded,
              content: 'Voucher berlaku hingga ${voucher['validity']}.',
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // DETAIL SECTION
  // =====================================================

  Widget _buildDetailSection({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: darkTeal, size: 20),

            const SizedBox(width: 8),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            content,
            style: const TextStyle(fontSize: 13, height: 1.7, color: textColor),
          ),
        ),
      ],
    );
  }
}
