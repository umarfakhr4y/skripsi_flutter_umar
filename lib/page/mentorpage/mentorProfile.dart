part of '../../conn/auth.dart';

class MentorProfile extends StatefulWidget {
  const MentorProfile({super.key});

  @override
  State<MentorProfile> createState() => _MentorProfileState();
}

class _MentorProfileState extends State<MentorProfile> {
  Widget _buildMenuHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(
        top: displayHeight(context) * 0.03,
        bottom: displayHeight(context) * 0.02,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: displayWidth(context) * 0.035,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildMenuOption(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: displayHeight(context) * 0.025),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: displayWidth(context) * 0.035,
              color: Colors.black87,
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.black87,
            size: displayWidth(context) * 0.04,
          ),
        ],
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
            padding: EdgeInsets.symmetric(
              horizontal: displayWidth(context) * 0.06,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: displayHeight(context) * 0.02),
                // Ikon Logout Kanan Atas
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.black87,
                      size: displayWidth(context) * 0.07,
                    ),
                    onPressed: () {
                      // Fungsi logout
                    },
                  ),
                ),

                // Bagian Avatar dan Profil
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: displayWidth(context) * 0.12,
                            backgroundColor: Colors.grey[400],
                            backgroundImage: const NetworkImage(
                              'https://i.pravatar.cc/150?img=11',
                            ), // Placeholder gambar avatar
                          ),
                          Container(
                            padding: EdgeInsets.all(
                              displayWidth(context) * 0.015,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFEEEEEE),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.edit_outlined,
                              color: Colors.grey[600],
                              size: displayWidth(context) * 0.04,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: displayHeight(context) * 0.02),
                      Text(
                        "Umar Fakhriy",
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: displayHeight(context) * 0.005),
                      Text(
                        "umarfakhr4y@gmail.com",
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.035,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.02),

                // // Bagian Menu List
                // _buildMenuHeader("Preferensi Akun"),
                // _buildMenuOption("Data Diri"),
                // _buildMenuOption("Pengaturan Akun"),
                // _buildMenuOption("Riwayat Transaksi"),
                _buildMenuHeader("Bantuan dan Dukungan"),
                _buildMenuOption("Tentang Vocasia"),
                _buildMenuOption("Syarat & Ketentuan"),
                _buildMenuOption("Kebijakan Privasi"),

                SizedBox(height: displayHeight(context) * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
