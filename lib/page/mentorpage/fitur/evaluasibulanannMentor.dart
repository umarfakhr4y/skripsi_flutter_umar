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
              Container(
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
                          backgroundImage: const NetworkImage(
                            "https://ui-avatars.com/api/?name=Aditya+Pratama&background=random",
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
                              border: Border.all(color: Colors.white, width: 2),
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
                          SizedBox(height: displayHeight(context) * 0.002),
                          Text(
                            "Aditya Pratama",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.045,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: displayHeight(context) * 0.002),
                          Text(
                            "UI/UX Designer Intern • Month 2",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.032,
                              color: Colors.grey[600],
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
              SizedBox(height: displayHeight(context) * 0.04),

              // Header Parameter Penilaian
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
                  onPressed: () {
                    // TODO: Kirim Evaluasi
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Evaluasi berhasil dikirim! (UI Test)"),
                        backgroundColor: Colors.green,
                      ),
                    );
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
          ),
        ),
      ),
    );
  }
}
