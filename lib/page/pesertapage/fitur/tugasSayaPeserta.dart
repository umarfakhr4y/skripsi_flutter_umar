part of '../../../conn/auth.dart';

class TugasSayaPeserta extends StatefulWidget {
  const TugasSayaPeserta({super.key});

  @override
  State<TugasSayaPeserta> createState() => _TugasSayaPesertaState();
}

class _TugasSayaPesertaState extends State<TugasSayaPeserta> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFAD3B3E)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Tugas Saya',
            style: TextStyle(
              color: Color(0xFFAD3B3E),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Color(0xFFAD3B3E),
            unselectedLabelColor: Color(0xFF888888),
            indicatorColor: Color(0xFFAD3B3E),
            indicatorWeight: 3,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 13,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.normal,
              fontFamily: 'Poppins',
              fontSize: 13,
            ),
            tabs: [
              Tab(text: 'Aktif'),
              Tab(text: 'Selesai'),
              Tab(text: 'Terlambat'),
              Tab(text: 'Menunggu Review'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAktifTab(),
            const Center(child: Text("Selesai")),
            const Center(child: Text("Terlambat")),
            const Center(child: Text("Menunggu Review")),
          ],
        ),
      ),
    );
  }

  Widget _buildAktifTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progres Mingguan Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE46B6F),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Background icon/watermark
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(
                    Icons.check_circle,
                    size: 150,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Icon(
                    Icons.assignment_turned_in,
                    size: 100,
                    color: Colors.white.withOpacity(0.15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PROGRES MINGGUAN',
                        style: TextStyle(
                          color: Color(0xFF8B2B2D),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Kamu telah menyelesaikan 4\ndari 6 tugas!',
                        style: TextStyle(
                          color: Color(0xFF6B1D1F),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Progress bar
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double percent = 4 / 6;
                          return Stack(
                            children: [
                              Container(
                                height: 6,
                                width: constraints.maxWidth,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              Container(
                                height: 6,
                                width: constraints.maxWidth * percent,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Tugas Aktif Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tugas Aktif',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to calendar or something
                },
                child: const Text(
                  'Lihat Kalender',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFAD3B3E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // List of Tasks
          _buildTaskCard(
            category: 'DEVELOPMENT',
            timeRemaining: '2 Hari Lagi',
            title: 'Implementasi API Dashboard',
            description:
                'Integrasi endpoint data statistik mingguan ke dalam komponen grafik di dashboard utama.',
            dueDate: '24 Okt 2024',
          ),
          const SizedBox(height: 16),
          _buildTaskCard(
            category: 'DESIGN',
            timeRemaining: '5 Hari Lagi',
            title: 'Desain UI Mobile - Profile',
            description:
                'Membuat high-fidelity mockup untuk halaman profil intern dan mentor dengan gaya minimalis.',
            dueDate: '27 Okt 2024',
          ),
          const SizedBox(height: 16),
          _buildTaskCard(
            category: 'COPYWRITING',
            timeRemaining: '1 Minggu Lagi',
            title: 'Drafting Documentation',
            description:
                'Menulis panduan penggunaan fitur baru untuk pengguna akhir dalam Bahasa Indonesia yang..',
            dueDate: '30 Okt 2024',
          ),
          const SizedBox(height: 24), // bottom padding
        ],
      ),
    );
  }

  Widget _buildTaskCard({
    required String category,
    required String timeRemaining,
    required String title,
    required String description,
    required String dueDate,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF666666),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.access_time, size: 14, color: Color(0xFFC74346)),
              const SizedBox(width: 4),
              Text(
                timeRemaining,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC74346),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade200, height: 1, thickness: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tenggat: $dueDate',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // handle kumpulkan
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEA5455),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Kumpulkan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
