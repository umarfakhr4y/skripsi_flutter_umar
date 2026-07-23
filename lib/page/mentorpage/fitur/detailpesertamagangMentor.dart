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

  Widget _buildTugasTerbaru() {
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
          _buildTugasCard(
            icon: Icons.code,
            iconBgColor: const Color(0xFFE8EAF6), // Light Indigo
            iconColor: const Color(0xFF3F51B5), // Indigo
            title: 'Implementasi API Login',
            subtitle: 'Deadline: 15 Mei 2024',
            badgeText: 'PROSES',
            badgeColor: const Color(0xFFF57C00), // Orange
            badgeBgColor: const Color(0xFFFFF3E0), // Light Orange
          ),
          SizedBox(height: displayHeight(context) * 0.015),
          _buildTugasCard(
            icon: Icons.check_circle_outline,
            iconBgColor: const Color(0xFFE8F5E9), // Light Green
            iconColor: const Color(0xFF4CAF50), // Green
            title: 'Desain UI Dashboard',
            subtitle: 'Diselesaikan: 10 Mei 2024',
            badgeText: 'SELESAI',
            badgeColor: const Color(0xFF4CAF50), // Green
            badgeBgColor: const Color(0xFFE8F5E9), // Light Green
          ),
          SizedBox(height: displayHeight(context) * 0.015),
          _buildTugasCard(
            icon: Icons.design_services_outlined,
            iconBgColor: const Color(0xFFFFF3E0), // Light Orange
            iconColor: const Color(0xFFFF9800), // Orange
            title: 'Riset User Persona',
            subtitle: 'Menunggu Review Mentor',
            badgeText: 'REVIEW',
            badgeColor: const Color(0xFF2196F3), // Blue
            badgeBgColor: const Color(0xFFE3F2FD), // Light Blue
          ),
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
