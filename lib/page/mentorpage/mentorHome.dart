part of '../../conn/auth.dart';

class MentorHome extends StatefulWidget {
  const MentorHome({super.key});
  @override
  State<MentorHome> createState() => _MentorHomeState();
}

class _MentorHomeState extends State<MentorHome> {
  final iconList = <IconData>[Icons.brightness_5, Icons.brightness_4];
  Widget _buildQuickAccessCard(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: EdgeInsets.only(top: displayWidth(context) * 0.07),
              padding: EdgeInsets.only(
                top: displayWidth(context) * 0.09,
                bottom: displayWidth(context) * 0.05,
                left: displayWidth(context) * 0.02,
                right: displayWidth(context) * 0.02,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  displayWidth(context) * 0.04,
                ),
              ),
              width: double.infinity,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.03,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Container(
              width: displayWidth(context) * 0.14,
              height: displayWidth(context) * 0.14,
              decoration: BoxDecoration(
                color: const Color(0xFF9E9E9E), // Grey background for icon
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFEEEEEE),
                  width: 3,
                ), // Match background to look like a cutout if needed, but in image it's just a solid circle
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: displayWidth(context) * 0.07,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: displayWidth(context) * 0.06,
              right: displayWidth(context) * 0.06,
              bottom: displayHeight(context) * 0.15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: displayHeight(context) * 0.02),
                // Logo
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "v",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.07,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            letterSpacing: -1.5,
                          ),
                        ),
                        TextSpan(
                          text: "o",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.07,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFFE84C63), // Red 'o'
                            letterSpacing: -1.5,
                          ),
                        ),
                        TextSpan(
                          text: "casia",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.07,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            letterSpacing: -1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.03),
                // Profile Row
                Row(
                  children: [
                    CircleAvatar(
                      radius: displayWidth(context) * 0.06,
                      backgroundColor: Colors.grey[400],
                      backgroundImage: const NetworkImage(
                        'https://i.pravatar.cc/150?img=11',
                      ), // Placeholder image
                    ),
                    SizedBox(width: displayWidth(context) * 0.03),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selamat Pagi",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.03,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          "Umar Fakhriy",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.035,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.all(displayWidth(context) * 0.02),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE84C63),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white,
                        size: displayWidth(context) * 0.045,
                      ),
                    ),
                    SizedBox(width: displayWidth(context) * 0.02),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MentorNotif(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(displayWidth(context) * 0.02),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE84C63),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                          size: displayWidth(context) * 0.045,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: displayHeight(context) * 0.03),
                // Ringkasan Hari ini
                Container(
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
                      Row(
                        children: [
                          Icon(
                            Icons.push_pin,
                            color: const Color(0xFFE84C63),
                            size: displayWidth(context) * 0.045,
                          ),
                          SizedBox(width: displayWidth(context) * 0.02),
                          Text(
                            "Ringkasan Hari ini",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.035,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: displayHeight(context) * 0.015),
                      Row(
                        children: [
                          Icon(
                            Icons.group,
                            color: Colors.purple[400],
                            size: displayWidth(context) * 0.04,
                          ),
                          SizedBox(width: displayWidth(context) * 0.02),
                          Text(
                            "10 dari 12 peserta sudah Clock in",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.03,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: displayHeight(context) * 0.01),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.access_time_filled,
                            color: Colors.blue[600],
                            size: displayWidth(context) * 0.04,
                          ),
                          SizedBox(width: displayWidth(context) * 0.02),
                          Expanded(
                            child: Text(
                              "3 dari 12 peserta sudah mengisi Laporan harian",
                              style: TextStyle(
                                fontSize: displayWidth(context) * 0.03,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.03),
                // Akses Cepat Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Akses Cepat",
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "Lihat Semua",
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.03,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: displayHeight(context) * 0.01),
                // Akses Cepat Grid
                Row(
                  children: [
                    _buildQuickAccessCard(
                      Icons.people,
                      "Lihat\nPeserta Magang",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const LiatPesertaMagangMentor(),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: displayWidth(context) * 0.04),
                    _buildQuickAccessCard(Icons.add, "Tambahkan\nTugas", () {}),
                  ],
                ),
                SizedBox(height: displayHeight(context) * 0.01),
                Row(
                  children: [
                    _buildQuickAccessCard(
                      Icons.access_time,
                      "Lihat Absensi\nPeserta Magang",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AbsensiPesertaMentor(),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: displayWidth(context) * 0.04),
                    _buildQuickAccessCard(
                      Icons.assignment_turned_in,
                      "Lihat\nPenugasan Peserta",
                      () {},
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
}
