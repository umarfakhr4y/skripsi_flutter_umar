part of '../../../conn/auth.dart';

class RiwayatEvaluasiMentor extends StatefulWidget {
  const RiwayatEvaluasiMentor({super.key});

  @override
  State<RiwayatEvaluasiMentor> createState() => _RiwayatEvaluasiMentorState();
}

class _RiwayatEvaluasiMentorState extends State<RiwayatEvaluasiMentor> {
  String _selectedPesertaId = "";
  String _selectedPesertaName = "Pilih Peserta";
  List<Map<String, dynamic>> _listPeserta = [];
  bool _isLoadingPeserta = true;

  List<dynamic> _evaluations = [];
  bool _isLoadingEvaluasi = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _fetchPeserta();
  }

  Future<void> _fetchPeserta() async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/mentor/peserta'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success'] && mounted) {
          setState(() {
            _listPeserta = List<Map<String, dynamic>>.from(result['data']);
            _isLoadingPeserta = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoadingPeserta = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingPeserta = false);
    }
  }

  Future<void> _fetchRiwayat() async {
    if (_selectedPesertaId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pilih peserta terlebih dahulu"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _hasSearched = true;
      _isLoadingEvaluasi = true;
    });

    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');
      final response = await http.get(
        Uri.parse(
          'http://10.0.2.2:8000/api/mentor/evaluasi/$_selectedPesertaId',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success'] && mounted) {
          setState(() {
            _evaluations = result['data'];
            // add isExpanded false for UI interaction
            for (var eval in _evaluations) {
              eval['isExpanded'] = false;
            }
            _isLoadingEvaluasi = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoadingEvaluasi = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal mengambil riwayat"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingEvaluasi = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildStars(int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < count ? Icons.star : Icons.star_border,
          color: const Color(0xFFE84C63),
          size: displayWidth(context) * 0.035,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE84C63)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Riwayat Evaluasi",
          style: TextStyle(
            color: const Color(0xFFE84C63),
            fontWeight: FontWeight.bold,
            fontSize: displayWidth(context) * 0.05,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: displayWidth(context) * 0.05,
            vertical: displayHeight(context) * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter Peserta Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(displayWidth(context) * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.04,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pilih Peserta",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: displayWidth(context) * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.005),
                    Text(
                      "Pilih Peserta Magang",
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.03,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.02),
                    _isLoadingPeserta
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: displayWidth(context) * 0.03,
                                vertical: displayHeight(context) * 0.015,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  displayWidth(context) * 0.02,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: displayWidth(context) * 0.05,
                                    height: displayWidth(context) * 0.05,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: displayWidth(context) * 0.02),
                                  Expanded(
                                    child: Container(
                                      height: displayHeight(context) * 0.02,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: displayWidth(context) * 0.02),
                                  Container(
                                    width: displayWidth(context) * 0.05,
                                    height: displayWidth(context) * 0.05,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : PopupMenuButton<String>(
                            onSelected: (String id) {
                              setState(() {
                                _selectedPesertaId = id;
                                _selectedPesertaName = _listPeserta.firstWhere(
                                  (p) => p['id'].toString() == id,
                                )['nama_lengkap'];
                                _hasSearched = false;
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return _listPeserta.map((peserta) {
                                return PopupMenuItem<String>(
                                  value: peserta['id'].toString(),
                                  child: Text(peserta['nama_lengkap']),
                                );
                              }).toList();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: displayWidth(context) * 0.03,
                                vertical: displayHeight(context) * 0.015,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(
                                  displayWidth(context) * 0.02,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    color: Colors.grey[700],
                                    size: displayWidth(context) * 0.05,
                                  ),
                                  SizedBox(width: displayWidth(context) * 0.02),
                                  Expanded(
                                    child: Text(
                                      _selectedPesertaName,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: displayWidth(context) * 0.035,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey[700],
                                    size: displayWidth(context) * 0.05,
                                  ),
                                ],
                              ),
                            ),
                          ),
                    SizedBox(height: displayHeight(context) * 0.02),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _selectedPesertaId.isEmpty
                            ? null
                            : () {
                                _fetchRiwayat();
                              },
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: displayWidth(context) * 0.045,
                        ),
                        label: Text(
                          "Cari Riwayat",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE84C63),
                          disabledBackgroundColor: Colors.grey[400],
                          disabledForegroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: displayHeight(context) * 0.015,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              displayWidth(context) * 0.08,
                            ),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.04),

              if (_hasSearched) ...[
                // Hasil Evaluasi Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hasil Evaluasi",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: displayWidth(context) * 0.042,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "Menampilkan ${_evaluations.length} data",
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.03,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: displayHeight(context) * 0.02),

                // List Evaluasi
                if (_isLoadingEvaluasi)
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Column(
                      children: List.generate(
                        2,
                        (index) => Container(
                          height: displayHeight(context) * 0.2,
                          width: double.infinity,
                          margin: EdgeInsets.only(
                            bottom: displayHeight(context) * 0.02,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              displayWidth(context) * 0.04,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                else if (_evaluations.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(displayWidth(context) * 0.1),
                      child: Text(
                        "Belum ada riwayat evaluasi",
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                  )
                else
                  ..._evaluations.map((eval) {
                    bool isExpanded = eval['isExpanded'];
                    return Container(
                      margin: EdgeInsets.only(
                        bottom: displayHeight(context) * 0.02,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          displayWidth(context) * 0.04,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          displayWidth(context) * 0.04,
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              // Left Red Border
                              Container(
                                width: displayWidth(context) * 0.015,
                                color: const Color(0xFFE84C63),
                              ),
                              // Content
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    displayWidth(context) * 0.04,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  eval['bulan_tahun'] ?? '',
                                                  style: TextStyle(
                                                    fontSize:
                                                        displayWidth(context) *
                                                        0.028,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color(
                                                      0xFFE84C63,
                                                    ),
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                      displayHeight(context) *
                                                      0.005,
                                                ),
                                                Text(
                                                  eval['peserta']?['nama'] ??
                                                      'Unknown',
                                                  style: TextStyle(
                                                    fontSize:
                                                        displayWidth(context) *
                                                        0.042,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  displayWidth(context) * 0.025,
                                              vertical:
                                                  displayHeight(context) *
                                                  0.005,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFDE8E8),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    displayWidth(context) *
                                                        0.04,
                                                  ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: const Color(
                                                    0xFFE84C63,
                                                  ),
                                                  size:
                                                      displayWidth(context) *
                                                      0.035,
                                                ),
                                                SizedBox(
                                                  width:
                                                      displayWidth(context) *
                                                      0.01,
                                                ),
                                                Text(
                                                  eval['rating_akhir']
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        displayWidth(context) *
                                                        0.035,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: displayHeight(context) * 0.015,
                                      ),
                                      Text(
                                        eval['feedback'],
                                        style: TextStyle(
                                          fontSize:
                                              displayWidth(context) * 0.035,
                                          color: Colors.grey[700],
                                          height: 1.4,
                                        ),
                                        maxLines: isExpanded ? null : 2,
                                        overflow: isExpanded
                                            ? TextOverflow.visible
                                            : TextOverflow.ellipsis,
                                      ),

                                      if (isExpanded) ...[
                                        SizedBox(
                                          height: displayHeight(context) * 0.02,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(
                                            displayWidth(context) * 0.04,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF9F9F9),
                                            borderRadius: BorderRadius.circular(
                                              displayWidth(context) * 0.03,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "RINCIAN PENILAIAN",
                                                style: TextStyle(
                                                  fontSize:
                                                      displayWidth(context) *
                                                      0.028,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    displayHeight(context) *
                                                    0.015,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Produktivitas",
                                                    style: TextStyle(
                                                      fontSize:
                                                          displayWidth(
                                                            context,
                                                          ) *
                                                          0.032,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                  _buildStars(
                                                    eval['produktivitas'],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height:
                                                    displayHeight(context) *
                                                    0.01,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Komunikasi",
                                                    style: TextStyle(
                                                      fontSize:
                                                          displayWidth(
                                                            context,
                                                          ) *
                                                          0.032,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                  _buildStars(
                                                    eval['komunikasi'],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height:
                                                    displayHeight(context) *
                                                    0.01,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Keahlian Teknis",
                                                    style: TextStyle(
                                                      fontSize:
                                                          displayWidth(
                                                            context,
                                                          ) *
                                                          0.032,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                  _buildStars(
                                                    eval['keahlian_teknis'],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],

                                      SizedBox(
                                        height: displayHeight(context) * 0.02,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              eval['isExpanded'] =
                                                  !eval['isExpanded'];
                                            });
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                isExpanded
                                                    ? "TUTUP DETAIL"
                                                    : "LIHAT DETAIL",
                                                style: TextStyle(
                                                  color: const Color(
                                                    0xFFE84C63,
                                                  ),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      displayWidth(context) *
                                                      0.03,
                                                ),
                                              ),
                                              SizedBox(
                                                width:
                                                    displayWidth(context) *
                                                    0.01,
                                              ),
                                              Icon(
                                                isExpanded
                                                    ? Icons.keyboard_arrow_up
                                                    : Icons.keyboard_arrow_down,
                                                color: const Color(0xFFE84C63),
                                                size:
                                                    displayWidth(context) *
                                                    0.04,
                                              ),
                                            ],
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
                  }).toList(),
              ],

              SizedBox(height: displayHeight(context) * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
