part of '../../../conn/auth.dart';

class DetailPesertaMagangMentor extends StatefulWidget {
  final int pesertaId;
  const DetailPesertaMagangMentor({super.key, required this.pesertaId});

  @override
  State<DetailPesertaMagangMentor> createState() =>
      _DetailPesertaMagangMentorState();
}

class _DetailPesertaMagangMentorState extends State<DetailPesertaMagangMentor> {
  Map<String, dynamic>? _pesertaData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetailPeserta();
  }

  Future<void> _fetchDetailPeserta() async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      final response = await http.get(
        Uri.parse(
          'http://10.0.2.2:8000/api/mentor/peserta/${widget.pesertaId}',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            _pesertaData = data['data'];
            _isLoading = false;
          });
        } else {
          setState(() => _isLoading = false);
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text(
          'Profil Peserta',
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFE84C63)),
            )
          : _pesertaData == null
          ? const Center(
              child: Text(
                "Gagal memuat data peserta",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(displayWidth(context) * 0.05),
                child: Column(
                  children: [
                    _buildProfilHeader(),
                    SizedBox(height: displayHeight(context) * 0.02),
                    _buildDataDiri(),
                    SizedBox(height: displayHeight(context) * 0.02),
                    _buildRekapAbsensi(),
                    SizedBox(height: displayHeight(context) * 0.02),
                    _buildTugasTerbaru(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfilHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: displayHeight(context) * 0.03,
        horizontal: displayWidth(context) * 0.04,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: displayWidth(context) * 0.1,
            backgroundColor: Colors.grey[300],
            backgroundImage: const NetworkImage(
              'https://i.pravatar.cc/150?img=11',
            ), // Dummy image
          ),
          SizedBox(height: displayHeight(context) * 0.02),
          Text(
            _pesertaData?['nama_lengkap'] ?? 'Unknown',
            style: TextStyle(
              fontSize: displayWidth(context) * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: displayHeight(context) * 0.005),
          Text(
            '${_pesertaData?['universitas'] ?? '-'} • ${_pesertaData?['prodi'] ?? '-'}',
            style: TextStyle(
              fontSize: displayWidth(context) * 0.03,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: displayHeight(context) * 0.015),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: displayWidth(context) * 0.04,
              vertical: displayHeight(context) * 0.005,
            ),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(displayWidth(context) * 0.05),
              border: Border.all(color: Colors.green.withOpacity(0.5)),
            ),
            child: Text(
              _pesertaData?['status'] ?? 'Aktif',
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
                fontSize: displayWidth(context) * 0.03,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataDiri() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(displayWidth(context) * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline,
                color: const Color(0xFFE57373),
                size: displayWidth(context) * 0.05,
              ),
              SizedBox(width: displayWidth(context) * 0.02),
              Text(
                'Data Diri',
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: displayHeight(context) * 0.02),
          _buildDataRow('Email', _pesertaData?['email'] ?? '-'),
          SizedBox(height: displayHeight(context) * 0.015),
          _buildDataRow('No. Telepon', _pesertaData?['no_telpon'] ?? '-'),
          SizedBox(height: displayHeight(context) * 0.015),
          _buildDataRow(
            'Periode Magang',
            '${_pesertaData?['periode_masuk'] ?? '-'} s.d ${_pesertaData?['periode_keluar'] ?? '-'}',
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: displayWidth(context) * 0.03,
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: displayHeight(context) * 0.005),
        Text(
          value,
          style: TextStyle(
            fontSize: displayWidth(context) * 0.035,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildRekapAbsensi() {
    final Map<String, dynamic>? rekap = _pesertaData?['rekap_absensi'];
    final int hadir = rekap?['hadir'] ?? 0;
    final int izin = rekap?['izin'] ?? 0;
    final int sakit = rekap?['sakit'] ?? 0;
    final int telat = rekap?['telat'] ?? 0;
    final int alpa = rekap?['alpa'] ?? 0;

    final List<String> bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    final namaBulan = bulan[DateTime.now().month - 1];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(displayWidth(context) * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: const Color(0xFFE57373),
                size: displayWidth(context) * 0.05,
              ),
              SizedBox(width: displayWidth(context) * 0.02),
              Text(
                'Kehadiran Bulan Ini ($namaBulan)',
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: displayHeight(context) * 0.02),
          Row(
            children: [
              _buildAbsensiCounter(
                title: 'Hadir',
                count: hadir.toString(),
                color: const Color(0xFF4CAF50), // Green
                icon: Icons.check_circle_outline,
              ),
              SizedBox(width: displayWidth(context) * 0.03),
              _buildAbsensiCounter(
                title: 'Telat',
                count: telat.toString(),
                color: const Color(0xFFFBC02D), // Yellow/Orange
                icon: Icons.watch_later_outlined,
              ),
              SizedBox(width: displayWidth(context) * 0.03),
              _buildAbsensiCounter(
                title: 'Izin',
                count: izin.toString(),
                color: const Color(0xFFF57C00), // Orange
                icon: Icons.assignment_late_outlined,
              ),
            ],
          ),
          SizedBox(height: displayHeight(context) * 0.02),
          Row(
            children: [
              _buildAbsensiCounter(
                title: 'Sakit',
                count: sakit.toString(),
                color: const Color(0xFFD32F2F), // Red
                icon: Icons.local_hospital_outlined,
              ),
              SizedBox(width: displayWidth(context) * 0.03),
              _buildAbsensiCounter(
                title: 'Alpa',
                count: alpa.toString(),
                color: Colors.grey[700]!, // Grey
                icon: Icons.person_off_outlined,
              ),
              SizedBox(width: displayWidth(context) * 0.03),
              Expanded(
                child: const SizedBox.shrink(),
              ), // Placeholder to keep sizes consistent
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAbsensiCounter({
    required String title,
    required String count,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: displayHeight(context) * 0.015),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: displayWidth(context) * 0.06),
            SizedBox(height: displayHeight(context) * 0.005),
            Text(
              count,
              style: TextStyle(
                fontSize: displayWidth(context) * 0.045,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: displayWidth(context) * 0.03,
                fontWeight: FontWeight.w600,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTugasTerbaru() {
    final List<dynamic> tugasList = _pesertaData?['tugas'] ?? [];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(displayWidth(context) * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    color: const Color(0xFFE57373),
                    size: displayWidth(context) * 0.05,
                  ),
                  SizedBox(width: displayWidth(context) * 0.02),
                  Text(
                    'Tugas Terkini',
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: displayHeight(context) * 0.02),
          if (tugasList.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: displayHeight(context) * 0.02,
                ),
                child: Text(
                  'Belum ada tugas yang diberikan.',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          else
            ...tugasList.take(5).map((tugas) {
              final status = (tugas['status_tugas'] ?? 'aktif')
                  .toString()
                  .toLowerCase();
              final judul = tugas['judul_tugas'] ?? '-';

              String subtitle = '';
              String badgeText = '';
              Color badgeColor = Colors.grey;
              Color badgeBgColor = Colors.grey.shade200;
              IconData icon = Icons.assignment_outlined;
              Color iconColor = Colors.grey;
              Color iconBgColor = Colors.grey.shade100;

              if (status == 'selesai') {
                subtitle = 'Selesai';
                badgeText = 'SELESAI';
                badgeColor = const Color(0xFF4CAF50); // Green
                badgeBgColor = const Color(0xFFE8F5E9); // Light Green
                icon = Icons.check_circle_outline;
                iconColor = const Color(0xFF4CAF50);
                iconBgColor = const Color(0xFFE8F5E9);
              } else if (status == 'ditinjau') {
                subtitle = 'Menunggu Review';
                badgeText = 'DITINJAU';
                badgeColor = const Color(0xFFF57C00); // Orange
                badgeBgColor = const Color(0xFFFFF3E0);
                icon = Icons.design_services_outlined;
                iconColor = const Color(0xFFFF9800);
                iconBgColor = const Color(0xFFFFF3E0);
              } else if (status == 'revisi') {
                subtitle = 'Perlu Revisi';
                badgeText = 'REVISI';
                badgeColor = const Color(0xFFD32F2F); // Red
                badgeBgColor = const Color(0xFFFFEBEE);
                icon = Icons.sync_problem;
                iconColor = const Color(0xFFD32F2F);
                iconBgColor = const Color(0xFFFFEBEE);
              } else {
                // Aktif
                final deadlineStr = tugas['deadline'];
                if (deadlineStr != null && deadlineStr.toString().isNotEmpty) {
                  final rawDate = deadlineStr.toString().split('T')[0];
                  subtitle = 'Deadline: $rawDate';
                } else {
                  subtitle = 'Sedang dikerjakan';
                }
                badgeText = 'AKTIF';
                badgeColor = const Color(0xFF1976D2); // Blue
                badgeBgColor = const Color(0xFFE3F2FD);
                icon = Icons.code;
                iconColor = const Color(0xFF1976D2);
                iconBgColor = const Color(0xFFE3F2FD);
              }

              return Padding(
                padding: EdgeInsets.only(
                  bottom: displayHeight(context) * 0.015,
                ),
                child: _buildTugasCard(
                  icon: icon,
                  iconBgColor: iconBgColor,
                  iconColor: iconColor,
                  title: judul,
                  subtitle: subtitle,
                  badgeText: badgeText,
                  badgeColor: badgeColor,
                  badgeBgColor: badgeBgColor,
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildTugasCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required Color badgeBgColor,
  }) {
    return Container(
      padding: EdgeInsets.all(displayWidth(context) * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Icon Box
          Container(
            padding: EdgeInsets.all(displayWidth(context) * 0.025),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: displayWidth(context) * 0.05,
            ),
          ),
          SizedBox(width: displayWidth(context) * 0.03),

          // Texts
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: displayHeight(context) * 0.005),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.03,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: displayWidth(context) * 0.02),

          // Status Badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: displayWidth(context) * 0.025,
              vertical: displayHeight(context) * 0.005,
            ),
            decoration: BoxDecoration(
              color: badgeBgColor,
              borderRadius: BorderRadius.circular(
                displayWidth(context) * 0.015,
              ),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                color: badgeColor,
                fontWeight: FontWeight.w800,
                fontSize: displayWidth(context) * 0.025,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
