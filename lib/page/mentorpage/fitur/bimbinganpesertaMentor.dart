part of '../../../conn/auth.dart';

class BimbinganPesertaMentor extends StatefulWidget {
  const BimbinganPesertaMentor({super.key});

  @override
  State<BimbinganPesertaMentor> createState() => _BimbinganPesertaMentorState();
}

class _BimbinganPesertaMentorState extends State<BimbinganPesertaMentor> {
  String selectedTab = 'Diajukan';

  final List<Map<String, dynamic>> dummyBimbingan = [
    {
      "nama": "Umar Fakhriy",
      "tanggal": "5 Maret 2023",
      "materi": "Diskusi tentang cara menggunakan API dengan baik dan benar",
      "isExpanded": true,
    },
    {
      "nama": "Umar Fakhriy",
      "tanggal": "5 Maret 2023",
      "materi": "Diskusi tentang cara menggunakan API dengan baik dan benar",
      "isExpanded": false,
    },
    {
      "nama": "Umar Fakhriy",
      "tanggal": "5 Maret 2023",
      "materi": "Diskusi tentang cara menggunakan API dengan baik dan benar",
      "isExpanded": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text(
          'Bimbingan',
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
              // Custom Tab Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTab('Diajukan'),
                  _buildTab('Dijadwalkan'),
                  _buildTab('Riwayat'),
                ],
              ),
              SizedBox(height: displayHeight(context) * 0.03),
              // List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dummyBimbingan.length,
                itemBuilder: (context, index) {
                  return _buildBimbinganCard(index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String title) {
    final isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = title;
        });
      },
      child: Container(
        padding: EdgeInsets.only(bottom: displayHeight(context) * 0.005),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFFE57373) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: displayWidth(context) * 0.035,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.black : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildBimbinganCard(int index) {
    final bimbingan = dummyBimbingan[index];
    final isExpanded = bimbingan['isExpanded'] as bool;

    return Container(
      margin: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              setState(() {
                bimbingan['isExpanded'] = !isExpanded;
              });
            },
            contentPadding: EdgeInsets.symmetric(
              horizontal: displayWidth(context) * 0.04,
              vertical: displayHeight(context) * 0.005,
            ),
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFE57373),
              radius: displayWidth(context) * 0.055,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: displayWidth(context) * 0.07,
              ),
            ),
            title: Text(
              bimbingan['nama'],
              style: TextStyle(
                fontSize: displayWidth(context) * 0.035,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              bimbingan['tanggal'],
              style: TextStyle(
                fontSize: displayWidth(context) * 0.03,
                color: Colors.grey[600],
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: Colors.black,
              size: displayWidth(context) * 0.06,
            ),
          ),
          if (isExpanded)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                Container(
                  width: double.infinity,
                  color: const Color(0xFFF9F9F9),
                  padding: EdgeInsets.symmetric(
                    horizontal: displayWidth(context) * 0.06,
                    vertical: displayHeight(context) * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Materi yang ingin dibahas',
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.03,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: displayHeight(context) * 0.005),
                        child: Text(
                          bimbingan['materi'],
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.032,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE57373),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(displayWidth(context) * 0.04),
                      bottomRight: Radius.circular(displayWidth(context) * 0.04),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: displayHeight(context) * 0.015),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: displayWidth(context) * 0.06,
                                ),
                                SizedBox(height: displayHeight(context) * 0.005),
                                Text(
                                  'Setujui',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: displayWidth(context) * 0.025,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: displayHeight(context) * 0.015),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: displayWidth(context) * 0.05,
                                ),
                                SizedBox(height: displayHeight(context) * 0.005),
                                Text(
                                  'Tolak',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: displayWidth(context) * 0.025,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
