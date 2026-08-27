part of '../../conn/auth.dart';

class AdminValidasi extends StatefulWidget {
  const AdminValidasi({Key? key}) : super(key: key);

  @override
  State<AdminValidasi> createState() => _AdminValidasiState();
}

class _AdminValidasiState extends State<AdminValidasi> {
  bool _isLoading = true;
  List<dynamic> _pendingList = [];

  @override
  void initState() {
    super.initState();
    _fetchPendingRegistrations();
  }

  Future<void> _fetchPendingRegistrations() async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      final response = await http.get(
        Uri.parse('$baseApiUrl/api/admin/pending-registrations'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            _pendingList = data['data'];
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal mengambil data pendaftaran pending'),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
      }
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "U";
    List<String> names = name.split(" ");
    String initials = "";
    int numWords = names.length > 2 ? 2 : names.length;
    for (int i = 0; i < numWords; i++) {
      if (names[i].isNotEmpty) {
        initials += names[i][0].toUpperCase();
      }
    }
    return initials.isEmpty ? "U" : initials;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(displayWidth(context) * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom AppBar (Logo & Avatar)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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

              // Title and Subtitle
              Text(
                'Pendaftaran Pending',
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.01),
              Text(
                'Tinjau dan setujui pengguna baru yang bergabung di\nplatform.',
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.035,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.03),

              // User List
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _pendingList.isEmpty
                  ? Center(
                      child: Text(
                        'Tidak ada pendaftaran pending.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: displayWidth(context) * 0.04,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _pendingList.length,
                      itemBuilder: (context, index) {
                        final peserta = _pendingList[index];
                        final nama = peserta['nama_lengkap'] ?? 'Tanpa Nama';
                        final univ = peserta['universitas'] ?? '-';
                        final prodi = peserta['prodi'] ?? '-';
                        final desc = "$univ\n$prodi";
                        final dateStr = peserta['created_at'] ?? '';
                        String timeText = 'Baru saja';

                        if (dateStr.isNotEmpty) {
                          try {
                            final date = DateTime.parse(dateStr);
                            timeText = "${date.day}/${date.month}/${date.year}";
                          } catch (_) {}
                        }

                        return _buildPendingCard(
                          context: context,
                          initials: _getInitials(nama),
                          avatarBgColor: const Color(0xFFE2E8F0),
                          avatarTextColor: Colors.black54,
                          name: nama,
                          roleBadge: 'Peserta',
                          badgeBgColor: const Color(0xFFFDE8EB),
                          badgeTextColor: const Color(0xFFB04A50),
                          timeText: 'Mendaftar pada $timeText',
                          descText: desc,
                        );
                      },
                    ),
              SizedBox(height: displayHeight(context) * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPendingCard({
    required BuildContext context,
    required String initials,
    required Color avatarBgColor,
    required Color avatarTextColor,
    required String name,
    required String roleBadge,
    required Color badgeBgColor,
    required Color badgeTextColor,
    required String timeText,
    required String descText,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
      padding: EdgeInsets.all(displayWidth(context) * 0.04),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: displayWidth(context) * 0.07,
                backgroundColor: avatarBgColor,
                child: Text(
                  initials,
                  style: TextStyle(
                    color: avatarTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: displayWidth(context) * 0.045,
                  ),
                ),
              ),
              SizedBox(width: displayWidth(context) * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.01),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: displayWidth(context) * 0.02,
                            vertical: displayHeight(context) * 0.003,
                          ),
                          decoration: BoxDecoration(
                            color: badgeBgColor,
                            borderRadius: BorderRadius.circular(
                              displayWidth(context) * 0.03,
                            ),
                          ),
                          child: Text(
                            roleBadge,
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.028,
                              fontWeight: FontWeight.w600,
                              color: badgeTextColor,
                            ),
                          ),
                        ),
                        SizedBox(width: displayWidth(context) * 0.03),
                        Text(
                          timeText,
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.028,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: displayHeight(context) * 0.015),
                    Text(
                      descText,
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.035,
                        color: Colors.grey[700],
                        height: 1.3,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: displayHeight(context) * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Tolak button
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: displayWidth(context) * 0.04,
                    vertical: displayHeight(context) * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.05,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.close,
                        size: displayWidth(context) * 0.035,
                        color: Colors.black87,
                      ),
                      SizedBox(width: displayWidth(context) * 0.01),
                      Text(
                        'Tolak',
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.032,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: displayWidth(context) * 0.02),
              // Setujui button
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: displayWidth(context) * 0.04,
                    vertical: displayHeight(context) * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB04A50),
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.05,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        size: displayWidth(context) * 0.035,
                        color: Colors.white,
                      ),
                      SizedBox(width: displayWidth(context) * 0.01),
                      Text(
                        'Setujui',
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.032,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
