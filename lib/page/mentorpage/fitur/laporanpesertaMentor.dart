part of '../../../conn/auth.dart';

class LaporanPesertaMentor extends StatefulWidget {
  const LaporanPesertaMentor({super.key});

  @override
  State<LaporanPesertaMentor> createState() => _LaporanPesertaMentorState();
}

class _LaporanPesertaMentorState extends State<LaporanPesertaMentor> {
  // State variables for form
  DateTime? selectedDate;
  final TextEditingController dateController = TextEditingController();

  String? selectedPeserta = 'Budi Santoso'; // Initial static dummy data

  // Nanti list ini akan diisi dari GET API
  final List<String> listPeserta = [
    'Budi Santoso',
    'Umar Fakhriy',
    'Galuh Kirana',
  ];

  bool hasSearched = false;

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  // Fungsi untuk memunculkan pop up kalender
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE84C63), // Red color theme
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFE84C63),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        // Format the date (e.g., 10/25/2023)
        dateController.text = "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }

  // Fungsi untuk melakukan pencarian
  void _searchLaporan() {
    // Siapkan data untuk dipost ke API atau untuk query GET
    print("=== PENCARIAN LAPORAN ===");
    print("Tanggal: ${selectedDate?.toIso8601String()}");
    print("Peserta: $selectedPeserta");

    // TODO: Connect to API

    setState(() {
      hasSearched = true; // Tampilkan hasil pencarian dummy untuk sementara
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text(
          'Laporan Harian',
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
              // Filter Card
              Container(
                padding: EdgeInsets.all(displayWidth(context) * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.04,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pilih Tanggal
                    Text(
                      'Pilih Tanggal',
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.035,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.01),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        // Mencegah keyboard muncul
                        child: TextField(
                          controller: dateController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              color: Colors.grey[600],
                              size: displayWidth(context) * 0.05,
                            ),
                            hintText: 'Pilih tanggal',
                            hintStyle: TextStyle(
                              fontSize: displayWidth(context) * 0.035,
                              color: Colors.grey[400],
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: displayHeight(context) * 0.015,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                displayWidth(context) * 0.02,
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                displayWidth(context) * 0.02,
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.025),

                    // Pilih Peserta
                    Text(
                      'Pilih Peserta',
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.035,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.01),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: displayWidth(context) * 0.03,
                        vertical: displayHeight(context) * 0.005,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(
                          displayWidth(context) * 0.02,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedPeserta,
                          hint: Text(
                            "Pilih Peserta",
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.035,
                            ),
                          ),
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black87,
                            size: displayWidth(context) * 0.06,
                          ),
                          items: listPeserta.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: Colors.grey[600],
                                    size: displayWidth(context) * 0.05,
                                  ),
                                  SizedBox(width: displayWidth(context) * 0.03),
                                  Text(
                                    value,
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.035,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPeserta = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.03),

                    // Button Cari Laporan
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _searchLaporan,
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: displayWidth(context) * 0.05,
                        ),
                        label: Text(
                          'Cari Laporan',
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE84C63),
                          padding: EdgeInsets.symmetric(
                            vertical: displayHeight(context) * 0.018,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              displayWidth(context) * 0.05,
                            ),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Hasil Pencarian Section
              if (hasSearched) ...[
                SizedBox(height: displayHeight(context) * 0.04),
                Text(
                  'Hasil Pencarian',
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.02),

                // Result Card
                Container(
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
                          // Card Content
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(
                                displayWidth(context) * 0.04,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header Row
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.grey[300],
                                        radius: displayWidth(context) * 0.055,
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.grey[600],
                                          size: displayWidth(context) * 0.07,
                                        ),
                                      ),
                                      SizedBox(
                                        width: displayWidth(context) * 0.03,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Budi Santoso",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    displayWidth(context) *
                                                    0.04,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  displayHeight(context) *
                                                  0.003,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_today,
                                                  size:
                                                      displayWidth(context) *
                                                      0.03,
                                                  color: Colors.grey[600],
                                                ),
                                                SizedBox(
                                                  width:
                                                      displayWidth(context) *
                                                      0.015,
                                                ),
                                                Text(
                                                  "25 Oktober 2023",
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize:
                                                        displayWidth(context) *
                                                        0.03,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              displayWidth(context) * 0.02,
                                          vertical:
                                              displayHeight(context) * 0.005,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                            displayWidth(context) * 0.03,
                                          ),
                                        ),
                                        child: Text(
                                          "Frontend Dev",
                                          style: TextStyle(
                                            fontSize:
                                                displayWidth(context) * 0.025,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: displayHeight(context) * 0.02,
                                  ),

                                  // Laporan Content Box
                                  Container(
                                    padding: EdgeInsets.all(
                                      displayWidth(context) * 0.04,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        displayWidth(context) * 0.02,
                                      ),
                                    ),
                                    child: Text(
                                      '"Hari ini saya mengerjakan modul autentikasi menggunakan Firebase dan memperbaiki bug pada halaman profil. Saya juga sempat berdiskusi dengan mentor mengenai struktur database untuk fitur selanjutnya."',
                                      style: TextStyle(
                                        fontSize: displayWidth(context) * 0.035,
                                        color: Colors.grey[700],
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: displayHeight(context) * 0.02,
                                  ),

                                  // Divider Bottom
                                  Divider(color: Colors.grey.shade300),

                                  // Action Button
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        print("Tap Beri Komentar");
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: displayHeight(context) * 0.005,
                                        ),
                                        child: Text(
                                          "Beri Komentar >",
                                          style: TextStyle(
                                            color: const Color(0xFFE84C63),
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                displayWidth(context) * 0.035,
                                          ),
                                        ),
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
                ),
              ],
              SizedBox(height: displayHeight(context) * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
