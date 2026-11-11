import 'package:flutter/material.dart';

const Color _primary = Color(0xFF397E82);
const Color _light = Color(0xFFE5F7F7);
const Color _background = Color(0xFFF5F7FA);

enum _CategorySort { lowestPrice, highestPrice, mostSold, newest }

class _CategoryService {
  final String name;
  final String provider;
  final String location;
  final String description;
  final String type;
  final int price;
  final double rating;
  final int reviews;
  final int sold;
  final DateTime createdAt;
  final IconData icon;
  final List<String> includes;
  final String responseTime;

  const _CategoryService({
    required this.name,
    required this.provider,
    required this.location,
    required this.description,
    required this.type,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.sold,
    required this.createdAt,
    required this.icon,
    required this.includes,
    required this.responseTime,
  });
}

// Data contoh untuk prototype. Nantinya dapat diganti dengan data dari API/database.
final Map<String, List<_CategoryService>> _categoryData = {
  'Web': [
    _CategoryService(name: 'Website Company Profile', provider: 'WebKita Studio', location: 'Medan', description: 'Website profil usaha yang profesional dan responsif.', type: 'Company Profile', price: 1200000, rating: 4.9, reviews: 24, sold: 58, createdAt: DateTime(2026, 11, 4), icon: Icons.language, includes: ['Hingga 5 halaman website', 'Desain responsif', 'Formulir kontak', 'Panduan pengelolaan'], responseTime: 'Biasanya membalas dalam 1 jam'),
    _CategoryService(name: 'Toko Online UMKM', provider: 'PixelWeb Indonesia', location: 'Medan', description: 'Website katalog dan toko online untuk menjual produk.', type: 'E-commerce', price: 2500000, rating: 4.8, reviews: 31, sold: 42, createdAt: DateTime(2026, 10, 28), icon: Icons.shopping_cart_outlined, includes: ['Katalog produk', 'Keranjang belanja', 'Formulir pesanan', 'Pengelolaan produk'], responseTime: 'Biasanya membalas dalam 2 jam'),
    _CategoryService(name: 'Landing Page Promosi', provider: 'KlikDigital', location: 'Binjai', description: 'Halaman promosi untuk kampanye produk atau layanan.', type: 'Landing Page', price: 650000, rating: 4.7, reviews: 18, sold: 76, createdAt: DateTime(2026, 11, 7), icon: Icons.web, includes: ['Satu halaman promosi', 'Tombol WhatsApp', 'Optimasi tampilan mobile', 'Formulir calon pelanggan'], responseTime: 'Biasanya membalas dalam 3 jam'),
    _CategoryService(name: 'Website Booking dan Reservasi', provider: 'KodeMaju Creative', location: 'Deli Serdang', description: 'Sistem pemesanan jadwal untuk jasa, salon, atau konsultasi.', type: 'Booking System', price: 3200000, rating: 4.9, reviews: 14, sold: 21, createdAt: DateTime(2026, 10, 19), icon: Icons.event_available_outlined, includes: ['Formulir reservasi', 'Kalender jadwal', 'Notifikasi pesanan dasar', 'Panel admin'], responseTime: 'Biasanya membalas dalam 2 jam'),
    _CategoryService(name: 'Perbaikan dan Maintenance Website', provider: 'WebCare Nusantara', location: 'Medan', description: 'Pemeriksaan error, pembaruan, dan perawatan website.', type: 'Maintenance', price: 450000, rating: 4.8, reviews: 39, sold: 91, createdAt: DateTime(2026, 9, 12), icon: Icons.build_outlined, includes: ['Pemeriksaan error', 'Pembaruan plugin', 'Backup dasar', 'Laporan pekerjaan'], responseTime: 'Biasanya membalas dalam 4 jam'),
  ],
  'Cyber': [
    _CategoryService(name: 'Audit Keamanan Website', provider: 'SecureByte ID', location: 'Medan', description: 'Pemeriksaan konfigurasi dan celah keamanan website.', type: 'Security Audit', price: 900000, rating: 4.9, reviews: 20, sold: 37, createdAt: DateTime(2026, 11, 5), icon: Icons.security, includes: ['Pemeriksaan konfigurasi', 'Pemindaian kerentanan dasar', 'Daftar temuan', 'Rekomendasi perbaikan'], responseTime: 'Biasanya membalas dalam 2 jam'),
    _CategoryService(name: 'Setup SSL dan HTTPS', provider: 'NetShield Solution', location: 'Medan', description: 'Pemasangan sertifikat SSL dan pengalihan ke HTTPS.', type: 'SSL Setup', price: 250000, rating: 4.8, reviews: 16, sold: 84, createdAt: DateTime(2026, 11, 2), icon: Icons.https, includes: ['Pemasangan SSL', 'Konfigurasi HTTPS', 'Pemeriksaan mixed content', 'Tes akses website'], responseTime: 'Biasanya membalas dalam 1 jam'),
    _CategoryService(name: 'Backup dan Pemulihan Data', provider: 'DataAman Teknologi', location: 'Binjai', description: 'Pembuatan backup dan bantuan pemulihan data website.', type: 'Data Backup', price: 500000, rating: 4.7, reviews: 22, sold: 49, createdAt: DateTime(2026, 10, 25), icon: Icons.backup_outlined, includes: ['Backup file dan database', 'Penyimpanan salinan', 'Pemeriksaan hasil backup', 'Panduan pemulihan'], responseTime: 'Biasanya membalas dalam 3 jam'),
    _CategoryService(name: 'Security Awareness UMKM', provider: 'CyberCerdas', location: 'Deli Serdang', description: 'Edukasi keamanan akun, kata sandi, dan phishing untuk tim.', type: 'Security Training', price: 350000, rating: 5.0, reviews: 11, sold: 29, createdAt: DateTime(2026, 11, 8), icon: Icons.phonelink_lock, includes: ['Materi keamanan dasar', 'Simulasi contoh phishing', 'Checklist keamanan akun', 'Sesi tanya jawab'], responseTime: 'Biasanya membalas dalam 5 jam'),
    _CategoryService(name: 'Konfigurasi Firewall Dasar', provider: 'FirewallPro', location: 'Medan', description: 'Pengaturan perlindungan dasar untuk server dan jaringan usaha.', type: 'Network Security', price: 1100000, rating: 4.8, reviews: 17, sold: 18, createdAt: DateTime(2026, 10, 15), icon: Icons.shield_outlined, includes: ['Pemeriksaan kebutuhan', 'Aturan firewall dasar', 'Pengujian koneksi', 'Dokumentasi konfigurasi'], responseTime: 'Biasanya membalas dalam 4 jam'),
  ],
  'Graphic': [
    _CategoryService(name: 'Desain Logo UMKM', provider: 'RuangDesain Digital', location: 'Medan', description: 'Logo usaha yang unik dan mudah dikenali pelanggan.', type: 'Logo Design', price: 300000, rating: 5.0, reviews: 42, sold: 105, createdAt: DateTime(2026, 11, 6), icon: Icons.draw_outlined, includes: ['2 konsep awal', '2 kali revisi', 'File PNG dan JPG', 'File logo transparan'], responseTime: 'Biasanya membalas dalam 1 jam'),
    _CategoryService(name: 'Desain Feed Instagram', provider: 'KreasiVisual', location: 'Binjai', description: 'Desain konten media sosial yang konsisten dengan brand.', type: 'Social Media Design', price: 200000, rating: 4.8, reviews: 29, sold: 88, createdAt: DateTime(2026, 11, 7), icon: Icons.grid_view, includes: ['6 desain feed', 'Template warna brand', 'File siap unggah', '1 kali revisi'], responseTime: 'Biasanya membalas dalam 2 jam'),
    _CategoryService(name: 'Desain Banner dan Spanduk', provider: 'CetakKreatif Studio', location: 'Medan', description: 'Materi visual promosi untuk toko, acara, dan produk.', type: 'Banner Design', price: 150000, rating: 4.7, reviews: 19, sold: 64, createdAt: DateTime(2026, 10, 30), icon: Icons.panorama_outlined, includes: ['1 desain banner', 'Ukuran sesuai permintaan', 'File resolusi tinggi', 'File siap cetak'], responseTime: 'Biasanya membalas dalam 3 jam'),
    _CategoryService(name: 'Desain Kemasan Produk', provider: 'BungkusBrand', location: 'Deli Serdang', description: 'Desain label dan kemasan untuk meningkatkan daya tarik produk.', type: 'Packaging Design', price: 550000, rating: 4.9, reviews: 15, sold: 33, createdAt: DateTime(2026, 10, 22), icon: Icons.inventory_2_outlined, includes: ['Konsep desain kemasan', 'Desain label', 'Mockup produk', 'File siap cetak'], responseTime: 'Biasanya membalas dalam 3 jam'),
    _CategoryService(name: 'Desain Company Profile', provider: 'VisualWorks ID', location: 'Medan', description: 'Dokumen profil usaha yang rapi untuk calon mitra dan pelanggan.', type: 'Company Profile Design', price: 750000, rating: 4.8, reviews: 21, sold: 26, createdAt: DateTime(2026, 9, 29), icon: Icons.menu_book_outlined, includes: ['Desain hingga 10 halaman', 'Tata letak profesional', 'File PDF', '2 kali revisi'], responseTime: 'Biasanya membalas dalam 5 jam'),
  ],
  'Digital': [
    _CategoryService(name: 'Paket Kelola Instagram', provider: 'SosialMaju', location: 'Medan', description: 'Pengelolaan konten Instagram untuk membantu promosi usaha.', type: 'Social Media Management', price: 850000, rating: 4.9, reviews: 34, sold: 61, createdAt: DateTime(2026, 11, 4), icon: Icons.camera_alt_outlined, includes: ['12 konten per bulan', 'Caption dan hashtag', 'Kalender konten', 'Laporan performa dasar'], responseTime: 'Biasanya membalas dalam 1 jam'),
    _CategoryService(name: 'Optimasi SEO Website', provider: 'RankUp Digital', location: 'Medan', description: 'Optimasi dasar agar website lebih mudah ditemukan di mesin pencari.', type: 'SEO', price: 950000, rating: 4.8, reviews: 27, sold: 45, createdAt: DateTime(2026, 10, 27), icon: Icons.search, includes: ['Audit SEO dasar', 'Riset kata kunci', 'Optimasi meta title dan description', 'Rekomendasi konten'], responseTime: 'Biasanya membalas dalam 2 jam'),
    _CategoryService(name: 'Iklan Digital Meta Ads', provider: 'IklanPintar', location: 'Binjai', description: 'Bantuan menyiapkan dan mengelola kampanye iklan Facebook dan Instagram.', type: 'Paid Ads', price: 700000, rating: 4.7, reviews: 18, sold: 39, createdAt: DateTime(2026, 11, 8), icon: Icons.campaign_outlined, includes: ['Riset target audiens', 'Setup satu kampanye', 'Pembuatan materi iklan dasar', 'Laporan hasil awal'], responseTime: 'Biasanya membalas dalam 2 jam'),
    _CategoryService(name: 'Foto Produk untuk Marketplace', provider: 'FotoProduk Studio', location: 'Deli Serdang', description: 'Foto produk sederhana untuk katalog dan marketplace.', type: 'Product Photography', price: 400000, rating: 4.9, reviews: 23, sold: 52, createdAt: DateTime(2026, 10, 18), icon: Icons.photo_camera_outlined, includes: ['Hingga 10 foto produk', 'Pencahayaan studio sederhana', 'Edit warna dasar', 'File digital resolusi tinggi'], responseTime: 'Biasanya membalas dalam 4 jam'),
    _CategoryService(name: 'Pembuatan Konten Promosi', provider: 'KontenKita', location: 'Medan', description: 'Pembuatan materi konten promosi untuk media sosial bisnis.', type: 'Content Creation', price: 500000, rating: 4.8, reviews: 16, sold: 47, createdAt: DateTime(2026, 10, 31), icon: Icons.video_library_outlined, includes: ['4 konten promosi', 'Naskah singkat', 'Desain atau video pendek', 'File siap unggah'], responseTime: 'Biasanya membalas dalam 3 jam'),
  ],
  'Bisnis': [
    _CategoryService(name: 'Konsultasi Pengembangan UMKM', provider: 'TumbuhBisnis', location: 'Medan', description: 'Diskusi strategi pengembangan usaha berdasarkan kebutuhan bisnis.', type: 'Business Consulting', price: 300000, rating: 5.0, reviews: 26, sold: 41, createdAt: DateTime(2026, 11, 5), icon: Icons.business_center_outlined, includes: ['Sesi konsultasi 60 menit', 'Analisis tantangan usaha', 'Rekomendasi strategi', 'Ringkasan hasil diskusi'], responseTime: 'Biasanya membalas dalam 1 jam'),
    _CategoryService(name: 'Penyusunan Business Plan', provider: 'RencanaMaju', location: 'Medan', description: 'Dokumen rencana bisnis untuk pengembangan atau pengajuan pendanaan.', type: 'Business Plan', price: 1200000, rating: 4.9, reviews: 18, sold: 23, createdAt: DateTime(2026, 10, 24), icon: Icons.assignment_outlined, includes: ['Analisis model bisnis', 'Target pasar', 'Proyeksi keuangan dasar', 'Dokumen business plan'], responseTime: 'Biasanya membalas dalam 3 jam'),
    _CategoryService(name: 'Pendampingan Branding UMKM', provider: 'BrandTeman', location: 'Binjai', description: 'Pendampingan menentukan identitas dan positioning merek.', type: 'Brand Strategy', price: 650000, rating: 4.8, reviews: 21, sold: 35, createdAt: DateTime(2026, 11, 1), icon: Icons.storefront_outlined, includes: ['Diskusi karakter brand', 'Penentuan target pelanggan', 'Arahan identitas merek', 'Panduan komunikasi brand'], responseTime: 'Biasanya membalas dalam 2 jam'),
    _CategoryService(name: 'Analisis Keuangan Usaha', provider: 'FinBisnis Konsultan', location: 'Deli Serdang', description: 'Pemeriksaan sederhana arus kas, biaya, dan keuntungan usaha.', type: 'Financial Review', price: 500000, rating: 4.7, reviews: 14, sold: 28, createdAt: DateTime(2026, 10, 20), icon: Icons.account_balance_wallet_outlined, includes: ['Review catatan keuangan', 'Analisis arus kas', 'Identifikasi biaya utama', 'Saran pengelolaan keuangan'], responseTime: 'Biasanya membalas dalam 4 jam'),
    _CategoryService(name: 'Konsultasi Strategi Penjualan', provider: 'SalesGrow ID', location: 'Medan', description: 'Membantu menyusun strategi penjualan dan pelayanan pelanggan.', type: 'Sales Strategy', price: 400000, rating: 4.9, reviews: 17, sold: 32, createdAt: DateTime(2026, 10, 26), icon: Icons.trending_up, includes: ['Evaluasi proses penjualan', 'Identifikasi peluang pasar', 'Strategi peningkatan konversi', 'Rencana tindak lanjut'], responseTime: 'Biasanya membalas dalam 2 jam'),
  ],
};

