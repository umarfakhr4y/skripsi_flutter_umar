part of '../../../conn/auth.dart';

class LiatPesertaMagangMentor extends StatefulWidget {
  const LiatPesertaMagangMentor({super.key});

  @override
  State<LiatPesertaMagangMentor> createState() =>
      _LiatPesertaMagangMentorState();
}

class _LiatPesertaMagangMentorState extends State<LiatPesertaMagangMentor> {
  final List<String> pesertaList = [
    "Umar Fakhriy",
    "Galuh Kirana",
    "Haikal Dzaky",
    "Ahmad Ghofur",
    "Fakrazi",
    "Novalino Hamid",
  ];

  Widget _buildPesertaCard(String name) {
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
              color: Color(
                0xFFEA6E7D,
              ), // Sedikit lebih soft dari merah utama untuk mengikuti desain UI
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
            child: Text(
              name,
              style: TextStyle(
                fontSize: displayWidth(context) * 0.035,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Peserta Magang",
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
              SizedBox(height: displayHeight(context) * 0.03),

              // List of Peserta
              Expanded(
                child: ListView.builder(
                  itemCount: pesertaList.length,
                  itemBuilder: (context, index) {
                    return _buildPesertaCard(pesertaList[index]);
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
