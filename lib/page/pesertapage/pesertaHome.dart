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
  bool _sudahIsiLaporan = false;
  String _waktuMasuk = "";
  String? _waktuKeluar;
  String _statusAbsen = "";
  String _namaLengkap = "";
  List<dynamic> _tugasAktif = [];
  Timer? _pollingTimer;
  int _unreadNotifCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchHomeData();
    _fetchUnreadNotifCount();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchTugasDataSilent();
      _fetchUnreadNotifCount();
    });
  }

  Future<void> _fetchUnreadNotifCount() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access_token');

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('http://10.0.2.2:8000/api/notifikasi'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['success'] == true) {
            List<dynamic> notifList = data['data'] ?? [];
            int unread = notifList.where((n) => n['is_read'] == false).length;
            if (mounted && _unreadNotifCount != unread) {
              setState(() {
                _unreadNotifCount = unread;
              });
            }
          }
        }
      } catch (e) {
        // ignore
      }
    }
  }

  Future<void> _fetchTugasDataSilent() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access_token');

    if (token != null) {
      try {
        final responseTugas = await http.get(
          Uri.parse('http://10.0.2.2:8000/api/peserta/penugasan'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        if (responseTugas.statusCode == 200) {
          final dataTugas = jsonDecode(responseTugas.body);
          if (dataTugas['success'] == true) {
            List<dynamic> newTugasList = dataTugas['data'] ?? [];
            if (mounted) {
              if (newTugasList.length != _tugasAktif.length) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Ada pembaruan pada data Tugas Aktif Anda!',
                    ),
                    backgroundColor: const Color(0xFF1976D2),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
              setState(() {
                _tugasAktif = newTugasList;
              });
            }
          }
        }
      } catch (e) {
        // Abaikan error saat polling di background
      }
    }
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

        final responseTugas = await http.get(
          Uri.parse('http://10.0.2.2:8000/api/peserta/penugasan'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          List<dynamic> tugasList = [];
          if (responseTugas.statusCode == 200) {
            final dataTugas = jsonDecode(responseTugas.body);
            if (dataTugas['success'] == true) {
              tugasList = dataTugas['data'] ?? [];
            }
          }

          if (mounted) {
            setState(() {
              _sudahAbsen = data['sudah_absen'] ?? false;
              _sudahIsiLaporan = data['sudah_isi_laporan'] ?? false;
              _waktuMasuk = data['batas_waktu_absen'] ?? "08:00";

              if (_sudahAbsen && data['absen_hari_ini'] != null) {
                _waktuKeluar = data['absen_hari_ini']['waktu_keluar'];
                _statusAbsen = data['absen_hari_ini']['status'] ?? "";
              }
              if (data['data'] != null) {
                _namaLengkap = data['data']['nama_lengkap'] ?? "Peserta";
              }
              _tugasAktif = tugasList;
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
    setState(() {
      _isAbsenLoading = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception(
          'Layanan lokasi (GPS) tidak aktif. Silakan aktifkan terlebih dahulu.',
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Izin lokasi ditolak.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Izin lokasi ditolak secara permanen. Silakan atur di pengaturan perangkat.',
        );
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final result = await PesertaService.absen(
        'hadir',
        position.latitude.toString(),
        position.longitude.toString(),
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
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAbsenLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
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
        setState(() {
          _sudahIsiLaporan = true;
        });

        // Refresh data keseluruhan halaman setelah laporan berhasil
        _fetchHomeData();
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AktifitasTerbaru(),
                          ),
                        ).then((_) {
                          _fetchUnreadNotifCount();
                        });
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            Icons.notifications_none,
                            color: Colors.black87,
                            size: displayWidth(context) * 0.06,
                          ),
                          if (_unreadNotifCount > 0)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEA6E7D),
                                  shape: BoxShape.circle,
                                ),
                                constraints: BoxConstraints(
                                  minWidth: displayWidth(context) * 0.035,
                                  minHeight: displayWidth(context) * 0.035,
                                ),
                                child: Center(
                                  child: Text(
                                    '$_unreadNotifCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: displayHeight(context) * 0.04),

                // Greeting
                _isFetchingData
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: displayWidth(context) * 0.4,
                          height: displayWidth(context) * 0.04,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              displayWidth(context) * 0.01,
                            ),
                          ),
                        ),
                      )
                    : Text(
                        "${_getGreeting()}, $_namaLengkap!",
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
                            "PRESENSI",
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
                            child: _isFetchingData
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: displayWidth(context) * 0.12,
                                      height: displayWidth(context) * 0.03,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    _waktuMasuk.isNotEmpty
                                        ? " Batas Presensi: $_waktuMasuk WIB"
                                        : "Batas Presensi: 09:00 WIB",
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
                      _isFetchingData
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: displayWidth(context) * 0.4,
                                height: displayWidth(context) * 0.05,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    displayWidth(context) * 0.01,
                                  ),
                                ),
                              ),
                            )
                          : Text(
                              !_sudahAbsen
                                  ? "Belum Presensi"
                                  : (_statusAbsen == 'alpa'
                                        ? "Alpa (Tanpa Keterangan)"
                                        : ((_statusAbsen == 'izin' ||
                                                  _statusAbsen == 'sakit')
                                              ? "Izin/Sakit Disetujui"
                                              : (_waktuKeluar == null
                                                    ? (_statusAbsen == 'telat'
                                                          ? "Sudah Presensi (Terlambat)"
                                                          : "Sudah Presensi Hadir")
                                                    : (_statusAbsen == 'telat'
                                                          ? "Sudah Presensi (Terlambat)"
                                                          : "Sudah Presensi")))),
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
                                (_sudahAbsen &&
                                    (_waktuKeluar != null ||
                                        _statusAbsen == 'izin' ||
                                        _statusAbsen == 'sakit' ||
                                        _statusAbsen == 'alpa')))
                            ? null
                            : _submitAbsen,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE84C63), // Red color
                          disabledBackgroundColor:
                              (_sudahAbsen &&
                                  (_waktuKeluar != null ||
                                      _statusAbsen == 'izin' ||
                                      _statusAbsen == 'sakit' ||
                                      _statusAbsen == 'alpa'))
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
                                                _waktuKeluar == null &&
                                                !(_statusAbsen == 'izin' ||
                                                    _statusAbsen == 'sakit')))
                                        ? Icons.fingerprint
                                        : Icons.check_circle,
                                    color: Colors.white,
                                    size: displayWidth(context) * 0.045,
                                  ),
                                  SizedBox(width: displayWidth(context) * 0.02),
                                  Text(
                                    !_sudahAbsen
                                        ? "Presensi Sekarang"
                                        : (_statusAbsen == 'alpa'
                                              ? "Absen Hari Ini Ditutup"
                                              : ((_statusAbsen == 'izin' ||
                                                        _statusAbsen == 'sakit')
                                                    ? "Sudah Tercatat Izin/Sakit"
                                                    : (_waktuKeluar == null
                                                          ? "Presensi Pulang"
                                                          : "Sudah Presensi Hari Ini"))),
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.035,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      if (!_isFetchingData && !_sudahAbsen) ...[
                        SizedBox(height: displayHeight(context) * 0.01),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PersuratanPeserta(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Tidak hadir hari ini? Ajukan Izin/Sakit',
                              style: TextStyle(
                                fontSize: displayWidth(context) * 0.03,
                                color: const Color(0xFFE84C63),
                                decoration: TextDecoration.underline,
                                decorationColor: const Color(0xFFE84C63),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (_sudahAbsen && _waktuKeluar != null) ...[
                        SizedBox(height: displayHeight(context) * 0.015),
                        ElevatedButton(
                          onPressed: _sudahIsiLaporan
                              ? null
                              : _showLaporanDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            disabledBackgroundColor: Colors.grey[400],
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
                                _sudahIsiLaporan
                                    ? Icons.check_circle
                                    : Icons.edit_document,
                                color: Colors.white,
                                size: displayWidth(context) * 0.045,
                              ),
                              SizedBox(width: displayWidth(context) * 0.02),
                              Text(
                                _sudahIsiLaporan
                                    ? "Laporan Harian Terkirim"
                                    : "Isi Laporan Harian",
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TugasSayaPeserta(),
                          ),
                        );
                      },
                      child: Text(
                        "LIHAT SEMUA",
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.03,
                          fontWeight: FontWeight.bold,
                          color: const Color(
                            0xFF983A46,
                          ), // Darker red as per image
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: displayHeight(context) * 0.02),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    children: _isFetchingData
                        ? List.generate(
                            2,
                            (index) => Padding(
                              padding: EdgeInsets.only(
                                right: displayWidth(context) * 0.04,
                              ),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: displayWidth(context) * 0.6,
                                  height: displayHeight(context) * 0.15,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      displayWidth(context) * 0.03,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : _tugasAktif
                              .where((t) => t['status_tugas'] != 'Selesai')
                              .isEmpty
                        ? [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: displayWidth(context) * 0.04,
                              ),
                              child: Text(
                                "Belum ada tugas aktif",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ]
                        : _tugasAktif
                              .where((t) => t['status_tugas'] != 'Selesai')
                              .take(5)
                              .map((tugas) {
                                Color tagColor = const Color(0xFFE3F2FD);
                                Color tagTextColor = const Color(0xFF1976D2);
                                String tag = "AKTIF";

                                if (tugas['status_tugas'] == 'Revisi') {
                                  tagColor = const Color(0xFFFFEBEE);
                                  tagTextColor = const Color(0xFFD32F2F);
                                  tag = "REVISI";
                                } else if (tugas['status_tugas'] ==
                                    'Ditinjau') {
                                  tagColor = const Color(0xFFFFF3E0);
                                  tagTextColor = const Color(0xFFF57C00);
                                  tag = "DITINJAU";
                                }

                                return Padding(
                                  padding: EdgeInsets.only(
                                    right: displayWidth(context) * 0.04,
                                  ),
                                  child: _buildTugasCard(
                                    context,
                                    tag: tag,
                                    tagColor: tagColor,
                                    tagTextColor: tagTextColor,
                                    title: tugas['judul_tugas'] ?? '-',
                                    description: tugas['deskripsi'] ?? '-',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailTugasPeserta(task: tugas),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              })
                              .toList(),
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
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