class CategoryServicesPage extends StatefulWidget {
  final String category;
  const CategoryServicesPage({super.key, required this.category});

  @override
  State<CategoryServicesPage> createState() => _CategoryServicesPageState();
}

class _CategoryServicesPageState extends State<CategoryServicesPage> {
  _CategorySort _sort = _CategorySort.lowestPrice;
  String _searchQuery = '';

  List<_CategoryService> get _services {
    final query = _searchQuery.trim().toLowerCase();
    final items = [...?_categoryData[widget.category]].where((service) {
      if (query.isEmpty) return true;
      return service.name.toLowerCase().contains(query) ||
          service.provider.toLowerCase().contains(query) ||
          service.type.toLowerCase().contains(query) ||
          service.description.toLowerCase().contains(query) ||
          service.location.toLowerCase().contains(query);
    }).toList();
    switch (_sort) {
      case _CategorySort.lowestPrice:
        items.sort((a, b) => a.price.compareTo(b.price));
        break;
      case _CategorySort.highestPrice:
        items.sort((a, b) => b.price.compareTo(a.price));
        break;
      case _CategorySort.mostSold:
        items.sort((a, b) => b.sold.compareTo(a.sold));
        break;
      case _CategorySort.newest:
        items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }
    return items;
  }

  String _sortLabel(_CategorySort sort) {
    switch (sort) {
      case _CategorySort.lowestPrice: return 'Harga terendah';
      case _CategorySort.highestPrice: return 'Harga tertinggi';
      case _CategorySort.mostSold: return 'Paling banyak terjual';
      case _CategorySort.newest: return 'Produk terbaru';
    }
  }

