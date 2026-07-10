part of '../../conn/auth.dart';

class PesertaHome extends StatefulWidget {
  const PesertaHome({super.key});
  @override
  State<PesertaHome> createState() => PesertaHomeState();
}

class PesertaHomeState extends State<PesertaHome> {
  bool _isAbsenLoading = false;
  bool _isFetchingData = true;
  bool _sudahAbsen = false;
  String _waktuMasuk = "";
  String? _waktuKeluar;
  String _namaLengkap = "";

  @override
  void initState() {
    super.initState();
    _fetchHomeData();
  }

  Future<void> _fetchHomeData() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access_token');

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('http://10.0.2.2:8000/api/user'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (mounted) {
            setState(() {
              _sudahAbsen = data['sudah_absen'] ?? false;
              if (_sudahAbsen && data['absen_hari_ini'] != null) {
                _waktuMasuk = data['absen_hari_ini']['waktu_masuk'] ?? "";
                _waktuKeluar = data['absen_hari_ini']['waktu_keluar'];
              }
              if (data['data'] != null) {
                _namaLengkap = data['data']['nama_lengkap'] ?? "Peserta";
              }
              _isFetchingData = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _isFetchingData = false;
            });
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isFetchingData = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _isFetchingData = false;
        });
      }
    }
  }

  Future<void> _submitAbsen() async {
    //sudah berhasil, namun masih static isian absennya
    setState(() {
      _isAbsenLoading = true;
    });

    final result = await PesertaService.absen(
      'hadir',
      '-6.200000',
      '106.816666',
    );

    if (mounted) {
      setState(() {
        _isAbsenLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result['message'].toString())));

      if (result['success'] == true) {
        _fetchHomeData();
      }
    }
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 11) {
      return "Selamat Pagi";
    } else if (hour < 15) {
      return "Selamat Siang";
    } else if (hour < 18) {
      return "Selamat Sore";
    } else {
      return "Selamat Malam";
    }
  }

  Future<void> _submitLaporan(String isiLaporan) async {
    if (isiLaporan.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Laporan tidak boleh kosong!"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Tampilkan loading overlay
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/laporan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'laporan': isiLaporan}),
      );

      Navigator.pop(context); // Tutup loading overlay

      if (response.statusCode == 201 || response.statusCode == 200) {
        Navigator.pop(context); // Tutup dialog laporan
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Laporan harian berhasil dikirim!"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal mengirim laporan!"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Tutup loading overlay
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan: $e"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showLaporanDialog() {
    TextEditingController _laporanController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
          ),
          title: Text(
            "Laporan Harian",
            style: TextStyle(
              fontSize: displayWidth(context) * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: _laporanController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Tuliskan kegiatan magang Anda hari ini...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  displayWidth(context) * 0.02,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
              },
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                _submitLaporan(_laporanController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
              ),
              child: const Text("Kirim", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Very light grey background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: displayWidth(context) * 0.05,
              right: displayWidth(context) * 0.05,
              bottom: displayHeight(context) * 0.15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: displayHeight(context) * 0.03),
                // Header (Logo and Notification)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "v",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.065,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              letterSpacing: -1.0,
                            ),
                          ),
                          TextSpan(
                            text: "o",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.065,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFE84C63), // Red
                              letterSpacing: -1.0,
                            ),
                          ),
                          TextSpan(
                            text: "casia",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.065,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              letterSpacing: -1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.notifications_none,
                      color: Colors.black87,
                      size: displayWidth(context) * 0.06,
                    ),
                  ],
                ),
                SizedBox(height: displayHeight(context) * 0.04),

                // Greeting
                Text(
                  _isFetchingData
                      ? "Loading..."
                      : "${_getGreeting()}, $_namaLengkap!",
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.035,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.01),
                Text(
                  "Semangat Magang Hari Ini!",
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.055,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.03),

                // Status Presensi Card
                Container(
                  padding: EdgeInsets.all(displayWidth(context) * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.03,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "STATUS PRESENSI",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.028,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[500],
                              letterSpacing: 0.5,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: displayWidth(context) * 0.03,
                              vertical: displayHeight(context) * 0.005,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(
                                displayWidth(context) * 0.04,
                              ),
                            ),
                            child: Text(
                              _isFetchingData
                                  ? "--:--"
                                  : (_waktuMasuk.isNotEmpty
                                        ? "$_waktuMasuk WIB"
                                        : "09:00 WIB"),
                              style: TextStyle(
                                fontSize: displayWidth(context) * 0.028,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: displayHeight(context) * 0.01),
                      Text(
                        _isFetchingData
                            ? "Loading..."
                            : (!_sudahAbsen
                                  ? "Belum Presensi"
                                  : (_waktuKeluar == null
                                        ? "Sudah Presensi Hadir"
                                        : "Sudah Presensi")),
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: displayHeight(context) * 0.02),
                      ElevatedButton(
                        onPressed:
                            (_isFetchingData ||
                                _isAbsenLoading ||
                                (_sudahAbsen && _waktuKeluar != null))
                            ? null
                            : _submitAbsen,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE84C63), // Red color
                          disabledBackgroundColor:
                              (_sudahAbsen && _waktuKeluar != null)
                              ? Colors.grey[400]
                              : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              displayWidth(context) * 0.025,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: displayHeight(context) * 0.018,
                          ),
                          elevation: 0,
                          minimumSize: const Size(
                            double.infinity,
                            0,
                          ), // Full width
                        ),
                        child: _isAbsenLoading
                            ? SizedBox(
                                height: displayHeight(context) * 0.025,
                                width: displayHeight(context) * 0.025,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    (!_sudahAbsen ||
                                            (_sudahAbsen &&
                                                _waktuKeluar == null))
                                        ? Icons.fingerprint
                                        : Icons.check_circle,
                                    color: Colors.white,
                                    size: displayWidth(context) * 0.045,
                                  ),
                                  SizedBox(width: displayWidth(context) * 0.02),
                                  Text(
                                    !_sudahAbsen
                                        ? "Presensi Sekarang"
                                        : (_waktuKeluar == null
                                              ? "Presensi Pulang"
                                              : "Sudah Presensi Hari Ini"),
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.035,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      if (_sudahAbsen && _waktuKeluar != null) ...[
                        SizedBox(height: displayHeight(context) * 0.015),
                        ElevatedButton(
                          onPressed: _showLaporanDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                displayWidth(context) * 0.025,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: displayHeight(context) * 0.018,
                            ),
                            elevation: 0,
                            minimumSize: const Size(double.infinity, 0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit_document,
                                color: Colors.white,
                                size: displayWidth(context) * 0.045,
                              ),
                              SizedBox(width: displayWidth(context) * 0.02),
                              Text(
                                "Isi Laporan Harian",
                                style: TextStyle(
                                  fontSize: displayWidth(context) * 0.035,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.04),

                // Tugas Aktif Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tugas Aktif",
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "LIHAT SEMUA",
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.03,
                        fontWeight: FontWeight.bold,
                        color: const Color(
                          0xFF983A46,
                        ), // Darker red as per image
                      ),
                    ),
                  ],
                ),
                SizedBox(height: displayHeight(context) * 0.02),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    children: [
                      _buildTugasCard(
                        context,
                        tag: "DEVELOPMENT",
                        tagColor: const Color(0xFFFDE8EB), // Light red bg
                        tagTextColor: const Color(0xFF983A46),
                        title: "Implementasi API",
                        description: "Integrasi endpoint dashboard...",
                      ),
                      SizedBox(width: displayWidth(context) * 0.04),
                      _buildTugasCard(
                        context,
                        tag: "DESIGN",
                        tagColor: const Color(
                          0xFFFDF4E6,
                        ), // Light yellow/orange bg
                        tagTextColor: const Color(
                          0xFF8B6508,
                        ), // Dark golden/brown text
                        title: "Desain UI",
                        description: "High-fidelity prototype...",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.04),

                // Ringkasan Mingguan Section
                Text(
                  "Ringkasan Mingguan",
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.02),
                Row(
                  children: [
                    Expanded(
                      child: _buildRingkasanCard(
                        context,
                        icon: Icons.check_circle_outline,
                        iconColor: const Color(0xFF983A46),
                        iconBgColor: const Color(0xFFF9EAEB), // Light pinkish
                        value: "12",
                        label: "SELESAI",
                      ),
                    ),
                    SizedBox(width: displayWidth(context) * 0.04),
                    Expanded(
                      child: _buildRingkasanCard(
                        context,
                        icon: Icons.calendar_today_outlined,
                        iconColor: const Color(0xFF8B6508),
                        iconBgColor: const Color(0xFFFDF4E6), // Light yellowish
                        value: "04",
                        label: "KEHADIRAN",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTugasCard(
    BuildContext context, {
    required String tag,
    required Color tagColor,
    required Color tagTextColor,
    required String title,
    required String description,
  }) {
    return Container(
      width: displayWidth(context) * 0.6,
      padding: EdgeInsets.all(displayWidth(context) * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: displayWidth(context) * 0.02,
                  vertical: displayHeight(context) * 0.003,
                ),
                decoration: BoxDecoration(
                  color: tagColor,
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.01,
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.02,
                    fontWeight: FontWeight.bold,
                    color: tagTextColor,
                  ),
                ),
              ),
              Icon(
                Icons.more_vert,
                size: displayWidth(context) * 0.04,
                color: Colors.grey[600],
              ),
            ],
          ),
          SizedBox(height: displayHeight(context) * 0.02),
          Text(
            title,
            style: TextStyle(
              fontSize: displayWidth(context) * 0.04,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: displayHeight(context) * 0.005),
          Text(
            description,
            style: TextStyle(
              fontSize: displayWidth(context) * 0.03,
              color: Colors.grey[500],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: displayHeight(context) * 0.03),
        ],
      ),
    );
  }

  Widget _buildRingkasanCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.all(displayWidth(context) * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(displayWidth(context) * 0.02),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(displayWidth(context) * 0.02),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: displayWidth(context) * 0.05,
            ),
          ),
          SizedBox(height: displayHeight(context) * 0.015),
          Text(
            value,
            style: TextStyle(
              fontSize: displayWidth(context) * 0.07,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: displayWidth(context) * 0.025,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
