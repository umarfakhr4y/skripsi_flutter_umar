part of '../../conn/auth.dart';

class AdminValidasi extends StatelessWidget {
  const AdminValidasi({Key? key}) : super(key: key);

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
                'Pendaftaran Pending',
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.01),
              Text(
                'Tinjau dan setujui pengguna baru yang bergabung di\nplatform.',
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.035,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.03),

              // User List
              _buildPendingCard(
                context: context,
                initials: 'JS',
                avatarBgColor: const Color(0xFFE2E8F0), // light grey
                avatarTextColor: Colors.black54,
                name: 'Jane Smith',
                roleBadge: 'Peserta',
                badgeBgColor: const Color(0xFFFDE8EB),
                badgeTextColor: const Color(0xFFB04A50),
                timeText: 'Mendaftar 2 jam lalu',
                descText: 'Computer\nScience\nstudent at...',
              ),
              _buildPendingCard(
                context: context,
                initials: 'MR',
                avatarBgColor: const Color(0xFFC78D32), // yellow/brown
                avatarTextColor: const Color(0xFF5C3C00), // dark text
                name: 'Michael Roberts',
                roleBadge: 'Mentor',
                badgeBgColor: const Color(0xFFFEF08A).withOpacity(0.5),
                badgeTextColor: const Color(0xFF5C3C00),
                timeText: 'Mendaftar kemarin',
                descText: 'Senior UX Designer\ninterested in...',
              ),
              _buildPendingCard(
                context: context,
                initials: 'AL',
                avatarBgColor: const Color(0xFFE2E8F0),
                avatarTextColor: Colors.black54,
                name: 'Alex Lee',
                roleBadge: 'Peserta',
                badgeBgColor: const Color(0xFFFDE8EB),
                badgeTextColor: const Color(0xFFB04A50),
                timeText: 'Mendaftar 24 Okt 2023',
                descText: 'Marketing\nmajor\nlooking for\nhands-on',
              ),
              SizedBox(height: displayHeight(context) * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPendingCard({
    required BuildContext context,
    required String initials,
    required Color avatarBgColor,
    required Color avatarTextColor,
    required String name,
    required String roleBadge,
    required Color badgeBgColor,
    required Color badgeTextColor,
    required String timeText,
    required String descText,
  }) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: displayWidth(context) * 0.07,
                backgroundColor: avatarBgColor,
                child: Text(
                  initials,
                  style: TextStyle(
                    color: avatarTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: displayWidth(context) * 0.045,
                  ),
                ),
              ),
              SizedBox(width: displayWidth(context) * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.01),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: displayWidth(context) * 0.02,
                            vertical: displayHeight(context) * 0.003,
                          ),
                          decoration: BoxDecoration(
                            color: badgeBgColor,
                            borderRadius: BorderRadius.circular(
                              displayWidth(context) * 0.03,
                            ),
                          ),
                          child: Text(
                            roleBadge,
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.028,
                              fontWeight: FontWeight.w600,
                              color: badgeTextColor,
                            ),
                          ),
                        ),
                        SizedBox(width: displayWidth(context) * 0.03),
                        Text(
                          timeText,
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.028,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: displayHeight(context) * 0.015),
                    Text(
                      descText,
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.035,
                        color: Colors.grey[700],
                        height: 1.3,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: displayHeight(context) * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Tolak button
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: displayWidth(context) * 0.04,
                    vertical: displayHeight(context) * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.05,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.close,
                        size: displayWidth(context) * 0.035,
                        color: Colors.black87,
                      ),
                      SizedBox(width: displayWidth(context) * 0.01),
                      Text(
                        'Tolak',
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.032,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: displayWidth(context) * 0.02),
              // Setujui button
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: displayWidth(context) * 0.04,
                    vertical: displayHeight(context) * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB04A50),
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.05,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        size: displayWidth(context) * 0.035,
                        color: Colors.white,
                      ),
                      SizedBox(width: displayWidth(context) * 0.01),
                      Text(
                        'Setujui',
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.032,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
