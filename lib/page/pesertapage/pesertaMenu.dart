part of '../../conn/auth.dart';

class PesertaMenu extends StatefulWidget {
  const PesertaMenu({super.key});

  @override
  State<PesertaMenu> createState() => PesertaMenuState();
}

class PesertaMenuState extends State<PesertaMenu> {
  Widget _buildMenuOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
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
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(displayWidth(context) * 0.03),
              decoration: const BoxDecoration(
                color: Color(0xFFF9EAEB), // Light pinkish
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFFE84C63), // Red icon
                size: displayWidth(context) * 0.06,
              ),
            ),
            SizedBox(width: displayWidth(context) * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.038,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
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
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: displayWidth(context) * 0.04,
            ),
          ],
        ),
      ),
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
                // Header (Logo)
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
                SizedBox(height: displayHeight(context) * 0.04),

                // Banner Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE46B72), // Soft red background
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.03,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Background pattern
                      Positioned(
                        right: displayWidth(context) * 0.04,
                        top: displayWidth(context) * 0.04,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: displayWidth(context) * 0.1,
                                  height: displayWidth(context) * 0.1,
                                  color: Colors.black.withOpacity(0.05),
                                ),
                                SizedBox(width: displayWidth(context) * 0.02),
                                // A square chopped to look like a triangle
                                ClipPath(
                                  clipper: TriangleClipper(),
                                  child: Container(
                                    width: displayWidth(context) * 0.1,
                                    height: displayWidth(context) * 0.1,
                                    color: Colors.black.withOpacity(0.05),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: displayWidth(context) * 0.02),
                            Row(
                              children: [
                                Container(
                                  width: displayWidth(context) * 0.1,
                                  height: displayWidth(context) * 0.1,
                                  color: Colors.black.withOpacity(0.05),
                                ),
                                SizedBox(width: displayWidth(context) * 0.02),
                                Container(
                                  width: displayWidth(context) * 0.1,
                                  height: displayWidth(context) * 0.1,
                                  color: Colors.black.withOpacity(0.05),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Content
                      Padding(
                        padding: EdgeInsets.all(displayWidth(context) * 0.06),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pusat Layanan\nPeserta Magang",
                              style: TextStyle(
                                fontSize: displayWidth(context) * 0.045,
                                fontWeight: FontWeight.bold,
                                color: const Color(
                                  0xFF5E1B22,
                                ), // Dark red/brown
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: displayHeight(context) * 0.02),
                            Text(
                              "Kelola aktivitas magang\ndan administrasi Anda\ndalam satu tempat.",
                              style: TextStyle(
                                fontSize: displayWidth(context) * 0.035,
                                color: const Color(
                                  0xFF8B2B36,
                                ), // Lighter dark red
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.04),

                // Menu Items
                _buildMenuOption(
                  context,
                  icon: Icons.assignment,
                  title: "Tugas Saya",
                  subtitle: "Lihat daftar tugas harian",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TugasSayaPeserta(),
                      ),
                    );
                  },
                ),
                _buildMenuOption(
                  context,
                  icon: Icons.star_border,
                  title: "Evaluasi",
                  subtitle: "Hasil penilaian mentor",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EvaluasiPeserta(),
                      ),
                    );
                  },
                ),
                _buildMenuOption(
                  context,
                  icon: Icons.chat_bubble_outline,
                  title: "Bimbingan",
                  subtitle: "Konsultasi dengan mentor",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BimbinganPeserta(),
                      ),
                    );
                  },
                ),
                _buildMenuOption(
                  context,
                  icon: Icons.description,
                  title: "Persuratan & Perizinan",
                  subtitle: "Administrasi dan surat izin",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PersuratanPeserta(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, 0);
    path.close();
    // To match the screenshot roughly, a diamond or chopped corner shape
    return Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width / 2, 0)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
