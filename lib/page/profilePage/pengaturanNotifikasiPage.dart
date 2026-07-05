part of '../../conn/auth.dart';

class PengaturanNotifikasiPage extends StatefulWidget {
  const PengaturanNotifikasiPage({super.key});

  @override
  State<PengaturanNotifikasiPage> createState() =>
      _PengaturanNotifikasiPageState();
}

class _PengaturanNotifikasiPageState extends State<PengaturanNotifikasiPage> {
  // State for toggles
  bool _notifikasiTugas = true;
  bool _pesanBimbingan = true;
  bool _pengingatPresensi = true;
  bool _beritaUpdate = false;

  Widget _buildNotificationItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
      padding: EdgeInsets.all(displayWidth(context) * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.035,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFFE46B72),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Very light grey background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color(0xFF983A46),
            size: displayWidth(context) * 0.06,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Pengaturan Notifikasi",
          style: TextStyle(
            color: const Color(0xFF983A46), // Red title matching the icon
            fontWeight: FontWeight.w500,
            fontSize: displayWidth(context) * 0.045,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: displayWidth(context) * 0.05,
              vertical: displayHeight(context) * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "PREFERENSI NOTIFIKASI",
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.035,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.02),

                _buildNotificationItem(
                  context,
                  icon: Icons.assignment_outlined,
                  title: "Notifikasi Tugas",
                  subtitle: "Update tugas baru atau perubahan deadline",
                  value: _notifikasiTugas,
                  onChanged: (val) {
                    setState(() {
                      _notifikasiTugas = val;
                    });
                  },
                ),
                _buildNotificationItem(
                  context,
                  icon: Icons.chat_bubble_outline,
                  title: "Pesan Bimbingan",
                  subtitle: "Pesan baru atau perubahan jadwal bimbingan",
                  value: _pesanBimbingan,
                  onChanged: (val) {
                    setState(() {
                      _pesanBimbingan = val;
                    });
                  },
                ),
                _buildNotificationItem(
                  context,
                  icon: Icons.calendar_today_outlined,
                  title: "Pengingat Presensi",
                  subtitle: "Pengingat harian untuk absensi kehadiran",
                  value: _pengingatPresensi,
                  onChanged: (val) {
                    setState(() {
                      _pengingatPresensi = val;
                    });
                  },
                ),
                _buildNotificationItem(
                  context,
                  icon: Icons.campaign_outlined,
                  title: "Berita & Update",
                  subtitle: "Informasi pengumuman & update aplikasi",
                  value: _beritaUpdate,
                  onChanged: (val) {
                    setState(() {
                      _beritaUpdate = val;
                    });
                  },
                ),

                SizedBox(height: displayHeight(context) * 0.02),

                // Info Box
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(displayWidth(context) * 0.05),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4), // Light grey box
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.03,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.black87,
                        size: displayWidth(context) * 0.06,
                      ),
                      SizedBox(height: displayHeight(context) * 0.015),
                      Text(
                        "Pengaturan ini berlaku untuk semua perangkat Anda. Anda dapat mengubah preferensi kapan saja.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.032,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: displayHeight(context) * 0.04),

                // Save Button
                ElevatedButton(
                  onPressed: () {
                    // Logic simpan
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFFE46B72,
                    ), // Soft red background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        displayWidth(context) * 0.06,
                      ), // Pill shape
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: displayHeight(context) * 0.02,
                    ),
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 0),
                  ),
                  child: Text(
                    "Simpan Pengaturan",
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
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
