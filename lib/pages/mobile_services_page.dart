import 'package:flutter/material.dart';

const Color mobilePrimary = Color(0xFF397E82);
const Color mobileLightCyan = Color(0xFFE5F7F7);
const Color mobilePageBackground = Color(0xFFF5F7FA);

enum MobileServiceSort {
  lowestPrice,
  highestPrice,
  mostSold,
  newest,
}

class MobileService {
  final String id;
  final String name;
  final String provider;
  final String location;
  final String description;
  final String serviceType;
  final int price;
  final double rating;
  final int reviewCount;
  final int soldCount;
  final DateTime createdAt;
  final IconData icon;
  final List<String> includes;
  final String responseTime;

  const MobileService({
    required this.id,
    required this.name,
    required this.provider,
    required this.location,
    required this.description,
    required this.serviceType,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.soldCount,
    required this.createdAt,
    required this.icon,
    required this.includes,
    required this.responseTime,
  });
}

final List<MobileService> sampleMobileServices = [
  MobileService(
    id: 'mob-001',
    name: 'Pembuatan Aplikasi Android',
    provider: 'PixelKita Studio',
    location: 'Medan',
    description: 'Aplikasi Android untuk operasional dan kebutuhan bisnis UMKM.',
    serviceType: 'Android',
    price: 2500000,
    rating: 4.9,
    reviewCount: 28,
    soldCount: 46,
    createdAt: DateTime(2026, 10, 20),
    icon: Icons.android_rounded,
    includes: ['Desain UI sederhana', 'Hingga 5 halaman aplikasi', 'Integrasi API dasar', 'Revisi 2 kali'],
    responseTime: 'Biasanya membalas dalam 1 jam',
  ),
  MobileService(
    id: 'mob-002',
    name: 'Aplikasi Kasir (POS) Mobile',
    provider: 'KodeMaju Creative',
    location: 'Medan',
    description: 'Aplikasi kasir sederhana untuk mencatat transaksi dan produk.',
    serviceType: 'Kasir / POS',
    price: 1800000,
    rating: 4.8,
    reviewCount: 19,
    soldCount: 63,
    createdAt: DateTime(2026, 9, 18),
    icon: Icons.point_of_sale_rounded,
    includes: ['Data produk dan kategori', 'Pencatatan transaksi', 'Laporan penjualan sederhana', 'Panduan penggunaan'],
    responseTime: 'Biasanya membalas dalam 2 jam',
  ),
  MobileService(
    id: 'mob-003',
    name: 'UI/UX Design Aplikasi Mobile',
    provider: 'RuangDesain Digital',
    location: 'Deli Serdang',
    description: 'Desain tampilan aplikasi mobile yang modern dan mudah digunakan.',
    serviceType: 'UI/UX Design',
    price: 950000,
    rating: 5.0,
    reviewCount: 12,
    soldCount: 31,
    createdAt: DateTime(2026, 11, 2),
    icon: Icons.design_services_rounded,
    includes: ['Riset kebutuhan singkat', 'Wireframe', 'Desain hingga 8 layar', 'File Figma'],
    responseTime: 'Biasanya membalas dalam 3 jam',
  ),
  MobileService(
    id: 'mob-004',
    name: 'Maintenance Aplikasi',
    provider: 'AppCare Nusantara',
    location: 'Medan',
    description: 'Perawatan, perbaikan bug, dan pembaruan aplikasi Android.',
    serviceType: 'Maintenance',
    price: 650000,
    rating: 4.7,
    reviewCount: 35,
    soldCount: 82,
    createdAt: DateTime(2026, 8, 12),
    icon: Icons.build_circle_outlined,
    includes: ['Pemeriksaan bug', 'Perbaikan error ringan', 'Pembaruan dependensi', 'Laporan hasil pekerjaan'],
    responseTime: 'Biasanya membalas dalam 4 jam',
  ),
  MobileService(
    id: 'mob-005',
    name: 'Publikasi Aplikasi ke Play Store',
    provider: 'DigiLaunch ID',
    location: 'Binjai',
    description: 'Bantuan persiapan aset dan publikasi aplikasi ke Google Play.',
    serviceType: 'Publikasi',
    price: 500000,
    rating: 4.9,
    reviewCount: 16,
    soldCount: 27,
    createdAt: DateTime(2026, 11, 7),
    icon: Icons.cloud_upload_outlined,
    includes: ['Pemeriksaan file aplikasi', 'Persiapan ikon dan screenshot', 'Bantuan pengisian listing', 'Pendampingan proses publikasi'],
    responseTime: 'Biasanya membalas dalam 2 jam',
  ),
  MobileService(
    id: 'mob-006',
    name: 'Aplikasi Pemesanan Online',
    provider: 'KaryaTek Mobile',
    location: 'Medan',
    description: 'Aplikasi pemesanan untuk produk makanan atau katalog UMKM.',
    serviceType: 'E-commerce',
    price: 3200000,
    rating: 4.8,
    reviewCount: 22,
    soldCount: 39,
    createdAt: DateTime(2026, 10, 29),
    icon: Icons.shopping_bag_outlined,
    includes: ['Katalog produk', 'Keranjang dan formulir pesanan', 'Halaman profil usaha', 'Notifikasi pesanan dasar'],
    responseTime: 'Biasanya membalas dalam 1 jam',
  ),
];

