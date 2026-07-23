part of '../../../conn/auth.dart';

class PersuratanPesertaMentordua extends StatefulWidget {
  const PersuratanPesertaMentordua({super.key});

  @override
  State<PersuratanPesertaMentordua> createState() =>
      _PersuratanPesertaMentorduaState();
}

class _PersuratanPesertaMentorduaState
    extends State<PersuratanPesertaMentordua> {
  // Data statis sementara sesuai desain
  final List<Map<String, dynamic>> dataPersuratan = [
    {
      "nama": "Budi Santoso",
      "jenis": "Surat Keterangan Magang",
      "tanggal": "12 Okt 2023",
      "status": "MENUNGGU",
      "image": "https://i.pravatar.cc/150?img=11",
      "initial": "BS",
    },
    {
      "nama": "Siti Aminah",
      "jenis": "Permohonan Data Riset",
      "tanggal": "10 Okt 2023",
      "status": "DISETUJUI",
      "image": "https://i.pravatar.cc/150?img=5",
      "initial": "SA",
    },
    {
      "nama": "Andi Pratama",
      "jenis": "Surat Pengantar Instansi",
      "tanggal": "14 Okt 2023",
      "status": "MENUNGGU",
      "image": "",
      "initial": "AP",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFEEEEEE),
        appBar: AppBar(
          backgroundColor: const Color(0xFFEEEEEE),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Persuratan & Perizinan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: displayWidth(context) * 0.05,
            ),
          ),
          centerTitle: false,
          bottom: TabBar(
            indicatorColor: const Color(0xFFE84C63),
            labelColor: const Color(0xFFE84C63),
            unselectedLabelColor: Colors.grey[600],
            labelStyle: TextStyle(
              fontSize: displayWidth(context) * 0.035,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: displayWidth(context) * 0.035,
            ),
            tabs: const [
              Tab(text: "Daftar Surat"),
              Tab(text: "Perizinan"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDaftarSurat(),
            const Center(child: Text("Halaman Perizinan")),
          ],
        ),
      ),
    );
  }

  Widget _buildDaftarSurat() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(displayWidth(context) * 0.05),
        child: Column(
          children: [
            // Search Bar & Filter
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: displayHeight(context) * 0.045,
                    padding: EdgeInsets.symmetric(
                      horizontal: displayWidth(context) * 0.04,
                      vertical: displayHeight(context) * 0.004,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        displayWidth(context) * 0.08,
                      ),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.search, color: Colors.grey[400]),
                        hintText: "Cari surat atau nama...",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: displayHeight(context) * 0.03),
            // ListView
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dataPersuratan.length,
              itemBuilder: (context, index) {
                final item = dataPersuratan[index];
                return _buildSuratCard(item);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuratCard(Map<String, dynamic> data) {
    return _ExpandableSuratCard(data: data);
  }
}

class _ExpandableSuratCard extends StatefulWidget {
  final Map<String, dynamic> data;

  const _ExpandableSuratCard({required this.data});

  @override
  State<_ExpandableSuratCard> createState() => _ExpandableSuratCardState();
}

class _ExpandableSuratCardState extends State<_ExpandableSuratCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
      ),
      child: Column(
        children: [
          // Header (always visible)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: EdgeInsets.all(displayWidth(context) * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  displayWidth(context) * 0.04,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFFE84C63),
                    radius: displayWidth(context) * 0.06,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: displayWidth(context) * 0.07,
                    ),
                  ),
                  SizedBox(width: displayWidth(context) * 0.04),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data['jenis'],
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.035,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: displayHeight(context) * 0.005),
                        Text(
                          widget.data['nama'],
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.03,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.black87,
                    size: displayWidth(context) * 0.06,
                  ),
                ],
              ),
            ),
          ),

          // Expanded Content
          if (_isExpanded) ...[
            Divider(color: Colors.grey[200], height: 1),
            Padding(
              padding: EdgeInsets.all(displayWidth(context) * 0.04),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoItem("Nama Pemohon", widget.data['nama']),
                        SizedBox(height: displayHeight(context) * 0.015),
                        _buildInfoItem("Perihal Surat", widget.data['jenis']),
                        SizedBox(height: displayHeight(context) * 0.015),
                        _buildInfoItem(
                          "Tanggal Pengajuan",
                          widget.data['tanggal'],
                        ),
                        SizedBox(height: displayHeight(context) * 0.015),
                        _buildInfoItem(
                          "Status",
                          widget.data['status'],
                          isStatus: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Action Bar
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE84C63),
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
                        padding: EdgeInsets.symmetric(
                          vertical: displayHeight(context) * 0.015,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                              size: displayWidth(context) * 0.06,
                            ),
                            SizedBox(height: displayHeight(context) * 0.005),
                            Text(
                              "Lihat Detail",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: displayWidth(context) * 0.025,
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
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, {bool isStatus = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: displayWidth(context) * 0.03,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: displayHeight(context) * 0.005),
        Padding(
          padding: EdgeInsets.only(left: displayWidth(context) * 0.02),
          child: isStatus
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: value == 'MENUNGGU'
                        ? Colors.orange.withOpacity(0.15)
                        : Colors.pink.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.025,
                      fontWeight: FontWeight.bold,
                      color: value == 'MENUNGGU'
                          ? Colors.orange[700]
                          : Colors.pink[700],
                    ),
                  ),
                )
              : Text(
                  value,
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.03,
                    color: Colors.grey[600],
                  ),
                ),
        ),
      ],
    );
  }
}