  String _price(int value) {
    final s = value.toString();
    final out = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      out.write(s[i]);
      final remaining = s.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) out.write('.');
    }
    return 'Rp${out.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final items = _services;
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: Text('Layanan ${widget.category}', style: const TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF202124),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Pilih jasa ${widget.category} yang sesuai dengan kebutuhan bisnismu.', style: const TextStyle(color: Colors.black54, fontSize: 13)),
            const SizedBox(height: 12),
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Cari layanan, penyedia, atau kategori...',
                hintStyle: const TextStyle(fontSize: 13, color: Colors.black45),
                prefixIcon: const Icon(Icons.search_rounded, color: _primary),
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Hapus pencarian',
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => setState(() => _searchQuery = ''),
                      ),
                filled: true,
                fillColor: _background,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _light),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _primary, width: 1.4),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(children: [
              const Icon(Icons.sort_rounded, color: _primary),
              const SizedBox(width: 8),
              const Text('Urutkan', style: TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              DropdownButtonHideUnderline(child: DropdownButton<_CategorySort>(
                value: _sort,
                items: _CategorySort.values.map((v) => DropdownMenuItem(value: v, child: Text(_sortLabel(v), style: const TextStyle(fontSize: 13)))).toList(),
                onChanged: (v) { if (v != null) setState(() => _sort = v); },
              )),
            ]),
          ]),
        ),
        Expanded(child: items.isEmpty
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
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _CategoryServiceDetailPage(category: widget.category, service: item))),
                    child: Padding(padding: const EdgeInsets.all(14), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(width: 58, height: 58, decoration: BoxDecoration(color: _light, borderRadius: BorderRadius.circular(12)), child: Icon(item.icon, color: _primary, size: 29)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(item.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 5),
                        Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.35)),
                        const SizedBox(height: 8),
                        Row(children: [const Icon(Icons.storefront_outlined, size: 14, color: Colors.black45), const SizedBox(width: 4), Expanded(child: Text(item.provider, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Colors.black54)))]),
                        const SizedBox(height: 6),
                        Row(children: [const Icon(Icons.star_rounded, size: 15, color: Color(0xFFFFB300)), const SizedBox(width: 3), Text('${item.rating.toStringAsFixed(1)} (${item.reviews})', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)), const SizedBox(width: 10), const Icon(Icons.shopping_bag_outlined, size: 13, color: Colors.black45), const SizedBox(width: 3), Text('${item.sold} terjual', style: const TextStyle(fontSize: 11, color: Colors.black54))]),
                        const SizedBox(height: 9),
                        Text(_price(item.price), style: const TextStyle(fontSize: 15, color: _primary, fontWeight: FontWeight.w800)),
                      ])),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right_rounded, color: Colors.black38),
                    ])),
                  ),
                );
              },
            )),
      ]),
    );
  }
}

