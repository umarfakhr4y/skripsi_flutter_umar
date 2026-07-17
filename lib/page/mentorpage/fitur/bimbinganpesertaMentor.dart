part of '../../../conn/auth.dart';

class BimbinganPesertaMentor extends StatefulWidget {
  const BimbinganPesertaMentor({super.key});

  @override
  State<BimbinganPesertaMentor> createState() => _BimbinganPesertaMentorState();
}

class _BimbinganPesertaMentorState extends State<BimbinganPesertaMentor> {
  String selectedTab = 'Diajukan';

  bool _isLoadingBimbingan = true;
  List<dynamic> _listBimbingan = [];
  Set<int> _expandedIds = {};

  @override
  void initState() {
    super.initState();
    _fetchBimbingan();
  }

  Future<void> _fetchBimbingan() async {
    setState(() {
      _isLoadingBimbingan = true;
    });
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/mentor/bimbingan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          _listBimbingan = result['data'] ?? [];
          _isLoadingBimbingan = false;
        });
      } else {
        setState(() {
          _isLoadingBimbingan = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingBimbingan = false;
      });
    }
  }

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
              _isLoadingBimbingan
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(
                          color: Color(0xFFE84C63),
                        ),
                      ),
                    )
                  : Builder(
                      builder: (context) {
                        final displayedList = _listBimbingan.where((item) {
                          String status = (item['status'] ?? '')
                              .toString()
                              .toLowerCase();
                          if (selectedTab == 'Diajukan')
                            return status == 'menunggu';
                          if (selectedTab == 'Dijadwalkan')
                            return status == 'disetujui';
                          if (selectedTab == 'Riwayat')
                            return status == 'selesai' || status == 'ditolak';
                          return false;
                        }).toList();

                        if (displayedList.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.only(
                              top: displayHeight(context) * 0.05,
                            ),
                            child: const Center(
                              child: Text(
                                "Belum ada data bimbingan",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: displayedList.length,
                          itemBuilder: (context, index) {
                            return _buildBimbinganCard(displayedList[index]);
                          },
                        );
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
              color: isSelected ? const Color(0xFFE84C63) : Colors.transparent,
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

  Widget _buildBimbinganCard(dynamic bimbingan) {
    final int bimbinganId = bimbingan['id'] ?? 0;
    final bool isExpanded = _expandedIds.contains(bimbinganId);

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
                if (isExpanded) {
                  _expandedIds.remove(bimbinganId);
                } else {
                  _expandedIds.add(bimbinganId);
                }
              });
            },
            contentPadding: EdgeInsets.symmetric(
              horizontal: displayWidth(context) * 0.04,
              vertical: displayHeight(context) * 0.005,
            ),
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFE84C63),
              radius: displayWidth(context) * 0.055,
              child: Text(
                (bimbingan['peserta']?['nama'] ?? 'U')[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              bimbingan['peserta']?['nama'] ?? 'Unknown',
              style: TextStyle(
                fontSize: displayWidth(context) * 0.035,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'Dijadwalkan pada :' + bimbingan['tanggal'] ?? '',
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
                        padding: EdgeInsets.only(
                          top: displayHeight(context) * 0.005,
                        ),
                        child: Text(
                          bimbingan['topik'] ?? '-',
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
                    color: const Color(0xFFE84C63),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(displayWidth(context) * 0.04),
                      bottomRight: Radius.circular(
                        displayWidth(context) * 0.04,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: displayHeight(context) * 0.015,
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: displayWidth(context) * 0.06,
                                ),
                                SizedBox(
                                  height: displayHeight(context) * 0.005,
                                ),
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
                            padding: EdgeInsets.symmetric(
                              vertical: displayHeight(context) * 0.015,
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: displayWidth(context) * 0.05,
                                ),
                                SizedBox(
                                  height: displayHeight(context) * 0.005,
                                ),
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
