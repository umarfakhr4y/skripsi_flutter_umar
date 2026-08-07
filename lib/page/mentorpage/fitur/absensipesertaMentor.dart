part of '../../../conn/auth.dart';

class AbsensiPesertaMentor extends StatefulWidget {
  const AbsensiPesertaMentor({super.key});

  @override
  State<AbsensiPesertaMentor> createState() => _AbsensiPesertaMentorState();
}

class _AbsensiPesertaMentorState extends State<AbsensiPesertaMentor> {
  List<dynamic> absensiList = [];
  bool _isLoading = true;
  Timer? _pollingTimer;
  String _batasAbsenSekarang = "08:00";
  String? _batasAbsenMendatang;
  String? _tanggalBatasMendatang;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _fetchData(silent: true);
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
      });
    }
    final result = await MentorService.getPesertaAbsensi();
    final pengaturanRes = await MentorService.getPengaturanAbsen();
    if (mounted) {
      if (pengaturanRes['success'] == true) {
        setState(() {
          _batasAbsenSekarang =
              pengaturanRes['batas_waktu_sekarang']?.toString().substring(
                0,
                5,
              ) ??
              '08:00';
          _batasAbsenMendatang = pengaturanRes['batas_waktu_mendatang']
              ?.toString()
              .substring(0, 5);
          _tanggalBatasMendatang = pengaturanRes['tanggal_berlaku_mendatang']
              ?.toString();
        });
      }
      if (result['success']) {
        if (silent && absensiList.isNotEmpty && result['data'] is List) {
          _checkRealtimeChanges(absensiList, result['data']);
        }
        setState(() {
          absensiList = result['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        if (!silent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Gagal memuat data')),
          );
        }
      }
    }
  }

  void _checkRealtimeChanges(List<dynamic> oldList, List<dynamic> newList) {
    List<String> changes = [];

    for (var newItem in newList) {
      if (newItem is! Map) continue;
      final oldItem = oldList.cast<dynamic>().firstWhere(
        (item) =>
            item is Map &&
            ((item['id'] != null && item['id'] == newItem['id']) ||
                item['nama_lengkap'] == newItem['nama_lengkap']),
        orElse: () => null,
      );

      if (oldItem != null && oldItem is Map) {
        String name = newItem['nama_lengkap']?.toString() ?? 'Peserta';
        bool oldMasuk = oldItem['sudah_absen_masuk'] == true;
        bool newMasuk = newItem['sudah_absen_masuk'] == true;
        bool oldPulang = oldItem['sudah_absen_pulang'] == true;
        bool newPulang = newItem['sudah_absen_pulang'] == true;

        if (!oldMasuk && newMasuk) {
          changes.add("$name baru saja presensi masuk");
        } else if (!oldPulang && newPulang) {
          changes.add("$name baru saja presensi pulang");
        }
      }
    }

    if (changes.isNotEmpty && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.notifications_active,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "${changes.join(', ')}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFAD3B3E),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _editBatasAbsen() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.tryParse(_batasAbsenSekarang.split(':')[0]) ?? 8,
        minute: int.tryParse(_batasAbsenSekarang.split(':')[1]) ?? 0,
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null && mounted) {
      String formattedTime =
          '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final res = await MentorService.setPengaturanAbsen(formattedTime);

      if (mounted) {
        Navigator.pop(context); // close loading
        if (res['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message'] ?? 'Berhasil disimpan!')),
          );
          _fetchData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message'] ?? 'Gagal menyimpan')),
          );
        }
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
    String? latitude;
    String? longitude;

    if (sudahAbsenMasuk && absenInfo != null) {
      latitude = absenInfo['latitude']?.toString();
      longitude = absenInfo['longitude']?.toString();
      if (absenInfo['status'] == 'hadir' || absenInfo['status'] == 'telat') {
        String _formatTime(String? timeStr) {
          if (timeStr == null || timeStr.isEmpty) return 'Belum';
          var parts = timeStr.split(':');
          return parts.length >= 2 ? '${parts[0]}:${parts[1]}' : timeStr;
        }

        String masuk = _formatTime(absenInfo['waktu_masuk']?.toString());
        if (masuk == 'Belum') masuk = '-';
        String keluar = _formatTime(absenInfo['waktu_keluar']?.toString());

        if (absenInfo['status'] == 'telat') {
          statusText = "Terlambat Masuk: $masuk | Pulang: $keluar";
        } else {
          statusText = "Masuk: $masuk | Pulang: $keluar";
        }

        statusIcon = (absenInfo['waktu_keluar'] != null)
            ? Icons.done_all
            : Icons.check;
        iconColor = (absenInfo['waktu_keluar'] != null)
            ? Colors.blue
            : (absenInfo['status'] == 'telat' ? Colors.orange : Colors.green);
      } else if (absenInfo['status'] == 'izin') {
        statusText = "Izin : " + (absenInfo['keterangan']?.toString() ?? '-');
        statusIcon = Icons.priority_high;
        iconColor = Colors.orange;
      } else if (absenInfo['status'] == 'sakit') {
        statusText = "Sakit : " + (absenInfo['keterangan']?.toString() ?? '-');
        statusIcon = Icons.local_hospital;
        iconColor = Colors.red;
      } else if (absenInfo['status'] == 'alpa') {
        statusText = "Alpa (Tanpa Keterangan)";
        statusIcon = Icons.person_off;
        iconColor = Colors.grey;
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
          if (latitude != null && longitude != null)
            IconButton(
              icon: Icon(
                Icons.location_on,
                color: const Color(0xFFEA6E7D),
                size: displayWidth(context) * 0.05,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => MapDialog(
                    latitude: latitude!,
                    longitude: longitude!,
                    namaPeserta: name,
                  ),
                );
              },
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
        return p['sudah_absen_pulang'] == true ||
            (p['absen_hari_ini'] != null &&
                p['absen_hari_ini']['waktu_keluar'] != null);
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
                    Divider(color: Colors.grey[300]),
                    SizedBox(height: displayHeight(context) * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Batas Absen Hari Ini: $_batasAbsenSekarang",
                              style: TextStyle(
                                fontSize: displayWidth(context) * 0.035,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            if (_batasAbsenMendatang != null)
                              Text(
                                "Besok batas absen menjadi $_batasAbsenMendatang",
                                style: TextStyle(
                                  fontSize: displayWidth(context) * 0.03,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ],
                        ),
                        InkWell(
                          onTap: _editBatasAbsen,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: displayWidth(context) * 0.03,
                              vertical: displayHeight(context) * 0.008,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEA6E7D).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                displayWidth(context) * 0.02,
                              ),
                              border: Border.all(
                                color: const Color(0xFFEA6E7D),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit_calendar,
                                  size: displayWidth(context) * 0.04,
                                  color: const Color(0xFFEA6E7D),
                                ),
                                SizedBox(width: displayWidth(context) * 0.01),
                                Text(
                                  "Ubah",
                                  style: TextStyle(
                                    fontSize: displayWidth(context) * 0.03,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFEA6E7D),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: displayHeight(context) * 0.01),
                    Divider(color: Colors.grey[300]),
                    SizedBox(height: displayHeight(context) * 0.01),
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

class MapDialog extends StatefulWidget {
  final String latitude;
  final String longitude;
  final String namaPeserta;

  const MapDialog({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.namaPeserta,
  });

  @override
  State<MapDialog> createState() => _MapDialogState();
}

class _MapDialogState extends State<MapDialog> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final String htmlContent =
        '''
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <style>
      body, html { height: 100%; margin: 0; padding: 0; }
    </style>
  </head>
  <body>
    <iframe 
      width="100%" 
      height="100%" 
      frameborder="0" 
      scrolling="no" 
      marginheight="0" 
      marginwidth="0" 
      src="https://maps.google.com/maps?q=${widget.latitude},${widget.longitude}&z=15&output=embed">
    </iframe>
  </body>
</html>
''';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
        ),
      )
      ..loadHtmlString(htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: EdgeInsets.zero,
      titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "Lokasi: ${widget.namaPeserta}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              child: WebViewWidget(controller: _controller),
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: Color(0xFFEA6E7D)),
              ),
          ],
        ),
      ),
    );
  }
}
