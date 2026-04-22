part of '../../conn/auth.dart';

class MentorNotif extends StatefulWidget {
  const MentorNotif({super.key});

  @override
  State<MentorNotif> createState() => _MentorNotifState();
}

class _MentorNotifState extends State<MentorNotif> {
  Widget _buildNotifCard(String category, String time, String description) {
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
            children: [
              Icon(
                Icons.error, // Red circle with exclamation mark
                color: const Color(0xFFE84C63), // Red color
                size: displayWidth(context) * 0.045,
              ),
              SizedBox(width: displayWidth(context) * 0.02),
              Text(
                category,
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.035,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(width: displayWidth(context) * 0.02),
              Text(
                time,
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.03,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          SizedBox(height: displayHeight(context) * 0.015),
          Text(
            description,
            style: TextStyle(
              fontSize: displayWidth(context) * 0.035,
              color: Colors.black87,
            ),
          ),
        ],
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
        title: Text(
          "Aktifitas Terbaru",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: displayWidth(context) * 0.05,
          ),
        ),
        titleSpacing: 0, // Removes extra spacing to align closer to back button
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: displayWidth(context) * 0.06,
          ),
          child: Column(
            children: [
              SizedBox(height: displayHeight(context) * 0.02),
              _buildNotifCard(
                "Persuratan",
                "5 menit lalu",
                "Umar Fakhriy baru saja mengajukan permi...",
              ),
              _buildNotifCard(
                "Penugasan",
                "10 menit lalu",
                "Umar Fakhriy baru saja mengumpulkan tug...",
              ),
              _buildNotifCard(
                "Bimbingan",
                "15 menit lalu",
                "Umar Fakhriy baru saja mengajukan bimbin...",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