class MobileServicesPage extends StatefulWidget {
  const MobileServicesPage({super.key});

  @override
  State<MobileServicesPage> createState() => _MobileServicesPageState();
}

class _MobileServicesPageState extends State<MobileServicesPage> {
  MobileServiceSort _sort = MobileServiceSort.lowestPrice;
  String _searchQuery = '';

  List<MobileService> get _sortedServices {
    final query = _searchQuery.trim().toLowerCase();
    final items = sampleMobileServices.where((service) {
      if (query.isEmpty) return true;
      return service.name.toLowerCase().contains(query) ||
          service.provider.toLowerCase().contains(query) ||
          service.serviceType.toLowerCase().contains(query) ||
          service.description.toLowerCase().contains(query) ||
          service.location.toLowerCase().contains(query);
    }).toList();
    switch (_sort) {
      case MobileServiceSort.lowestPrice:
        items.sort((a, b) => a.price.compareTo(b.price));
        break;
      case MobileServiceSort.highestPrice:
        items.sort((a, b) => b.price.compareTo(a.price));
        break;
      case MobileServiceSort.mostSold:
        items.sort((a, b) => b.soldCount.compareTo(a.soldCount));
        break;
      case MobileServiceSort.newest:
        items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }
    return items;
  }

  String _sortLabel(MobileServiceSort value) {
    switch (value) {
      case MobileServiceSort.lowestPrice:
        return 'Harga terendah';
      case MobileServiceSort.highestPrice:
        return 'Harga tertinggi';
      case MobileServiceSort.mostSold:
        return 'Paling banyak terjual';
      case MobileServiceSort.newest:
        return 'Produk terbaru';
    }
  }

