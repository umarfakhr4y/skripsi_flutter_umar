part of '../../../conn/auth.dart';

class DetailPesertaMagangMentor extends StatefulWidget {
  const DetailPesertaMagangMentor({super.key});

  @override
  State<DetailPesertaMagangMentor> createState() => _DetailPesertaMagangMentorState();
}

class _DetailPesertaMagangMentorState extends State<DetailPesertaMagangMentor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text(
          'Profil Peserta',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: displayWidth(context) * 0.05,
          ),
        ),
        backgroundColor: const Color(0xFFEEEEEE),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(displayWidth(context) * 0.05),
          child: Column(
            children: [
              _buildProfilHeader(),
              SizedBox(height: displayHeight(context) * 0.02),
              _buildDataDiri(),
              SizedBox(height: displayHeight(context) * 0.02),
              _buildTugasTerbaru(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: displayHeight(context) * 0.03, 
        horizontal: displayWidth(context) * 0.04
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: displayWidth(context) * 0.1,
            backgroundColor: Colors.grey[300],
            backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=11'), // Dummy image
          ),
          SizedBox(height: displayHeight(context) * 0.02),
          Text(
            'Budi Santoso',
            style: TextStyle(
              fontSize: displayWidth(context) * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: displayHeight(context) * 0.005),
          Text(
            'Universitas Gadjah Mada • Sistem Informasi',
            style: TextStyle(
              fontSize: displayWidth(context) * 0.03,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: displayHeight(context) * 0.015),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: displayWidth(context) * 0.04, 
              vertical: displayHeight(context) * 0.005
            ),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(displayWidth(context) * 0.05),
              border: Border.all(color: Colors.green.withOpacity(0.5)),
            ),
            child: Text(
              'Aktif',
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
                fontSize: displayWidth(context) * 0.03,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataDiri() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(displayWidth(context) * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline, color: const Color(0xFFE57373), size: displayWidth(context) * 0.05),
              SizedBox(width: displayWidth(context) * 0.02),
              Text(
                'Data Diri',
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: displayHeight(context) * 0.02),
          _buildDataRow('Email', 'budi.santoso@student.ugm.ac.id'),
          SizedBox(height: displayHeight(context) * 0.015),
          _buildDataRow('No. Telepon', '0812-3456-7890'),
          SizedBox(height: displayHeight(context) * 0.015),
          _buildDataRow('Periode Magang', '1 Feb 2024 - 31 Jul 2024'),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: displayWidth(context) * 0.03,
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: displayHeight(context) * 0.005),
        Text(
          value,
          style: TextStyle(
            fontSize: displayWidth(context) * 0.035,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildTugasTerbaru() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(displayWidth(context) * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.assignment_outlined, color: const Color(0xFFE57373), size: displayWidth(context) * 0.05),
                  SizedBox(width: displayWidth(context) * 0.02),
                  Text(
                    'Tugas Terbaru',
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // Aksi Lihat Semua
                },
                child: Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.03,
                    color: const Color(0xFFE57373),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: displayHeight(context) * 0.02),
          _buildTugasCard(
            icon: Icons.code,
            iconBgColor: const Color(0xFFE8EAF6), // Light Indigo
            iconColor: const Color(0xFF3F51B5),   // Indigo
            title: 'Implementasi API Login',
            subtitle: 'Deadline: 15 Mei 2024',
            badgeText: 'PROSES',
            badgeColor: const Color(0xFFF57C00),  // Orange
            badgeBgColor: const Color(0xFFFFF3E0), // Light Orange
          ),
          SizedBox(height: displayHeight(context) * 0.015),
          _buildTugasCard(
            icon: Icons.check_circle_outline,
            iconBgColor: const Color(0xFFE8F5E9), // Light Green
            iconColor: const Color(0xFF4CAF50),   // Green
            title: 'Desain UI Dashboard',
            subtitle: 'Diselesaikan: 10 Mei 2024',
            badgeText: 'SELESAI',
            badgeColor: const Color(0xFF4CAF50),  // Green
            badgeBgColor: const Color(0xFFE8F5E9), // Light Green
          ),
          SizedBox(height: displayHeight(context) * 0.015),
          _buildTugasCard(
            icon: Icons.design_services_outlined,
            iconBgColor: const Color(0xFFFFF3E0), // Light Orange
            iconColor: const Color(0xFFFF9800),   // Orange
            title: 'Riset User Persona',
            subtitle: 'Menunggu Review Mentor',
            badgeText: 'REVIEW',
            badgeColor: const Color(0xFF2196F3),  // Blue
            badgeBgColor: const Color(0xFFE3F2FD), // Light Blue
          ),
        ],
      ),
    );
  }

  Widget _buildTugasCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required Color badgeBgColor,
  }) {
    return Container(
      padding: EdgeInsets.all(displayWidth(context) * 0.03),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Icon Box
          Container(
            padding: EdgeInsets.all(displayWidth(context) * 0.025),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: displayWidth(context) * 0.05),
          ),
          SizedBox(width: displayWidth(context) * 0.03),
          
          // Texts
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: displayHeight(context) * 0.005),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.03,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: displayWidth(context) * 0.02),
          
          // Status Badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: displayWidth(context) * 0.025, 
              vertical: displayHeight(context) * 0.005
            ),
            decoration: BoxDecoration(
              color: badgeBgColor,
              borderRadius: BorderRadius.circular(displayWidth(context) * 0.015),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                color: badgeColor,
                fontWeight: FontWeight.w800,
                fontSize: displayWidth(context) * 0.025,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
