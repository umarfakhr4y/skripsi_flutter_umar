part of '../../../conn/auth.dart';

class RiwayatEvaluasiMentor extends StatefulWidget {
  const RiwayatEvaluasiMentor({super.key});

  @override
  State<RiwayatEvaluasiMentor> createState() => _RiwayatEvaluasiMentorState();
}

class _RiwayatEvaluasiMentorState extends State<RiwayatEvaluasiMentor> {
  // Dummy data
  final List<Map<String, dynamic>> _evaluations = [
    {
      "id": 1,
      "month_year": "APRIL 2024",
      "name": "Ahmad Zulkarnain",
      "rating": 4.8,
      "feedback":
          "Kinerja sangat memuaskan bulan ini. Proaktif dalam menyelesaikan tugas backlog dan menunjukkan kemampuan problem-solving yang tajam. Selalu memberikan update tepat waktu dan membantu rekan tim lainnya.",
      "produktivitas": 5,
      "komunikasi": 4,
      "keahlian_teknis": 5,
      "isExpanded": true,
    },
    {
      "id": 2,
      "month_year": "MARET 2024",
      "name": "Siti Aminah",
      "rating": 4.5,
      "feedback":
          "Menunjukkan progres yang konsisten di bagian front-end. Komunikasi tim juga membaik..",
      "produktivitas": 4,
      "komunikasi": 5,
      "keahlian_teknis": 4,
      "isExpanded": false,
    },
    {
      "id": 3,
      "month_year": "FEBRUARI 2024",
      "name": "Budi Santoso",
      "rating": 3.9,
      "feedback":
          "Beberapa deadline terlewat di minggu kedua. Perlu pengawasan lebih ketat pada manajemen waktu.",
      "produktivitas": 3,
      "komunikasi": 4,
      "keahlian_teknis": 4,
      "isExpanded": false,
    },
    {
      "id": 4,
      "month_year": "JANUARI 2024",
      "name": "Lestari Putri",
      "rating": 4.2,
      "feedback":
          "Awal yang baik untuk program magang. Cepat beradaptasi dengan budaya perusahaan dan mulai menunjukkan hasil kerja yang baik.",
      "produktivitas": 4,
      "komunikasi": 4,
      "keahlian_teknis": 4,
      "isExpanded": false,
    },
  ];

  String _selectedPeserta = "Semua Peserta";
  bool _hasSearched = false;