  String _formatPrice(int value) {
    final digits = value.toString();
    final result = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      result.write(digits[i]);
      final remaining = digits.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) result.write('.');
    }
    return 'Rp${result.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final services = _sortedServices;

    return Scaffold(
      backgroundColor: mobilePageBackground,
      appBar: AppBar(
        title: const Text('Layanan Mobile', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF202124),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Temukan jasa mobile untuk mengembangkan bisnis UMKM Anda.',
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const SizedBox(height: 14),
                TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Cari layanan, penyedia, atau kategori...',
                    hintStyle: const TextStyle(fontSize: 13, color: Colors.black45),
                    prefixIcon: const Icon(Icons.search_rounded, color: mobilePrimary),
                    suffixIcon: _searchQuery.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Hapus pencarian',
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => setState(() => _searchQuery = ''),
                          ),
                    filled: true,
                    fillColor: mobilePageBackground,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: mobileLightCyan),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: mobilePrimary, width: 1.4),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.sort_rounded, color: mobilePrimary),
                    const SizedBox(width: 8),
                    const Text('Urutkan', style: TextStyle(fontWeight: FontWeight.w600)),
                    const Spacer(),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<MobileServiceSort>(
                        value: _sort,
                        borderRadius: BorderRadius.circular(12),
                        items: MobileServiceSort.values.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(_sortLabel(value), style: const TextStyle(fontSize: 13)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) setState(() => _sort = value);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: services.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off_rounded, size: 46, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          const Text(
                            'Layanan tidak ditemukan',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Coba kata kunci lain atau hapus pencarian.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: services.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final service = services[index];
                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MobileServiceDetailPage(service: service),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              color: mobileLightCyan,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(service.icon, color: mobilePrimary, size: 29),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(service.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 5),
                                Text(service.description, maxLines: 2, overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.35)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.storefront_outlined, size: 14, color: Colors.black45),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(service.provider, maxLines: 1, overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 11, color: Colors.black54)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, size: 15, color: Color(0xFFFFB300)),
                                    const SizedBox(width: 3),
                                    Text('${service.rating.toStringAsFixed(1)} (${service.reviewCount})',
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                    const SizedBox(width: 10),
                                    const Icon(Icons.shopping_bag_outlined, size: 13, color: Colors.black45),
                                    const SizedBox(width: 3),
                                    Text('${service.soldCount} terjual',
                                        style: const TextStyle(fontSize: 11, color: Colors.black54)),
                                  ],
                                ),
                                const SizedBox(height: 9),
                                Text(_formatPrice(service.price),
                                    style: const TextStyle(fontSize: 15, color: mobilePrimary, fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_right_rounded, color: Colors.black38),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MobileServiceDetailPage extends StatelessWidget {
  final MobileService service;

  const MobileServiceDetailPage({super.key, required this.service});

  String _formatPrice(int value) {
    final digits = value.toString();
    final result = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      result.write(digits[i]);
      final remaining = digits.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) result.write('.');
    }
    return 'Rp${result.toString()}';
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('$feature akan tersedia pada tahap berikutnya.'),
        behavior: SnackBarBehavior.floating,
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobilePageBackground,
      appBar: AppBar(
        title: const Text('Detail Layanan'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF202124),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFEAEAEA))),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showComingSoon(context, 'Chat penjual'),
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Chat'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: mobilePrimary,
                    side: const BorderSide(color: mobilePrimary),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => _showComingSoon(context, 'Pemesanan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mobilePrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: const Text('Pesan Layanan'),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: mobileLightCyan,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(service.icon, color: mobilePrimary, size: 70),
                ),
                const SizedBox(height: 18),
                Text(service.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Text(_formatPrice(service.price),
                    style: const TextStyle(fontSize: 22, color: mobilePrimary, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 18),
                    const SizedBox(width: 4),
                    Text('${service.rating.toStringAsFixed(1)} · ${service.reviewCount} ulasan',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 14),
                    const Icon(Icons.shopping_bag_outlined, size: 15, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text('${service.soldCount} terjual', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _DetailSection(
            title: 'Penyedia layanan',
            child: Row(
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundColor: mobileLightCyan,
                  child: Text(service.provider.isNotEmpty ? service.provider[0].toUpperCase() : 'P',
                      style: const TextStyle(color: mobilePrimary, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(service.provider, style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: Colors.black45),
                          const SizedBox(width: 3),
                          Text(service.location, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(service.responseTime, style: const TextStyle(fontSize: 11, color: Colors.black54)),
                    ],
                  ),
                ),
                const Icon(Icons.verified_outlined, color: mobilePrimary),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _DetailSection(
            title: 'Deskripsi layanan',
            child: Text(service.description, style: const TextStyle(height: 1.5, color: Colors.black87)),
          ),
          const SizedBox(height: 10),
          _DetailSection(
            title: 'Jasa yang didapat',
            child: Column(
              children: service.includes.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_outline, color: mobilePrimary, size: 18),
                    const SizedBox(width: 9),
                    Expanded(child: Text(item, style: const TextStyle(fontSize: 13))),
                  ],
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 10),
          _DetailSection(
            title: 'Informasi layanan',
            child: Column(
              children: [
                _InfoRow(label: 'Kategori', value: service.serviceType),
                _InfoRow(label: 'Lokasi penyedia', value: service.location),
                _InfoRow(label: 'Jumlah terjual', value: '${service.soldCount} layanan'),
                _InfoRow(label: 'Ditambahkan', value: '${service.createdAt.day}/${service.createdAt.month}/${service.createdAt.year}'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _DetailSection(
            title: 'Ulasan pembeli',
            child: const Text(
              'Bagian review akan ditambahkan pada tahap berikutnya.',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _DetailSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12))),
          const SizedBox(width: 12),
          Expanded(
            child: Text(value, textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
