part of '../../../conn/auth.dart';

class AbsensiPesertaMentor extends StatefulWidget {
  const AbsensiPesertaMentor({super.key});

  @override
  State<AbsensiPesertaMentor> createState() => _AbsensiPesertaMentorState();
}

class _AbsensiPesertaMentorState extends State<AbsensiPesertaMentor> {
  // Dummy data untuk mensimulasikan hasil GET API nantinya
  final List<Map<String, dynamic>> absensiList = [
    {
      "name": "Umar Fakhriy",
      "status_text": "08:30",
      "status_icon": Icons.check,
    },
    {
      "name": "Galuh Kirana",
      "status_text": "08:35",
      "status_icon": Icons.check,
    },
    {
      "name": "Haikal Dzaky",
      "status_text": "08:41",
      "status_icon": Icons.check,
    },
    {
      "name": "Ahmad Ghofur",
      "status_text": "08:57",
      "status_icon": Icons.check,
    },
    {
      "name": "Fakrazi",
      "status_text": "Izin : Acara Keluarga",
      // Menggunakan priority_high untuk menampilkan tanda seru "!"
      "status_icon": Icons.priority_high,
    },
    {"name": "Novalino Hamid", "status_text": "", "status_icon": Icons.close},
  ];

  Widget _buildAbsensiCard(Map<String, dynamic> data) {
    bool hasSubtitle =
        data["status_text"] != null &&
        data["status_text"].toString().isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: displayHeight(context) * 0.015),
      padding: EdgeInsets.symmetric(
        horizontal: displayWidth(context) * 0.04,
        vertical: displayHeight(context) * 0.015,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(displayWidth(context) * 0.02),
            decoration: const BoxDecoration(
              color: Color(0xFFEA6E7D),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: displayWidth(context) * 0.06,
            ),
          ),
          SizedBox(width: displayWidth(context) * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data["name"],
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.035,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                if (hasSubtitle)
                  SizedBox(height: displayHeight(context) * 0.005),
                if (hasSubtitle)
                  Text(
                    data["status_text"],
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.03,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          Icon(
            data["status_icon"],
            color: Colors.black87,
            size: displayWidth(context) * 0.05,
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
          "Absensi Peserta",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: displayWidth(context) * 0.05,
          ),
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: displayWidth(context) * 0.06,
          ),
          child: Column(
            children: [
              SizedBox(height: displayHeight(context) * 0.01),

              // --- BAGIAN ATAS (STATIC) ---

              // Card Waktu & Tanggal
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: displayHeight(context) * 0.03,
                  horizontal: displayWidth(context) * 0.04,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.04,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Jam
                        Column(
                          children: [
                            Text(
                              "09:00",
                              style: TextStyle(
                                fontSize: displayWidth(context) * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "WIB",
                              style: TextStyle(
                                fontSize: displayWidth(context) * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        // Garis Merah
                        Container(
                          height: displayHeight(context) * 0.06,
                          width: 2,
                          color: const Color(0xFFEA6E7D),
                        ),

                        // Tanggal
                        Column(
                          children: [
                            Text(
                              "1 Januari",
                              style: TextStyle(
                                fontSize: displayWidth(context) * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "2024",
                              style: TextStyle(
                                fontSize: displayWidth(context) * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: displayHeight(context) * 0.02),
                    // Ringkasan Kehadiran
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                            displayWidth(context) * 0.015,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFFEA6E7D),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.people,
                            color: Colors.white,
                            size: displayWidth(context) * 0.04,
                          ),
                        ),
                        SizedBox(width: displayWidth(context) * 0.03),
                        Text(
                          "10 dari 12 peserta sudah Clock in",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.03,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.02),
              // Garis Pemisah Tipis
              Divider(color: Colors.grey[400], thickness: 1),
              SizedBox(height: displayHeight(context) * 0.02),
              // Search Bar
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: displayWidth(context) * 0.02,
                  vertical: displayHeight(context) * 0.005,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.08,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(displayWidth(context) * 0.015),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEA6E7D),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: displayWidth(context) * 0.04,
                      ),
                    ),
                    SizedBox(width: displayWidth(context) * 0.03),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Cari Nama Peserta",
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: displayWidth(context) * 0.035,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.02),

              // --- BAGIAN BAWAH (DINAMIS - UNTUK API) ---

              // List of Peserta Absensi
              Expanded(
                child: ListView.builder(
                  itemCount: absensiList.length,
                  itemBuilder: (context, index) {
                    return _buildAbsensiCard(absensiList[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
