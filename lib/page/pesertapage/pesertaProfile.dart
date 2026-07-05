part of '../../conn/auth.dart';

class PesertaProfile extends StatefulWidget {
  const PesertaProfile({super.key});

  @override
  State<PesertaProfile> createState() => PesertaProfileState();
}

class PesertaProfileState extends State<PesertaProfile> {
  Widget _buildMenuOption(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    return Container(
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
            padding: EdgeInsets.all(displayWidth(context) * 0.02),
            decoration: BoxDecoration(
              color: const Color(0xFFF9EAEB), // Light pinkish
              borderRadius: BorderRadius.circular(displayWidth(context) * 0.02),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF983A46),
              size: displayWidth(context) * 0.05,
            ),
          ),
          SizedBox(width: displayWidth(context) * 0.04),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: displayWidth(context) * 0.035,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey[600],
            size: displayWidth(context) * 0.04,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Very light grey background
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
              left: displayWidth(context) * 0.05,
              right: displayWidth(context) * 0.05,
              bottom: displayHeight(context) * 0.15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: displayHeight(context) * 0.03),
                // Header (Logo)
                Container(
                  padding: EdgeInsets.all(displayWidth(context) * 0.02),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9EAEB), // Light pinkish
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.02,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      print('logout');
                    },
                    child: Icon(
                      Icons.logout,
                      color: const Color(0xFF983A46),
                      size: displayWidth(context) * 0.05,
                    ),
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.04),

                // Bagian Avatar dan Profil
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            padding: EdgeInsets.all(
                              displayWidth(context) * 0.015,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(
                                  0xFFFDE8EB,
                                ), // light red outer border
                                width: 3,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: displayWidth(context) * 0.12,
                              backgroundColor: Colors.grey[400],
                              backgroundImage: const NetworkImage(
                                'https://i.pravatar.cc/150?img=11',
                              ), // Placeholder gambar avatar
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              bottom: displayWidth(context) * 0.01,
                              right: displayWidth(context) * 0.01,
                            ),
                            padding: EdgeInsets.all(
                              displayWidth(context) * 0.015,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF983A46,
                              ), // Dark red edit button
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                              size: displayWidth(context) * 0.04,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: displayHeight(context) * 0.02),
                      Text(
                        "Budi Santoso",
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: displayHeight(context) * 0.005),
                      Text(
                        "Teknik Informatika -\nUniversitas Gadjah Mada",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.035,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.04),

                // Bagian Menu List
                _buildMenuOption(
                  context,
                  icon: Icons.person_outline,
                  title: "Edit Profil",
                ),
                _buildMenuOption(
                  context,
                  icon: Icons.notifications_none,
                  title: "Pengaturan Notifikasi",
                ),
                _buildMenuOption(
                  context,
                  icon: Icons.help_outline,
                  title: "Pusat Bantuan",
                ),
                _buildMenuOption(
                  context,
                  icon: Icons.info_outline,
                  title: "Tentang Aplikasi",
                ),

                // Footer Version
                Center(
                  child: Text(
                    "Version 2.4.1 Build 2024",
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.025,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
