part of '../../../conn/auth.dart';

class EvaluasiBulananPesertaMentor extends StatefulWidget {
  const EvaluasiBulananPesertaMentor({super.key});

  @override
  State<EvaluasiBulananPesertaMentor> createState() =>
      _EvaluasiBulananPesertaMentorState();
}

class _EvaluasiBulananPesertaMentorState
    extends State<EvaluasiBulananPesertaMentor> {
  int _produktivitasRating = 0;
  int _komunikasiRating = 0;
  int _keahlianTeknisRating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  String? selectedPesertaId;
  String? selectedPesertaName;
  List<Map<String, dynamic>> listPeserta = [];
  bool _isLoadingPeserta = true;
  bool _isSubmitting = false;
  bool _isSudahEvaluasiBulanIni = false;

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
            listPeserta = List<Map<String, dynamic>>.from(result['data']);
            if (listPeserta.isNotEmpty) {
              selectedPesertaId = listPeserta.first['id'].toString();
              selectedPesertaName = listPeserta.first['nama_lengkap'];
              _isSudahEvaluasiBulanIni =
                  listPeserta.first['sudah_dievaluasi_bulan_ini'] ?? false;
            }
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

  Future<void> _submitEvaluasi() async {
    if (selectedPesertaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pilih peserta terlebih dahulu"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_produktivitasRating == 0 ||
        _komunikasiRating == 0 ||
        _keahlianTeknisRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lengkapi semua parameter penilaian"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Umpan balik tidak boleh kosong"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      List<String> months = [
        'JANUARI',
        'FEBRUARI',
        'MARET',
        'APRIL',
        'MEI',
        'JUNI',
        'JULI',
        'AGUSTUS',
        'SEPTEMBER',
        'OKTOBER',
        'NOVEMBER',
        'DESEMBER',
      ];
      String bulanTahun =
          "${months[DateTime.now().month - 1]} ${DateTime.now().year}";

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/mentor/evaluasi'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'peserta_magang_id': int.parse(selectedPesertaId!),
          'produktivitas': _produktivitasRating,
          'komunikasi': _komunikasiRating,
          'keahlian_teknis': _keahlianTeknisRating,
          'feedback': _feedbackController.text,
          'bulan_tahun': bulanTahun,
        }),
      );

      Navigator.pop(context);

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Evaluasi berhasil dikirim!"),
            backgroundColor: Colors.green,
          ),
        );

        // Mundur ke page sebelumnya
        Navigator.pop(context);

        setState(() {
          _produktivitasRating = 0;
          _komunikasiRating = 0;
          _keahlianTeknisRating = 0;
          _feedbackController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal mengirim evaluasi: ${response.statusCode}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Widget _buildStarRating(int rating, Function(int) onRatingChanged) {
    return Row(
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => onRatingChanged(index + 1),
          child: Padding(
            padding: EdgeInsets.only(right: displayWidth(context) * 0.02),
            child: Icon(
              index < rating ? Icons.star : Icons.star_border,
              color: index < rating ? Colors.amber : Colors.grey[400],
              size: displayWidth(context) * 0.07,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildParameterCard(
    String title,
    String subtitle,
    IconData iconData,
    int rating,
    Function(int) onRatingChanged,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
      padding: EdgeInsets.all(displayWidth(context) * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: displayWidth(context) * 0.038,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.005),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.032,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                iconData,
                color: const Color(0xFFE84C63).withOpacity(0.7),
                size: displayWidth(context) * 0.06,
              ),
            ],
          ),
          SizedBox(height: displayHeight(context) * 0.02),
          _buildStarRating(rating, onRatingChanged),
        ],
      ),
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
          "Evaluasi Bulanan",
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
              // Riwayat Evaluasi Button
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RiwayatEvaluasiMentor(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.history,
                        color: const Color(0xFFE84C63),
                        size: displayWidth(context) * 0.04,
                      ),
                      SizedBox(width: displayWidth(context) * 0.015),
                      Text(
                        "Riwayat Evaluasi",
                        style: TextStyle(
                          color: const Color(0xFFE84C63),
                          fontWeight: FontWeight.w600,
                          fontSize: displayWidth(context) * 0.035,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.02),

              // Peserta Card
              _isLoadingPeserta
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        padding: EdgeInsets.all(displayWidth(context) * 0.04),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            displayWidth(context) * 0.04,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: displayWidth(context) * 0.06,
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(width: displayWidth(context) * 0.04),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: displayWidth(context) * 0.3,
                                    height: displayHeight(context) * 0.015,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    height: displayHeight(context) * 0.01,
                                  ),
                                  Container(
                                    width: displayWidth(context) * 0.5,
                                    height: displayHeight(context) * 0.02,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    height: displayHeight(context) * 0.01,
                                  ),
                                  Container(
                                    width: displayWidth(context) * 0.2,
                                    height: displayHeight(context) * 0.015,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.unfold_more,
                              color: Colors.white,
                              size: displayWidth(context) * 0.06,
                            ),
                          ],
                        ),
                      ),
                    )
                  : PopupMenuButton<String>(
                      onSelected: (String id) {
                        setState(() {
                          selectedPesertaId = id;
                          final selected = listPeserta.firstWhere(
                            (p) => p['id'].toString() == id,
                          );
                          selectedPesertaName = selected['nama_lengkap'];
                          _isSudahEvaluasiBulanIni =
                              selected['sudah_dievaluasi_bulan_ini'] ?? false;
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return listPeserta.map((peserta) {
                          return PopupMenuItem<String>(
                            value: peserta['id'].toString(),
                            child: Text(peserta['nama_lengkap']),
                          );
                        }).toList();
                      },
                      child: Container(
                        padding: EdgeInsets.all(displayWidth(context) * 0.04),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            displayWidth(context) * 0.04,
                          ),
                        ),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: displayWidth(context) * 0.06,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: NetworkImage(
                                    "https://ui-avatars.com/api/?name=${selectedPesertaName?.replaceAll(' ', '+') ?? 'P'}&background=random",
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: displayWidth(context) * 0.035,
                                    height: displayWidth(context) * 0.035,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: displayWidth(context) * 0.04),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "PESERTA MAGANG",
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.028,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(
                                    height: displayHeight(context) * 0.002,
                                  ),
                                  Text(
                                    selectedPesertaName ?? "Pilih Peserta",
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.045,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.unfold_more,
                              color: Colors.grey[500],
                              size: displayWidth(context) * 0.06,
                            ),
                          ],
                        ),
                      ),
                    ),
              SizedBox(height: displayHeight(context) * 0.04),

              // Header Parameter Penilaian
              if (_isLoadingPeserta)
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: displayWidth(context) * 0.5,
                        height: displayHeight(context) * 0.03,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            displayWidth(context) * 0.01,
                          ),
                        ),
                      ),
                      SizedBox(height: displayHeight(context) * 0.02),
                      Container(
                        height: displayHeight(context) * 0.12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            displayWidth(context) * 0.04,
                          ),
                        ),
                      ),
                      SizedBox(height: displayHeight(context) * 0.02),
                      Container(
                        height: displayHeight(context) * 0.12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            displayWidth(context) * 0.04,
                          ),
                        ),
                      ),
                      SizedBox(height: displayHeight(context) * 0.02),
                      Container(
                        height: displayHeight(context) * 0.12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            displayWidth(context) * 0.04,
                          ),
                        ),
                      ),
                      SizedBox(height: displayHeight(context) * 0.04),
                      Container(
                        width: displayWidth(context) * 0.6,
                        height: displayHeight(context) * 0.03,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            displayWidth(context) * 0.02,
                          ),
                        ),
                      ),
                      SizedBox(height: displayHeight(context) * 0.02),
                      Container(
                        height: displayHeight(context) * 0.15,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            displayWidth(context) * 0.04,
                          ),
                        ),
                      ),
                      SizedBox(height: displayHeight(context) * 0.04),
                      Container(
                        height: displayHeight(context) * 0.06,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            displayWidth(context) * 0.08,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else if (_isSudahEvaluasiBulanIni)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(displayWidth(context) * 0.06),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.04,
                    ),
                    border: Border.all(color: Colors.green[300]!, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: displayWidth(context) * 0.12,
                      ),
                      SizedBox(height: displayHeight(context) * 0.02),
                      Text(
                        "Evaluasi Selesai",
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.045,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                      SizedBox(height: displayHeight(context) * 0.01),
                      Text(
                        "Anda sudah mengisi evaluasi bulanan untuk peserta ini pada bulan ini.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.035,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                Row(
                  children: [
                    Container(
                      width: displayWidth(context) * 0.015,
                      height: displayHeight(context) * 0.025,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE84C63),
                        borderRadius: BorderRadius.circular(
                          displayWidth(context) * 0.01,
                        ),
                      ),
                    ),
                    SizedBox(width: displayWidth(context) * 0.03),
                    Text(
                      "Parameter Penilaian",
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: displayHeight(context) * 0.02),

                // Parameter Cards
                _buildParameterCard(
                  "Produktivitas",
                  "Output dan kecepatan penyelesaian tugas.",
                  Icons.speed,
                  _produktivitasRating,
                  (val) => setState(() => _produktivitasRating = val),
                ),
                _buildParameterCard(
                  "Komunikasi",
                  "Efektivitas dalam diskusi tim.",
                  Icons.chat_bubble_outline,
                  _komunikasiRating,
                  (val) => setState(() => _komunikasiRating = val),
                ),
                _buildParameterCard(
                  "Keahlian Teknis",
                  "Kemahiran dalam alat desain dan metodologi.",
                  Icons.handyman_outlined,
                  _keahlianTeknisRating,
                  (val) => setState(() => _keahlianTeknisRating = val),
                ),

                SizedBox(height: displayHeight(context) * 0.02),

                // Header Umpan Balik
                Text(
                  "Umpan Balik & Catatan Umum",
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.02),

                // Feedback Text Area
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4EBEC), // Light pinkish grey
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.04,
                    ),
                  ),
                  padding: EdgeInsets.all(displayWidth(context) * 0.04),
                  child: Column(
                    children: [
                      TextField(
                        controller: _feedbackController,
                        maxLines: 4,
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.038,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              "Bagaimana performa Aditya bulan ini secara keseluruhan? Berikan saran pengembangan...",
                          hintStyle: TextStyle(
                            color: const Color(0xFFE84C63).withOpacity(0.4),
                            fontSize: displayWidth(context) * 0.038,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: displayHeight(context) * 0.04),

                // Kirim Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting
                        ? null
                        : () {
                            _submitEvaluasi();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF983b42,
                      ), // Darker red based on image
                      padding: EdgeInsets.symmetric(
                        vertical: displayHeight(context) * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          displayWidth(context) * 0.08,
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Kirim Evaluasi",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: displayWidth(context) * 0.02),
                        Icon(
                          Icons.send_outlined,
                          color: Colors.white,
                          size: displayWidth(context) * 0.05,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: displayHeight(context) * 0.02),

                // Footer Text
                Center(
                  child: Text(
                    "Peserta akan menerima notifikasi hasil evaluasi ini.",
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.03,
                      color: Colors.grey[500],
                    ),
                  ),
                ),

                SizedBox(height: displayHeight(context) * 0.05),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
