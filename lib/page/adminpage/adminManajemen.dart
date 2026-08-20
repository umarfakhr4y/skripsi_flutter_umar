part of '../../conn/auth.dart';

class AdminManajemen extends StatefulWidget {
  const AdminManajemen({Key? key}) : super(key: key);

  @override
  State<AdminManajemen> createState() => _AdminManajemenState();
}

class _AdminManajemenState extends State<AdminManajemen> {
  String _selectedTab = 'Pengguna';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(displayWidth(context) * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom AppBar (Logo & Avatar)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "v",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.08,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            letterSpacing: -1.0,
                          ),
                        ),
                        TextSpan(
                          text: "o",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.08,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFFE84C63), // Red
                            letterSpacing: -1.0,
                          ),
                        ),
                        TextSpan(
                          text: "casia",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.08,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            letterSpacing: -1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: displayHeight(context) * 0.03),

              // Title and Subtitle
              Text(
                'Manajemen',
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.065,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.01),
              Text(
                'Kelola pengguna, departemen, dan konfigurasi\nsistem.',
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.035,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.03),

              // Tabs
              Row(
                children: [
                  _buildTab('Pengguna'),
                  SizedBox(width: displayWidth(context) * 0.02),
                  _buildTab('Mentor'),
                  SizedBox(width: displayWidth(context) * 0.02),
                  _buildTab('Divisi'),
                ],
              ),
              SizedBox(height: displayHeight(context) * 0.03),

              // Search and Filter
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(
                          displayWidth(context) * 0.03,
                        ),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari mentor & peserta...',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: displayWidth(context) * 0.035,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[600],
                            size: displayWidth(context) * 0.05,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: displayHeight(context) * 0.015,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: displayWidth(context) * 0.03),
                  Container(
                    padding: EdgeInsets.all(displayWidth(context) * 0.03),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(
                        displayWidth(context) * 0.03,
                      ),
                    ),
                    child: Icon(
                      Icons.filter_list,
                      color: Colors.black87,
                      size: displayWidth(context) * 0.05,
                    ),
                  ),
                ],
              ),
              SizedBox(height: displayHeight(context) * 0.03),

              // User List
              _buildUserCard(
                name: 'Sarah Jenkins',
                roleDesc: 'Lead Designer • Product',
                badgeText: 'MENTOR',
                badgeColor: const Color(0xFFC78D32),
                badgeBgColor: const Color(
                  0xFFC78D32,
                ), // In screenshot it's solid yellow with dark text or white text. Looks like solid yellow background, dark text. Let's use Color(0xFFD69E2E) with white text. Wait, screenshot has dark text. Let's make it solid.
                avatarWidget: CircleAvatar(
                  radius: displayWidth(context) * 0.06,
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    Icons.person,
                    color: Colors.grey[400],
                  ), // Placeholder for image
                ),
              ),
              _buildUserCard(
                name: 'Marcus Johnson',
                roleDesc: 'UX Intern • UI/UX',
                badgeText: 'PESERTA',
                badgeColor: const Color(0xFFB04A50),
                badgeBgColor: const Color(0xFFE46B72),
                avatarWidget: CircleAvatar(
                  radius: displayWidth(context) * 0.06,
                  backgroundColor: const Color(0xFFE46B72),
                  child: Text(
                    'MJ',
                    style: TextStyle(
                      color: const Color(0xFF5E1B22), // Dark red
                      fontWeight: FontWeight.bold,
                      fontSize: displayWidth(context) * 0.04,
                    ),
                  ),
                ),
              ),
              _buildUserCard(
                name: 'David Chen',
                roleDesc: 'Dev Intern • Engineering',
                badgeText: 'PESERTA',
                badgeColor: const Color(0xFFB04A50),
                badgeBgColor: const Color(0xFFE46B72),
                avatarWidget: CircleAvatar(
                  radius: displayWidth(context) * 0.06,
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    Icons.person,
                    color: Colors.grey[400],
                  ), // Placeholder for image
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String text) {
    bool isSelected = _selectedTab == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = text;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: displayWidth(context) * 0.04,
          vertical: displayHeight(context) * 0.01,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB04A50) : Colors.grey[100],
          borderRadius: BorderRadius.circular(displayWidth(context) * 0.05),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: displayWidth(context) * 0.035,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard({
    required String name,
    required String roleDesc,
    required String badgeText,
    required Color badgeColor,
    required Color badgeBgColor,
    required Widget avatarWidget,
  }) {
    bool isMentor = badgeText == 'MENTOR';
    return Container(
      margin: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
      padding: EdgeInsets.all(displayWidth(context) * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          avatarWidget,
          SizedBox(width: displayWidth(context) * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.005),
                Text(
                  roleDesc,
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.03,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: displayWidth(context) * 0.02,
                  vertical: displayHeight(context) * 0.005,
                ),
                decoration: BoxDecoration(
                  color: isMentor
                      ? const Color(0xFFC78D32)
                      : const Color(0xFFE46B72),
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.02,
                  ),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.025,
                    fontWeight: FontWeight.bold,
                    color: isMentor
                        ? const Color(0xFF5C3C00)
                        : const Color(0xFF5E1B22),
                  ),
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.01),
              Icon(
                Icons.more_vert,
                color: Colors.black87,
                size: displayWidth(context) * 0.05,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