class _CategoryServiceDetailPage extends StatelessWidget {
  final String category;
  final _CategoryService service;
  const _CategoryServiceDetailPage({required this.category, required this.service});

  String _price(int value) {
    final s = value.toString();
    final out = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      out.write(s[i]);
      final remaining = s.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) out.write('.');
    }
    return 'Rp${out.toString()}';
  }

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text('$feature akan tersedia pada tahap berikutnya.'), behavior: SnackBarBehavior.floating));
  }

  Widget _section(String title, Widget child) => Container(width: double.infinity, color: Colors.white, padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)), const SizedBox(height: 14), child]));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(title: Text('Detail $category'), backgroundColor: Colors.white, foregroundColor: const Color(0xFF202124), surfaceTintColor: Colors.transparent, elevation: 0),
      bottomNavigationBar: SafeArea(child: Container(padding: const EdgeInsets.fromLTRB(16, 12, 16, 12), decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFEAEAEA))),), child: Row(children: [
        Expanded(child: OutlinedButton.icon(onPressed: () => _comingSoon(context, 'Chat penyedia'), icon: const Icon(Icons.chat_bubble_outline), label: const Text('Chat'), style: OutlinedButton.styleFrom(foregroundColor: _primary, side: const BorderSide(color: _primary), padding: const EdgeInsets.symmetric(vertical: 13)))),
        const SizedBox(width: 10),
        Expanded(flex: 2, child: ElevatedButton(onPressed: () => _comingSoon(context, 'Pemesanan'), style: ElevatedButton.styleFrom(backgroundColor: _primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 13)), child: const Text('Pesan Layanan'))),
      ]))),
      body: ListView(padding: const EdgeInsets.only(bottom: 20), children: [
        Container(color: Colors.white, padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(height: 150, width: double.infinity, decoration: BoxDecoration(color: _light, borderRadius: BorderRadius.circular(14)), child: Icon(service.icon, color: _primary, size: 70)),
          const SizedBox(height: 18),
          Text(service.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Text(_price(service.price), style: const TextStyle(fontSize: 22, color: _primary, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Row(children: [const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 18), const SizedBox(width: 4), Text('${service.rating.toStringAsFixed(1)} · ${service.reviews} ulasan', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)), const SizedBox(width: 14), const Icon(Icons.shopping_bag_outlined, size: 15, color: Colors.black54), const SizedBox(width: 4), Text('${service.sold} terjual', style: const TextStyle(fontSize: 12, color: Colors.black54))]),
        ])),
        const SizedBox(height: 10),
        _section('Penyedia layanan', Row(children: [CircleAvatar(radius: 23, backgroundColor: _light, child: Text(service.provider.isNotEmpty ? service.provider[0].toUpperCase() : 'P', style: const TextStyle(color: _primary, fontWeight: FontWeight.bold))), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(service.provider, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 4), Row(children: [const Icon(Icons.location_on_outlined, size: 14, color: Colors.black45), const SizedBox(width: 3), Text(service.location, style: const TextStyle(fontSize: 12, color: Colors.black54))]), const SizedBox(height: 4), Text(service.responseTime, style: const TextStyle(fontSize: 11, color: Colors.black54))])), const Icon(Icons.verified_outlined, color: _primary)])),
        const SizedBox(height: 10),
        _section('Deskripsi layanan', Text(service.description, style: const TextStyle(height: 1.5, color: Colors.black87))),
        const SizedBox(height: 10),
        _section('Jasa yang didapat', Column(children: service.includes.map((v) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.check_circle_outline, color: _primary, size: 18), const SizedBox(width: 9), Expanded(child: Text(v, style: const TextStyle(fontSize: 13)))]))).toList())),
        const SizedBox(height: 10),
        _section('Informasi layanan', Column(children: [
          _info('Kategori', category), _info('Jenis layanan', service.type), _info('Lokasi penyedia', service.location), _info('Jumlah terjual', '${service.sold} layanan'), _info('Ditambahkan', '${service.createdAt.day}/${service.createdAt.month}/${service.createdAt.year}'),
        ])),
        const SizedBox(height: 10),
        _section('Ulasan pembeli', const Text('Bagian review akan ditambahkan pada tahap berikutnya.', style: TextStyle(color: Colors.black54, fontSize: 13))),
      ]),
    );
  }

  Widget _info(String label, String value) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12))), const SizedBox(width: 12), Expanded(child: Text(value, textAlign: TextAlign.end, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)))]));
}
