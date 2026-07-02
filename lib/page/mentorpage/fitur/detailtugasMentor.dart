part of '../../../conn/auth.dart';

class DetailTugasMentor extends StatefulWidget {
  const DetailTugasMentor({super.key});

  @override
  State<DetailTugasMentor> createState() => _DetailTugasMentorState();
}

class _DetailTugasMentorState extends State<DetailTugasMentor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text(
          'Detail Tugas',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Tags
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: displayWidth(context) * 0.03,
                      vertical: displayHeight(context) * 0.005,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE84C63),
                      borderRadius: BorderRadius.circular(
                        displayWidth(context) * 0.05,
                      ),
                    ),
                    child: Text(
                      'Aktif',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: displayWidth(context) * 0.03,
                      ),
                    ),
                  ),
                  SizedBox(width: displayWidth(context) * 0.02),
                  Text(
                    'UI/UX DESIGN',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                      fontSize: displayWidth(context) * 0.035,
                    ),
                  ),
                ],
              ),
              SizedBox(height: displayHeight(context) * 0.015),

              // Title
              Text(
                'Pembuatan logo untuk acara internal perayaan kelulusan magang',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: displayWidth(context) * 0.055,
                  height: 1.2,
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.03),

              // Info Cards Row
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      label: 'DITUGASKAN KE',
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: displayWidth(context) * 0.045,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: const NetworkImage(
                              'https://i.pravatar.cc/150?img=11',
                            ),
                          ),
                          SizedBox(width: displayWidth(context) * 0.02),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Umar Fakhriy',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: displayWidth(context) * 0.035,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'ID: 294021',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: displayWidth(context) * 0.025,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: displayWidth(context) * 0.04),
                  Expanded(
                    child: _buildInfoCard(
                      label: 'TENGGAT WAKTU',
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: const Color(0xFFE84C63),
                            size: displayWidth(context) * 0.06,
                          ),
                          SizedBox(width: displayWidth(context) * 0.02),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '24 Okt 2023',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: displayWidth(context) * 0.035,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Sisa 3 hari lagi',
                                  style: TextStyle(
                                    color: const Color(0xFFE84C63),
                                    fontSize: displayWidth(context) * 0.025,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: displayHeight(context) * 0.03),

              // Lampiran
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lampiran Instruksi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: displayWidth(context) * 0.04,
                      color: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LampiranInstruksiMentor(),
                        ),
                      );
                    },
                    child: Text(
                      'Lihat Semua',
                      style: TextStyle(
                        color: const Color(0xFFE84C63),
                        fontWeight: FontWeight.w600,
                        fontSize: displayWidth(context) * 0.03,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: displayHeight(context) * 0.015),
              _buildLampiranImage(),
              SizedBox(height: displayHeight(context) * 0.03),

              // Deskripsi Tugas
              Text(
                'Deskripsi Tugas',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: displayWidth(context) * 0.04,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.015),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(displayWidth(context) * 0.04),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.04,
                  ),
                ),
                child: Text(
                  'Tugas ini melibatkan pembuatan identitas visual yang segar untuk perayaan kelulusan batch musim ini. Logo harus mencerminkan nilai pertumbuhan, sinergi, dan keberhasilan.\n\nKriteria desain:\n1. Gunakan palet warna utama Coral (#E57373).\n2. Pastikan logo terbaca dalam ukuran kecil (favicon).\n3. Kirimkan dalam format vektor (.svg atau .ai).',
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.035,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.04),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.black87,
                        size: displayWidth(context) * 0.05,
                      ),
                      label: Text(
                        'Hapus',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: displayWidth(context) * 0.04,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: displayHeight(context) * 0.018,
                        ),
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            displayWidth(context) * 0.05,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: displayWidth(context) * 0.04),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                        size: displayWidth(context) * 0.05,
                      ),
                      label: Text(
                        'Edit Tugas',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: displayWidth(context) * 0.04,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE84C63),
                        padding: EdgeInsets.symmetric(
                          vertical: displayHeight(context) * 0.018,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            displayWidth(context) * 0.05,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: displayHeight(context) * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String label, required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: displayWidth(context) * 0.03,
        vertical: displayHeight(context) * 0.015,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: displayWidth(context) * 0.025,
            ),
          ),
          SizedBox(height: displayHeight(context) * 0.01),
          child,
        ],
      ),
    );
  }

  Widget _buildLampiranImage() {
    return Container(
      width: double.infinity,
      height: displayHeight(context) * 0.22,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?q=80&w=1000&auto=format&fit=crop', // Dummy workplace image
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
          ),
        ),
        padding: EdgeInsets.all(displayWidth(context) * 0.03),
        alignment: Alignment.bottomLeft,
        child: Row(
          children: [
            Icon(
              Icons.image_outlined,
              color: Colors.white,
              size: displayWidth(context) * 0.04,
            ),
            SizedBox(width: displayWidth(context) * 0.02),
            Text(
              'Moodboard_Identity.png',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: displayWidth(context) * 0.03,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
