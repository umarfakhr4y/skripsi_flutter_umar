part of '../../conn/auth.dart';

class MentorTools extends StatefulWidget {
  const MentorTools({super.key});

  @override
  State<MentorTools> createState() => _MentorToolsState();
}

class _MentorToolsState extends State<MentorTools> {
  Widget _buildToolCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: displayHeight(context) * 0.015),
        padding: EdgeInsets.symmetric(
          horizontal: displayWidth(context) * 0.04,
          vertical: displayHeight(context) * 0.02,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(displayWidth(context) * 0.03),
              decoration: const BoxDecoration(
                color: Color(0xFFEA6E7D), // Soft red color matching previous UI
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
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
                      fontSize: displayWidth(context) * 0.035,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: displayHeight(context) * 0.005),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.03,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black87,
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
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: displayWidth(context) * 0.06,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: displayHeight(context) * 0.01),
                Text(
                  "Apa yang ingin anda lakukan\nhari ini ?",
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.04),

                // List of Tools
                _buildToolCard(
                  icon: Icons.people,
                  title: "Peserta Magang",
                  subtitle: "Lihat Peserta Magang",
                  onTap: () {},
                ),
                _buildToolCard(
                  icon: Icons.people,
                  title: "Persuratan",
                  subtitle: "Lihat Pengajuan Persuratan",
                  onTap: () {},
                ),
                _buildToolCard(
                  icon: Icons.assignment,
                  title: "Manajemen Tugas",
                  subtitle: "Lihat Manajemen Tugas",
                  onTap: () {},
                ),
                _buildToolCard(
                  icon: Icons.assignment,
                  title: "Bimbingan",
                  subtitle: "Lihat Bimbingan",
                  onTap: () {},
                ),
                _buildToolCard(
                  icon: Icons.calendar_today,
                  title: "Laporan Harian",
                  subtitle: "Lihat Laporan Harian",
                  onTap: () {},
                ),

                SizedBox(height: displayHeight(context) * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
