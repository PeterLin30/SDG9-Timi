
import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF5CC8CC);
const Color darkColor = Color(0xFF202124);

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final TextEditingController searchController =
      TextEditingController();

  String selectedStatus = 'Semua';
  String selectedCategory = 'Semua Kategori';
  String selectedSort = 'Terbaru';

  final List<String> statuses = [
    'Semua',
    'Menunggu',
    'Berlangsung',
    'Selesai',
    'Dibatalkan',
  ];

  final List<String> categories = [
    'Semua Kategori',
    'Website',
    'Mobile App',
    'Desain',
    'Bisnis',
    'Konsultasi',
  ];

  final List<Activity> activities = [
    Activity(
      title: 'Pembuatan Website Toko',
      business: 'Toko Berkah Jaya',
      description: 'Pembuatan website untuk penjualan produk UMKM.',
      category: 'Website',
      status: 'Berlangsung',
      createdAt: DateTime(2026, 11, 8),
      deadline: DateTime(2026, 11, 15),
      icon: Icons.language,
    ),
    Activity(
      title: 'Desain Logo Usaha',
      business: 'Kedai Kopi Nusantara',
      description: 'Membuat identitas visual dan logo usaha.',
      category: 'Desain',
      status: 'Menunggu',
      createdAt: DateTime(2026, 11, 7),
      deadline: DateTime(2026, 11, 12),
      icon: Icons.palette_outlined,
    ),
    Activity(
      title: 'Aplikasi Kasir UMKM',
      business: 'Warung Maju',
      description: 'Pengembangan aplikasi kasir sederhana.',
      category: 'Mobile App',
      status: 'Selesai',
      createdAt: DateTime(2026, 11, 5),
      deadline: DateTime(2026, 11, 10),
      icon: Icons.phone_android,
    ),
    Activity(
      title: 'Konsultasi Digital Marketing',
      business: 'Snack Enak',
      description: 'Konsultasi strategi pemasaran digital.',
      category: 'Konsultasi',
      status: 'Dibatalkan',
      createdAt: DateTime(2026, 11, 3),
      deadline: DateTime(2026, 11, 20),
      icon: Icons.campaign_outlined,
    ),
    Activity(
      title: 'Pendampingan Usaha',
      business: 'Batik Sejahtera',
      description: 'Bantuan pengembangan dan pengelolaan bisnis.',
      category: 'Bisnis',
      status: 'Menunggu',
      createdAt: DateTime(2026, 11, 1),
      deadline: DateTime(2026, 11, 18),
      icon: Icons.business_center_outlined,
    ),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Memfilter dan mengurutkan aktivitas
  List<Activity> get filteredActivities {
    List<Activity> result = activities.where((activity) {
      final search = searchController.text.toLowerCase();

      final matchesSearch =
          activity.title.toLowerCase().contains(search) ||
          activity.business.toLowerCase().contains(search);

      final matchesStatus = selectedStatus == 'Semua' ||
          activity.status == selectedStatus;

      final matchesCategory =
          selectedCategory == 'Semua Kategori' ||
          activity.category == selectedCategory;

      return matchesSearch && matchesStatus && matchesCategory;
    }).toList();

    // Pengurutan aktivitas
    if (selectedSort == 'Terbaru') {
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (selectedSort == 'Terlama') {
      result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } else if (selectedSort == 'Tenggat Waktu Terdekat') {
      result.sort((a, b) => a.deadline.compareTo(b.deadline));
    }

    return result;
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Colors.orange;
      case 'Berlangsung':
        return Colors.blue;
      case 'Selesai':
        return Colors.green;
      case 'Dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Bottom sheet filter
  void showFilterSheet() {
    String tempCategory = selectedCategory;
    String tempSort = selectedSort;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Judul
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter Aktivitas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: darkColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Filter urutan
                    const Text(
                      'Urutkan Berdasarkan',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: tempSort,
                      isExpanded: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                      items: [
                        'Terbaru',
                        'Terlama',
                        'Tenggat Waktu Terdekat',
                      ].map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setModalState(() {
                            tempSort = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    // Filter kategori
                    const Text(
                      'Kategori Layanan',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: tempCategory,
                      isExpanded: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                      items: categories.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setModalState(() {
                            tempCategory = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 28),

                    // Tombol aksi
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setModalState(() {
                                tempCategory = 'Semua Kategori';
                                tempSort = 'Terbaru';
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              foregroundColor: primaryColor,
                              side: const BorderSide(
                                color: primaryColor,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Reset'),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedCategory = tempCategory;
                                selectedSort = tempSort;
                              });

                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Terapkan'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedActivities = filteredActivities;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aktivitas',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: darkColor,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Pantau perkembangan layanan Anda',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Search bar dan tombol filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: 'Cari aktivitas...',
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF7F8FA),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: showFilterSheet,
                      icon: const Icon(
                        Icons.tune,
                        color: primaryColor,
                      ),
                      tooltip: 'Filter aktivitas',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Status chips
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: statuses.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final status = statuses[index];
                  final isSelected = selectedStatus == status;

                  return ChoiceChip(
                    label: Text(status),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedStatus = status;
                      });
                    },
                    selectedColor: primaryColor,
                    backgroundColor: const Color(0xFFF7F8FA),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : darkColor,
                    ),
                    side: BorderSide.none,
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Informasi jumlah aktivitas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daftar Aktivitas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkColor,
                    ),
                  ),
                  Text(
                    '${displayedActivities.length} aktivitas',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Daftar aktivitas
            Expanded(
              child: displayedActivities.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 55,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Aktivitas tidak ditemukan',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: displayedActivities.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final activity = displayedActivities[index];

                        return _buildActivityCard(activity);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Tampilan kartu aktivitas
  Widget _buildActivityCard(Activity activity) {
    final statusColor = getStatusColor(activity.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFEEEEEE),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  activity.icon,
                  color: primaryColor,
                  size: 23,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: darkColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.business,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  activity.status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            activity.description,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 14),

          const Divider(height: 1),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.category_outlined,
                size: 15,
                color: Colors.grey,
              ),
              const SizedBox(width: 5),
              Text(
                activity.category,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),

              const Spacer(),

              const Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: Colors.grey,
              ),
              const SizedBox(width: 5),
              Text(
                'Tenggat: ${formatDate(activity.deadline)}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Model data aktivitas
class Activity {
  final String title;
  final String business;
  final String description;
  final String category;
  final String status;
  final DateTime createdAt;
  final DateTime deadline;
  final IconData icon;

  Activity({
    required this.title,
    required this.business,
    required this.description,
    required this.category,
    required this.status,
    required this.createdAt,
    required this.deadline,
    required this.icon,
  });
}
