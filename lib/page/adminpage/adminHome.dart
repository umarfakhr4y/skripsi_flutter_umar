part of '../../conn/auth.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _pesertaAktifCount = 0;
  int _totalMentorCount = 0;
  int _tugasAktifCount = 0;
  int _totalTugasCount = 0;
  double _persentaseKehadiran = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData({int retryCount = 0}) async {
    final pesertaResult = await AdminService.getPeserta();
    final mentorResult = await AdminService.getMentor();
    final kehadiranResult = await AdminService.getKehadiranHariIni();
    final tugasResult = await AdminService.getTugas();

    bool allSuccess = true;
    int pCount = 0;
    int mCount = 0;
    int tCount = 0;
    int tTotalCount = 0;
    double kPersen = 0.0;

    if (pesertaResult['success']) {
      final rawData = pesertaResult['data'];
      final List<dynamic> pesertaList = (rawData is List) ? rawData : [];
      for (var peserta in pesertaList) {
        if (peserta != null && peserta is Map && peserta['status'] != null) {
          final statusStr = peserta['status'].toString().toLowerCase();
          if (statusStr == 'aktif' || statusStr == 'true' || statusStr == '1') {
            pCount++;
          }
        }
      }
    } else {
      allSuccess = false;
    }

    if (mentorResult['success']) {
      final rawData = mentorResult['data'];
      final List<dynamic> mentorList = (rawData is List) ? rawData : [];
      mCount = mentorList.length;
    } else {
      allSuccess = false;
    }

    if (kehadiranResult['success']) {
      final rawData = kehadiranResult['data'];
      if (rawData != null && rawData['persentase'] != null) {
        kPersen = double.tryParse(rawData['persentase'].toString()) ?? 0.0;
      }
    } else {
      allSuccess = false;
    }

    if (tugasResult['success']) {
      final rawData = tugasResult['data'];
      if (rawData != null) {
        if (rawData['tugas_aktif'] != null) {
          tCount = int.tryParse(rawData['tugas_aktif'].toString()) ?? 0;
        }
        if (rawData['total_tugas'] != null) {
          tTotalCount = int.tryParse(rawData['total_tugas'].toString()) ?? 0;
        }
      }
    } else {
      allSuccess = false;
    }

    if (allSuccess) {
      if (mounted) {
        setState(() {
          _pesertaAktifCount = pCount;
          _totalMentorCount = mCount;
          _persentaseKehadiran = kPersen;
          _tugasAktifCount = tCount;
          _totalTugasCount = tTotalCount;
          _isLoading = false;
        });
      }
    } else {
      if (retryCount < 2) {
        // Coba fetch ulang jika gagal
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          _fetchData(retryCount: retryCount + 1);
        }
      } else {
        if (mounted) {
          setState(() {
            if (pesertaResult['success']) _pesertaAktifCount = pCount;
            if (mentorResult['success']) _totalMentorCount = mCount;
            if (kehadiranResult['success']) {
              final rData = kehadiranResult['data'];
              if (rData != null && rData['persentase'] != null) {
                _persentaseKehadiran =
                    double.tryParse(rData['persentase'].toString()) ?? 0.0;
              }
            }
            if (tugasResult['success']) {
              final rData = tugasResult['data'];
              if (rData != null) {
                if (rData['tugas_aktif'] != null) {
                  _tugasAktifCount =
                      int.tryParse(rData['tugas_aktif'].toString()) ?? 0;
                }
                if (rData['total_tugas'] != null) {
                  _totalTugasCount =
                      int.tryParse(rData['total_tugas'].toString()) ?? 0;
                }
              }
            }
            _isLoading = false;
          });
          print(
            "Error fetching data. P: ${pesertaResult['message']}, M: ${mentorResult['message']}, K: ${kehadiranResult['message']}, T: ${tugasResult['message']}",
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Light background
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFFE84C63),
          onRefresh: () async {
            setState(() {
              _isLoading = true;
            });
            await _fetchData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(displayWidth(context) * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom AppBar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "v",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.08,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              letterSpacing: -1.0,
                            ),
                          ),
                          TextSpan(
                            text: "o",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.08,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFE84C63), // Red
                              letterSpacing: -1.0,
                            ),
                          ),
                          TextSpan(
                            text: "casia",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.08,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              letterSpacing: -1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: displayHeight(context) * 0.03),

                // Dasbor Ringkasan Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(displayWidth(context) * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.04,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
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
                          Icon(
                            Icons.waving_hand,
                            color: const Color(0xFFB04A50),
                            size: displayWidth(context) * 0.04,
                          ),
                          SizedBox(width: displayWidth(context) * 0.02),
                          Text(
                            'SELAMAT PAGI, ADMIN',
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.03,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: displayHeight(context) * 0.01),
                      Text(
                        'Dasbor Ringkasan',
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.055,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.03),

                // Grid 2x2
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: displayWidth(context) * 0.04,
                  crossAxisSpacing: displayWidth(context) * 0.04,
                  childAspectRatio: 0.9,
                  children: [
                    _buildStatCard(
                      icon: Icons.people_outline,
                      iconColor: const Color(0xFFE84C63),
                      iconBg: const Color(0xFFFDE8EB),
                      title: _pesertaAktifCount.toString(),
                      subtitle: 'Peserta Aktif',
                      glowColor: const Color(0xFFE84C63),
                      isLoading: _isLoading,
                    ),
                    _buildStatCard(
                      icon: Icons.school_outlined,
                      iconColor: const Color(0xFFC78D32),
                      iconBg: const Color(0xFFFEF08A).withOpacity(0.5),
                      title: _totalMentorCount.toString(),
                      subtitle: 'Total Mentor',
                      glowColor: const Color(0xFFC78D32),
                      isLoading: _isLoading,
                    ),
                    _buildStatCard(
                      icon: Icons.assignment_turned_in_outlined,
                      iconColor: Colors.grey[700]!,
                      iconBg: Colors.grey[200]!,
                      title: _tugasAktifCount.toString(),
                      trailingTitle: ' / $_totalTugasCount',
                      subtitle: 'Tugas Aktif',
                      isLoading: _isLoading,
                    ),
                    // Kehadiran solid card
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFB04A50),
                        borderRadius: BorderRadius.circular(
                          displayWidth(context) * 0.04,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFB04A50).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: displayWidth(context) * 0.18,
                                height: displayWidth(context) * 0.18,
                                child: CircularProgressIndicator(
                                  value: _isLoading
                                      ? null
                                      : (_persentaseKehadiran / 100.0),
                                  strokeWidth: 5,
                                  backgroundColor: Colors.white.withOpacity(
                                    0.3,
                                  ),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                ),
                              ),
                              if (_isLoading)
                                Shimmer.fromColors(
                                  baseColor: Colors.white54,
                                  highlightColor: Colors.white,
                                  child: Container(
                                    width: displayWidth(context) * 0.08,
                                    height: displayWidth(context) * 0.04,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        displayWidth(context) * 0.01,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                Text(
                                  '${_persentaseKehadiran.toInt()}%',
                                  style: TextStyle(
                                    fontSize: displayWidth(context) * 0.045,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: displayHeight(context) * 0.015),
                          Text(
                            'KEHADIRAN',
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.03,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'HARI INI',
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.03,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: displayHeight(context) * 0.04),

                // Menu Administrasi
                Text(
                  'Menu Administrasi',
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.02),

                // Menu List Container
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.04,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.calendar_today_outlined,
                        title: 'Lihat Laporan Harian',
                        subtitle:
                            'Tinjau laporan harian yang diisi oleh peserta magang',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LaporanPesertaMentor(isAdmin: true),
                            ),
                          );
                        },
                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey[200],
                        indent: displayWidth(context) * 0.04,
                        endIndent: displayWidth(context) * 0.04,
                      ),
                      _buildMenuItem(
                        icon: Icons.people_outline,
                        title: 'Lihat Data Bimbingan',
                        subtitle: 'Tinjau semua data bimbingan',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BimbinganAdmin(isAdmin: true),
                            ),
                          );
                        },
                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey[200],
                        indent: displayWidth(context) * 0.04,
                        endIndent: displayWidth(context) * 0.04,
                      ),
                      _buildMenuItem(
                        icon: Icons.assignment_ind_outlined,
                        title: 'Lihat Data Perizinan',
                        subtitle:
                            'Tinjau semua data perizinan yang dibuat oleh peserta magang',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PersuratanPesertaMentordua(
                                    isAdmin: true,
                                  ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    Color? glowColor,
    bool isLoading = false,
    String? trailingTitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (glowColor != null)
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: glowColor.withOpacity(0.05),
                ),
              ),
            ),
          if (glowColor != null)
            Positioned(
              right: -10,
              top: -10,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: glowColor.withOpacity(0.1),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(displayWidth(context) * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(displayWidth(context) * 0.02),
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: displayWidth(context) * 0.05,
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.02),
                if (isLoading)
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: displayWidth(context) * 0.15,
                      height: displayWidth(context) * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          displayWidth(context) * 0.01,
                        ),
                      ),
                    ),
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.07,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (trailingTitle != null)
                        Text(
                          trailingTitle,
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[400],
                          ),
                        ),
                    ],
                  ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.03,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(displayWidth(context) * 0.04),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(displayWidth(context) * 0.03),
              decoration: const BoxDecoration(
                color: Color(0xFFE46B72),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFF5E1B22),
                size: displayWidth(context) * 0.06,
              ),
            ),
            SizedBox(width: displayWidth(context) * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.035,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: displayHeight(context) * 0.005),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.03,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[600],
              size: displayWidth(context) * 0.06,
            ),
          ],
        ),
      ),
    );
  }
}
