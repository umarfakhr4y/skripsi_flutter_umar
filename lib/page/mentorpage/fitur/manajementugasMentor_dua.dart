part of '../../../conn/auth.dart';

class ManajemenTugasMentordua extends StatefulWidget {
  const ManajemenTugasMentordua({super.key});

  @override
  State<ManajemenTugasMentordua> createState() =>
      _ManajemenTugasMentorduaState();
}

class _ManajemenTugasMentorduaState extends State<ManajemenTugasMentordua> {
  String selectedTab = 'Aktif';
  final List<String> tabList = ['Aktif', 'Ditinjau', 'Selesai'];

  List<Map<String, dynamic>> listPenugasan = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPenugasan();
  }

  Future<void> _fetchPenugasan() async {
    setState(() {
      _isLoading = true;
    });
    final result = await MentorService.getPenugasanMentor();
    if (mounted) {
      if (result['success'] && result['data'] is List) {
        final List<dynamic> data = result['data'];
        setState(() {
          listPenugasan = data.map((e) => e as Map<String, dynamic>).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = listPenugasan
        .where(
          (task) =>
              (task['status_tugas'] ?? 'Aktif').toString().toLowerCase() ==
              selectedTab.toLowerCase(),
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text(
          'Manajemen Tugas',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: displayWidth(context) * 0.05,
          ),
        ),
        backgroundColor: const Color(0xFFEEEEEE),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahTugasMentor()),
          );
          if (added == true) {
            _fetchPenugasan();
          }
        },
        backgroundColor: const Color(0xFFAD3B3E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchPenugasan,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: displayWidth(context) * 0.06,
              vertical: displayHeight(context) * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ringkasan Tugas Card
                _buildRingkasanCard(),
                SizedBox(height: displayHeight(context) * 0.025),

                // Filter Tabs (Aktif, Ditinjau, Selesai)
                _buildFilterTabs(),
                SizedBox(height: displayHeight(context) * 0.025),

                // Task Cards List or Loading
                _isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(
                            color: Color(0xFFAD3B3E),
                          ),
                        ),
                      )
                    : filteredTasks.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(displayWidth(context) * 0.1),
                          child: Text(
                            'Belum ada tugas pada status ini',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: displayWidth(context) * 0.038,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          return _buildTaskCard(filteredTasks[index]);
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRingkasanCard() {
    int countAktif = listPenugasan
        .where(
          (t) => (t['status_tugas'] ?? '').toString().toLowerCase() == 'aktif',
        )
        .length;
    int countDitinjau = listPenugasan
        .where(
          (t) =>
              (t['status_tugas'] ?? '').toString().toLowerCase() == 'ditinjau',
        )
        .length;
    int countSelesai = listPenugasan
        .where(
          (t) =>
              (t['status_tugas'] ?? '').toString().toLowerCase() == 'selesai',
        )
        .length;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(displayWidth(context) * 0.05),
      decoration: BoxDecoration(
        color: const Color(0xFFAD3B3E),
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.045),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAD3B3E).withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Tugas',
            style: TextStyle(
              color: Colors.white,
              fontSize: displayWidth(context) * 0.042,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: displayHeight(context) * 0.02),
          Row(
            children: [
              Expanded(child: _buildSummaryBox(countAktif.toString(), 'AKTIF')),
              SizedBox(width: displayWidth(context) * 0.03),
              Expanded(
                child: _buildSummaryBox(countDitinjau.toString(), 'REVIEW'),
              ),
              SizedBox(width: displayWidth(context) * 0.03),
              Expanded(
                child: _buildSummaryBox(countSelesai.toString(), 'SELESAI'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBox(String count, String label) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: displayHeight(context) * 0.015),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: displayWidth(context) * 0.06,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: displayHeight(context) * 0.005),
          Text(
            label,
            style: TextStyle(
              fontSize: displayWidth(context) * 0.026,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      padding: EdgeInsets.all(displayWidth(context) * 0.012),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.06),
      ),
      child: Row(
        children: tabList.map((tab) {
          final isSelected = selectedTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedTab = tab;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: displayHeight(context) * 0.013,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFAD3B3E)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.05,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  tab,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: displayWidth(context) * 0.035,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    String tag = (task['status_tugas'] ?? 'Aktif').toString().toUpperCase();
    Color tagBgColor = const Color(0xFFFFF8E1);
    Color tagTextColor = const Color(0xFFB8860B);

    if (tag == 'DITINJAU') {
      tagBgColor = const Color(0xFFFDE8E8);
      tagTextColor = const Color(0xFFAD3B3E);
    } else if (tag == 'SELESAI') {
      tagBgColor = const Color(0xFFE8F5E9);
      tagTextColor = const Color(0xFF2E7D32);
    }

    String judul = task['judul_tugas'] ?? '-';
    String deadline = task['deadline'] ?? '-';
    if (deadline.contains('-')) {
      final parts = deadline.split('-');
      if (parts.length == 3 && parts[0].length == 4) {
        deadline = "${parts[2]}-${parts[1]}-${parts[0]}";
      }
    }
    String namaPeserta = '-';
    if (task['peserta'] is Map) {
      namaPeserta = task['peserta']['nama_lengkap'] ?? '-';
    }

    return Container(
      margin: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
      padding: EdgeInsets.all(displayWidth(context) * 0.045),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Tag and Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: displayWidth(context) * 0.03,
                  vertical: displayHeight(context) * 0.005,
                ),
                decoration: BoxDecoration(
                  color: tagBgColor,
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.02,
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: tagTextColor,
                    fontSize: displayWidth(context) * 0.027,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: displayWidth(context) * 0.038,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: displayWidth(context) * 0.015),
                  Text(
                    deadline,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: displayWidth(context) * 0.032,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: displayHeight(context) * 0.015),

          // Task Title
          Text(
            judul,
            style: TextStyle(
              fontSize: displayWidth(context) * 0.042,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: displayHeight(context) * 0.015),

          // Assigned User Box
          Container(
            padding: EdgeInsets.all(displayWidth(context) * 0.03),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: displayWidth(context) * 0.05,
                  backgroundColor: const Color(0xFFAD3B3E),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: displayWidth(context) * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Diberikan kepada:',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: displayWidth(context) * 0.03,
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.003),
                    Text(
                      namaPeserta,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: displayWidth(context) * 0.035,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: displayHeight(context) * 0.015),

          // Lihat Detail Button
          InkWell(
            onTap: () async {
              final deleted = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailTugasMentor(task: task),
                ),
              );
              if (deleted == true) {
                _fetchPenugasan();
              }
            },
            borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: displayHeight(context) * 0.015,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFBEAEA),
                borderRadius: BorderRadius.circular(
                  displayWidth(context) * 0.03,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lihat Detail',
                    style: TextStyle(
                      color: const Color(0xFFAD3B3E),
                      fontWeight: FontWeight.bold,
                      fontSize: displayWidth(context) * 0.035,
                    ),
                  ),
                  SizedBox(width: displayWidth(context) * 0.02),
                  Icon(
                    Icons.arrow_forward,
                    color: const Color(0xFFAD3B3E),
                    size: displayWidth(context) * 0.045,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