  Widget _buildStars(int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < count ? Icons.star : Icons.star_border,
          color: const Color(0xFFE84C63),
          size: displayWidth(context) * 0.035,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE84C63)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Riwayat Evaluasi",
          style: TextStyle(
            color: const Color(0xFFE84C63),
            fontWeight: FontWeight.bold,
            fontSize: displayWidth(context) * 0.05,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: displayWidth(context) * 0.05,
            vertical: displayHeight(context) * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter Peserta Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(displayWidth(context) * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.04,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pilih Peserta",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: displayWidth(context) * 0.04,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.005),
                    Text(
                      "Pilih Peserta Magang",
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.03,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.02),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: displayWidth(context) * 0.03,
                        vertical: displayHeight(context) * 0.015,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(
                          displayWidth(context) * 0.02,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            color: Colors.grey[700],
                            size: displayWidth(context) * 0.05,
                          ),
                          SizedBox(width: displayWidth(context) * 0.02),
                          Expanded(
                            child: Text(
                              _selectedPeserta,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: displayWidth(context) * 0.035,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey[700],
                            size: displayWidth(context) * 0.05,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.02),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _hasSearched = true;
                          });
                        },
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: displayWidth(context) * 0.045,
                        ),
                        label: Text(
                          "Cari Riwayat",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE84C63),
                          padding: EdgeInsets.symmetric(
                            vertical: displayHeight(context) * 0.015,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              displayWidth(context) * 0.08,
                            ),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.04),

              if (_hasSearched) ...[
                // Hasil Evaluasi Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hasil Evaluasi",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: displayWidth(context) * 0.042,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "Menampilkan ${_evaluations.length} data",
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.03,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: displayHeight(context) * 0.02),

                // List Evaluasi
                ..._evaluations.map((eval) {
                  bool isExpanded = eval['isExpanded'];
                  return Container(
                    margin: EdgeInsets.only(
                      bottom: displayHeight(context) * 0.02,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        displayWidth(context) * 0.04,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        displayWidth(context) * 0.04,
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            // Left Red Border
                            Container(
                              width: displayWidth(context) * 0.015,
                              color: const Color(0xFFE84C63),
                            ),
                            // Content
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(
                                  displayWidth(context) * 0.04,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                eval['month_year'],
                                                style: TextStyle(
                                                  fontSize:
                                                      displayWidth(context) *
                                                      0.028,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color(
                                                    0xFFE84C63,
                                                  ),
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    displayHeight(context) *
                                                    0.005,
                                              ),
                                              Text(
                                                eval['name'],
                                                style: TextStyle(
                                                  fontSize:
                                                      displayWidth(context) *
                                                      0.042,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                displayWidth(context) * 0.025,
                                            vertical:
                                                displayHeight(context) * 0.005,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFDE8E8),
                                            borderRadius: BorderRadius.circular(
                                              displayWidth(context) * 0.04,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: const Color(0xFFE84C63),
                                                size:
                                                    displayWidth(context) *
                                                    0.035,
                                              ),
                                              SizedBox(
                                                width:
                                                    displayWidth(context) *
                                                    0.01,
                                              ),
                                              Text(
                                                eval['rating'].toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      displayWidth(context) *
                                                      0.035,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: displayHeight(context) * 0.015,
                                    ),
                                    Text(
                                      eval['feedback'],
                                      style: TextStyle(
                                        fontSize: displayWidth(context) * 0.035,
                                        color: Colors.grey[700],
                                        height: 1.4,
                                      ),
                                      maxLines: isExpanded ? null : 2,
                                      overflow: isExpanded
                                          ? TextOverflow.visible
                                          : TextOverflow.ellipsis,
                                    ),

                                    if (isExpanded) ...[
                                      SizedBox(
                                        height: displayHeight(context) * 0.02,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(
                                          displayWidth(context) * 0.04,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF9F9F9),
                                          borderRadius: BorderRadius.circular(
                                            displayWidth(context) * 0.03,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "RINCIAN PENILAIAN",
                                              style: TextStyle(
                                                fontSize:
                                                    displayWidth(context) *
                                                    0.028,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  displayHeight(context) *
                                                  0.015,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Produktivitas",
                                                  style: TextStyle(
                                                    fontSize:
                                                        displayWidth(context) *
                                                        0.032,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                _buildStars(
                                                  eval['produktivitas'],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  displayHeight(context) * 0.01,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Komunikasi",
                                                  style: TextStyle(
                                                    fontSize:
                                                        displayWidth(context) *
                                                        0.032,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                _buildStars(eval['komunikasi']),
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  displayHeight(context) * 0.01,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Keahlian Teknis",
                                                  style: TextStyle(
                                                    fontSize:
                                                        displayWidth(context) *
                                                        0.032,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                _buildStars(
                                                  eval['keahlian_teknis'],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],

                                    SizedBox(
                                      height: displayHeight(context) * 0.02,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            eval['isExpanded'] =
                                                !eval['isExpanded'];
                                          });
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              isExpanded
                                                  ? "TUTUP DETAIL"
                                                  : "LIHAT DETAIL",
                                              style: TextStyle(
                                                color: const Color(0xFFE84C63),
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    displayWidth(context) *
                                                    0.03,
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                                  displayWidth(context) * 0.01,
                                            ),
                                            Icon(
                                              isExpanded
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: const Color(0xFFE84C63),
                                              size:
                                                  displayWidth(context) * 0.04,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],

              SizedBox(height: displayHeight(context) * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
