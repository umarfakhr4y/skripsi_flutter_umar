part of '../../../conn/auth.dart';

class TugasSayaPeserta extends StatefulWidget {
  const TugasSayaPeserta({super.key});

  @override
  State<TugasSayaPeserta> createState() => _TugasSayaPesertaState();
}

class _TugasSayaPesertaState extends State<TugasSayaPeserta> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _listTugas = [];

  @override
  void initState() {
    super.initState();
    _fetchTugas();
  }

  Future<void> _fetchTugas() async {
    setState(() {
      _isLoading = true;
    });
    final res = await PesertaService.getPenugasanPeserta();
    if (mounted) {
      if (res['success'] == true) {
        final List<dynamic> data = res['data'] ?? [];
        setState(() {
          _listTugas = data.map((e) => Map<String, dynamic>.from(e)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _listTugas = [];
          _isLoading = false;
        });
      }
    }
  }

  bool _isOverdue(Map<String, dynamic> task) {
    final dl = task['deadline']?.toString() ?? '';
    final status = task['status_tugas']?.toString() ?? '';
    if (status == 'Selesai') return false;
    if (dl.isEmpty) return false;
    try {
      DateTime dt = DateTime.parse(dl);
      DateTime today = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      DateTime target = DateTime(dt.year, dt.month, dt.day);
      return today.isAfter(target);
    } catch (_) {}
    return false;
  }

  List<Map<String, dynamic>> _getFilteredTasks(String type) {
    switch (type) {
      case 'Semua Tugas':
        return _listTugas;
      case 'Menunggu Review':
        return _listTugas.where((t) {
          return (t['status_tugas']?.toString() ?? '') == 'Ditinjau';
        }).toList();
      case 'Selesai':
        return _listTugas.where((t) {
          return (t['status_tugas']?.toString() ?? '') == 'Selesai';
        }).toList();
      default:
        return [];
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        return "${parts[2]}-${parts[1]}-${parts[0]}";
      }
    } catch (_) {}
    return dateStr;
  }

  String _calculateTimeRemaining(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      DateTime dt = DateTime.parse(dateStr);
      DateTime today = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      DateTime target = DateTime(dt.year, dt.month, dt.day);
      int diff = target.difference(today).inDays;
      if (diff > 0) {
        return "$diff Hari Lagi";
      } else if (diff == 0) {
        return "Hari Ini";
      } else {
        return "Terlambat ${diff.abs()} Hari";
      }
    } catch (_) {}
    return '-';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
              Tab(text: 'Semua Tugas'),
              Tab(text: 'Menunggu Review'),
              Tab(text: 'Selesai'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFAD3B3E)),
              )
            : TabBarView(
                children: [
                  _buildTabContent(
                    'Semua Tugas',
                    _getFilteredTasks('Semua Tugas'),
                  ),
                  _buildTabContent(
                    'Menunggu Review',
                    _getFilteredTasks('Menunggu Review'),
                  ),
                  _buildTabContent('Selesai', _getFilteredTasks('Selesai')),
                ],
              ),
      ),
    );
  }

  Widget _buildTabContent(String tabTitle, List<Map<String, dynamic>> tasks) {
    int selesaiCount = _listTugas
        .where((t) => (t['status_tugas']?.toString() ?? '') == 'Selesai')
        .length;
    int totalCount = _listTugas.length;
    double percent = totalCount > 0 ? selesaiCount / totalCount : 0.0;

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
                      Text(
                        'Kamu telah menyelesaikan $selesaiCount\ndari $totalCount tugas!',
                        style: const TextStyle(
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

          // Header Kategori Tab
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tabTitle == 'Semua Tugas' ? 'Semua Tugas' : 'Tugas $tabTitle',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              GestureDetector(
                onTap: _fetchTugas,
                child: const Text(
                  'Refresh',
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

          // List of Tasks or Empty State
          if (tasks.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 50,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Belum ada tugas di kategori ini',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...tasks.map((task) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildTaskCard(task: task),
              );
            }),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTaskCard({required Map<String, dynamic> task}) {
    final status = task['status_tugas']?.toString() ?? 'Aktif';
    String category = 'AKTIF';
    Color badgeColor = const Color(0xFFE3F2FD);
    Color badgeTextColor = const Color(0xFF1976D2);

    if (status == 'Revisi') {
      category = 'REVISI';
      badgeColor = const Color(0xFFFFF0E6);
      badgeTextColor = const Color(0xFFD9534F);
    } else if (status == 'Ditinjau') {
      category = 'DITINJAU';
      badgeColor = const Color(0xFFFFF8E1);
      badgeTextColor = const Color(0xFFB8860B);
    } else if (status == 'Selesai') {
      category = 'SELESAI';
      badgeColor = const Color(0xFFE8F5E9);
      badgeTextColor = const Color(0xFF2E7D32);
    }
    final mentorName = task['mentor']?['nama_lengkap']?.toString() ?? '';

    final title = task['judul_tugas']?.toString() ?? 'Tanpa Judul';
    final description = task['deskripsi']?.toString() ?? '-';
    final dueDate = _formatDate(task['deadline']?.toString());
    final timeRemaining = _calculateTimeRemaining(task['deadline']?.toString());

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
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: badgeTextColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if (mentorName.isNotEmpty) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '• MENTOR: ${mentorName.toUpperCase()}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailTugasPeserta(task: task),
                    ),
                  ).then((_) {
                    _fetchTugas();
                  });
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
                    'Lihat Detail',
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
