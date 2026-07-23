part of '../../../conn/auth.dart';

class LaporanPesertaMentor extends StatefulWidget {
  const LaporanPesertaMentor({super.key});

  @override
  State<LaporanPesertaMentor> createState() => _LaporanPesertaMentorState();
}

class _LaporanPesertaMentorState extends State<LaporanPesertaMentor> {
  // State variables for form
  String? selectedPesertaId;
  String? selectedPesertaName;
  List<Map<String, dynamic>> listPeserta = [];
  bool _isLoadingPeserta = true;

  bool hasSearched = false;
  bool _isSearching = false;
  List<dynamic> hasilPencarian = [];

  @override
  void initState() {
    super.initState();
    _fetchPeserta();
  }

  Future<void> _fetchPeserta() async {
    try {
      final result = await MentorService.getPesertaAbsensi();
      if (result['success']) {
        if (mounted) {
          setState(() {
            listPeserta = List<Map<String, dynamic>>.from(result['data']);
            if (listPeserta.isNotEmpty) {
              selectedPesertaId = listPeserta.first['id'].toString();
              selectedPesertaName = listPeserta.first['nama_lengkap'];
            }
            _isLoadingPeserta = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => _isLoadingPeserta = false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingPeserta = false);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildShimmerLaporanCard() {
    return Container(
      margin: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
      width: double.infinity,
      padding: EdgeInsets.all(displayWidth(context) * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: displayWidth(context) * 0.08,
                      height: displayWidth(context) * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          displayWidth(context) * 0.02,
                        ),
                      ),
                    ),
                    SizedBox(width: displayWidth(context) * 0.03),
                    Container(
                      width: displayWidth(context) * 0.2,
                      height: displayWidth(context) * 0.04,
                      color: Colors.white,
                    ),
                  ],
                ),
                Container(
                  width: displayWidth(context) * 0.2,
                  height: displayWidth(context) * 0.06,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.05,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: displayHeight(context) * 0.02),
            Container(
              width: double.infinity,
              height: displayHeight(context) * 0.1,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  displayWidth(context) * 0.02,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLaporanCard(dynamic laporan) {
    String namaPeserta = laporan['nama_peserta'] ?? 'Tanpa Nama';
    String isiLaporan = laporan['laporan'] ?? '-';
    String tanggal = laporan['tanggal'] ?? '-';

    // Parse tanggal if possible
    String formattedTanggal = tanggal;
    if (tanggal != '-') {
      try {
        DateTime parsed = DateTime.parse(tanggal);
        List<String> months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'Mei',
          'Jun',
          'Jul',
          'Agu',
          'Sep',
          'Okt',
          'Nov',
          'Des',
        ];
        formattedTanggal =
            "${parsed.day} ${months[parsed.month - 1]} ${parsed.year}";
      } catch (e) {
        // keep as is
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: displayWidth(context) * 0.015,
                color: const Color(0xFFE84C63),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(displayWidth(context) * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            radius: displayWidth(context) * 0.055,
                            child: Icon(
                              Icons.person,
                              color: Colors.grey[600],
                              size: displayWidth(context) * 0.07,
                            ),
                          ),
                          SizedBox(width: displayWidth(context) * 0.03),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  namaPeserta,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: displayWidth(context) * 0.04,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(
                                  height: displayHeight(context) * 0.003,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: displayWidth(context) * 0.03,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(
                                      width: displayWidth(context) * 0.015,
                                    ),
                                    Text(
                                      formattedTanggal,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: displayWidth(context) * 0.03,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: displayHeight(context) * 0.02),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(displayWidth(context) * 0.04),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(
                            displayWidth(context) * 0.02,
                          ),
                        ),
                        child: Text(
                          '"$isiLaporan"',
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.035,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ),
                      if (laporan['komentar_mentor'] != null) ...[
                        SizedBox(height: displayHeight(context) * 0.01),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(displayWidth(context) * 0.03),
                          decoration: BoxDecoration(
                            color: Colors.yellow[100],
                            borderRadius: BorderRadius.circular(
                              displayWidth(context) * 0.02,
                            ),
                          ),
                          child: Text(
                            'Komentar Anda: ${laporan['komentar_mentor']}',
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.03,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: displayHeight(context) * 0.02),
                      Divider(color: Colors.grey.shade300),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            print(
                              "Tap Beri Komentar on Laporan ID: ${laporan['id']}",
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: displayHeight(context) * 0.005,
                            ),
                            child: Text(
                              "Beri Komentar >",
                              style: TextStyle(
                                color: const Color(0xFFE84C63),
                                fontWeight: FontWeight.bold,
                                fontSize: displayWidth(context) * 0.035,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk melakukan pencarian
  Future<void> _searchLaporan() async {
    if (selectedPesertaId == null) return;
    setState(() {
      _isSearching = true;
      hasSearched = false;
    });

    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/mentor/laporan/$selectedPesertaId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> hasilPencarianBaru = data['data'];

        if (mounted) {
          setState(() {
            hasilPencarian = hasilPencarianBaru;
            hasSearched = true;
            _isSearching = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => _isSearching = false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text(
          'Laporan Harian',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(displayWidth(context) * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter Card
              Container(
                padding: EdgeInsets.all(displayWidth(context) * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.04,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pilih Peserta
                    Text(
                      'Pilih Peserta',
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.035,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.01),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: displayWidth(context) * 0.03,
                        vertical: displayHeight(context) * 0.005,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(
                          displayWidth(context) * 0.02,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: _isLoadingPeserta
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: displayHeight(context) * 0.015,
                                ),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: displayWidth(context) * 0.05,
                                            height:
                                                displayWidth(context) * 0.05,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(
                                            width: displayWidth(context) * 0.03,
                                          ),
                                          Container(
                                            width: displayWidth(context) * 0.4,
                                            height:
                                                displayWidth(context) * 0.035,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.white,
                                        size: displayWidth(context) * 0.06,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : DropdownButton<String>(
                                isExpanded: true,
                                value: selectedPesertaId,
                                hint: Text(
                                  "Pilih Peserta",
                                  style: TextStyle(
                                    fontSize: displayWidth(context) * 0.035,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black87,
                                  size: displayWidth(context) * 0.06,
                                ),
                                items: listPeserta.map((peserta) {
                                  return DropdownMenuItem<String>(
                                    value: peserta['id'].toString(),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: Colors.grey[600],
                                          size: displayWidth(context) * 0.05,
                                        ),
                                        SizedBox(
                                          width: displayWidth(context) * 0.03,
                                        ),
                                        Text(
                                          peserta['nama_lengkap'] ??
                                              'Tanpa Nama',
                                          style: TextStyle(
                                            fontSize:
                                                displayWidth(context) * 0.035,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedPesertaId = newValue;
                                    final selected = listPeserta.firstWhere(
                                      (p) => p['id'].toString() == newValue,
                                    );
                                    selectedPesertaName =
                                        selected['nama_lengkap'];
                                  });
                                },
                              ),
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.03),

                    // Button Cari Laporan
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _searchLaporan,
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: displayWidth(context) * 0.05,
                        ),
                        label: Text(
                          'Cari Laporan',
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE84C63),
                          padding: EdgeInsets.symmetric(
                            vertical: displayHeight(context) * 0.018,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              displayWidth(context) * 0.05,
                            ),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Hasil Pencarian Section
              if (_isSearching) ...[
                SizedBox(height: displayHeight(context) * 0.04),
                _buildShimmerLaporanCard(),
                _buildShimmerLaporanCard(),
              ] else if (hasSearched) ...[
                SizedBox(height: displayHeight(context) * 0.04),
                Text(
                  'Hasil Pencarian',
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.02),

                if (hasilPencarian.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(displayWidth(context) * 0.05),
                      child: Text(
                        "Tidak ada laporan harian untuk peserta tersebut.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: displayWidth(context) * 0.035,
                        ),
                      ),
                    ),
                  ),

                for (var laporan in hasilPencarian) _buildLaporanCard(laporan),
              ],
              SizedBox(height: displayHeight(context) * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
