part of '../../../conn/auth.dart';

class AbsensiPesertaMentor extends StatefulWidget {
  const AbsensiPesertaMentor({super.key});

  @override
  State<AbsensiPesertaMentor> createState() => _AbsensiPesertaMentorState();
}

class _AbsensiPesertaMentorState extends State<AbsensiPesertaMentor> {
  List<dynamic> absensiList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final result = await MentorService.getPesertaAbsensi();
    if (mounted) {
      if (result['success']) {
        setState(() {
          absensiList = result['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Gagal memuat data')),
        );
      }
    }
  }

  Widget _buildAbsensiCard(dynamic data) {
    if (data is! Map) return const SizedBox.shrink();

    String name = data['nama_lengkap']?.toString() ?? 'Tanpa Nama';
    bool sudahAbsenMasuk = data['sudah_absen_masuk'] == true;
    var absenInfo = data['absen_hari_ini'];

    String statusText = "Belum Presensi";
    IconData statusIcon = Icons.close;
    Color iconColor = Colors.grey;

    if (sudahAbsenMasuk && absenInfo != null) {
      if (absenInfo['status'] == 'hadir') {
        String _formatTime(String? timeStr) {
          if (timeStr == null || timeStr.isEmpty) return 'Belum';
          var parts = timeStr.split(':');
          return parts.length >= 2 ? '${parts[0]}:${parts[1]}' : timeStr;
        }

        String masuk = _formatTime(absenInfo['waktu_masuk']?.toString());
        if (masuk == 'Belum') masuk = '-';
        String keluar = _formatTime(absenInfo['waktu_keluar']?.toString());

        statusText = "Masuk: $masuk | Pulang: $keluar";
        statusIcon = (absenInfo['waktu_keluar'] != null)
            ? Icons.done_all
            : Icons.check;
        iconColor = (absenInfo['waktu_keluar'] != null)
            ? Colors.blue
            : Colors.green;
      } else if (absenInfo['status'] == 'izin') {
        statusText = "Izin : " + (absenInfo['keterangan']?.toString() ?? '-');
        statusIcon = Icons.priority_high;
        iconColor = Colors.orange;
      } else if (absenInfo['status'] == 'sakit') {
        statusText = "Sakit : " + (absenInfo['keterangan']?.toString() ?? '-');
        statusIcon = Icons.local_hospital;
        iconColor = Colors.red;
      }
    }

    bool hasSubtitle = statusText.isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: displayHeight(context) * 0.015),
      padding: EdgeInsets.symmetric(
        horizontal: displayWidth(context) * 0.04,
        vertical: displayHeight(context) * 0.015,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(displayWidth(context) * 0.02),
            decoration: const BoxDecoration(
              color: Color(0xFFEA6E7D),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: displayWidth(context) * 0.06,
            ),
          ),
          SizedBox(width: displayWidth(context) * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.035,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                if (hasSubtitle)
                  SizedBox(height: displayHeight(context) * 0.005),
                if (hasSubtitle)
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.03,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          Icon(
            statusIcon,
            color: iconColor,
            size: displayWidth(context) * 0.05,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String hour = now.hour.toString().padLeft(2, '0');
    String minute = now.minute.toString().padLeft(2, '0');
    List<String> months = [
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
    String day = now.day.toString();
    String month = months[now.month - 1];
    String year = now.year.toString();

    int totalPeserta = absensiList.length;
    int sudahAbsen = absensiList.where((p) {
      if (p is Map) {
        return p['sudah_absen_masuk'] == true;
      }
      return false;
    }).length;
    int sudahAbsenKeluar = absensiList.where((p) {
      if (p is Map) {
        return p['sudah_absen_pulang'] == true || (p['absen_hari_ini'] != null && p['absen_hari_ini']['waktu_keluar'] != null);
      }
      return false;
    }).length;

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Absensi Peserta",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: displayWidth(context) * 0.05,
          ),
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: displayWidth(context) * 0.06,
          ),
          child: Column(
            children: [
              SizedBox(height: displayHeight(context) * 0.01),

              // --- BAGIAN ATAS (STATIC) ---

              // Card Waktu & Tanggal
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: displayHeight(context) * 0.03,
                  horizontal: displayWidth(context) * 0.04,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.04,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Jam
                        Column(
                          children: [
                            Text(
                              "$hour:$minute",
                              style: TextStyle(
                                fontSize: displayWidth(context) * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "WIB",
                              style: TextStyle(
                                fontSize: displayWidth(context) * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        // Garis Merah
                        Container(
                          height: displayHeight(context) * 0.06,
                          width: 2,
                          color: const Color(0xFFEA6E7D),
                        ),

                        // Tanggal
                        Column(
                          children: [
                            Text(
                              "$day $month",
                              style: TextStyle(
                                fontSize: displayWidth(context) * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              year,
                              style: TextStyle(
                                fontSize: displayWidth(context) * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: displayHeight(context) * 0.02),
                    // Ringkasan Kehadiran
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                            displayWidth(context) * 0.015,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFFEA6E7D),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.people,
                            color: Colors.white,
                            size: displayWidth(context) * 0.04,
                          ),
                        ),
                        SizedBox(width: displayWidth(context) * 0.03),
                        Text(
                          "$sudahAbsen dari $totalPeserta peserta sudah absen masuk",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.03,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: displayHeight(context) * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                            displayWidth(context) * 0.015,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.directions_run,
                            color: Colors.white,
                            size: displayWidth(context) * 0.04,
                          ),
                        ),
                        SizedBox(width: displayWidth(context) * 0.03),
                        Text(
                          "$sudahAbsenKeluar dari $totalPeserta peserta sudah absen keluar",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.03,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.02),
              // Garis Pemisah Tipis
              Divider(color: Colors.grey[400], thickness: 1),
              SizedBox(height: displayHeight(context) * 0.02),
              // Search Bar
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: displayWidth(context) * 0.02,
                  vertical: displayHeight(context) * 0.005,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.08,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(displayWidth(context) * 0.015),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEA6E7D),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: displayWidth(context) * 0.04,
                      ),
                    ),
                    SizedBox(width: displayWidth(context) * 0.03),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Cari Nama Peserta",
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: displayWidth(context) * 0.035,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.02),

              // --- BAGIAN BAWAH (DINAMIS - UNTUK API) ---

              // List of Peserta Absensi
              Expanded(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : absensiList.isEmpty
                    ? Center(child: Text("Tidak ada peserta magang"))
                    : ListView.builder(
                        itemCount: absensiList.length,
                        itemBuilder: (context, index) {
                          return _buildAbsensiCard(absensiList[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
