part of '../../../conn/auth.dart';

class TambahTugasMentor extends StatefulWidget {
  const TambahTugasMentor({super.key});

  @override
  State<TambahTugasMentor> createState() => _TambahTugasMentorState();
}

class _TambahTugasMentorState extends State<TambahTugasMentor> {
  // State for form
  bool isTugasIndividu = true;
  String? selectedPeserta =
      "Umar Fakhriy"; // Static dummy data, prepared for API

  // Nanti list ini akan diisi dari get API
  final List<String> listPeserta = [
    'Umar Fakhriy',
    'Galuh Kirana',
    'Haikal Dzaky',
  ];

  // Controllers for input fields
  final TextEditingController judulController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();

  @override
  void dispose() {
    judulController.dispose();
    deskripsiController.dispose();
    deadlineController.dispose();
    super.dispose();
  }

  void _submitData() {
    // Siap untuk dipost ke API
    print("=== DATA TUGAS ===");
    print("Tugas Individu: $isTugasIndividu");
    print("Peserta: $selectedPeserta");
    print("Judul: ${judulController.text}");
    print("Deskripsi: ${deskripsiController.text}");
    print("Deadline: ${deadlineController.text}");
    // TODO: Post to API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text(
          'Tambahkan Tugas',
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
          padding: EdgeInsets.all(displayWidth(context) * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox Tugas Individu
              Row(
                children: [
                  SizedBox(
                    width: displayWidth(context) * 0.06,
                    height: displayWidth(context) * 0.06,
                    child: Checkbox(
                      value: isTugasIndividu,
                      activeColor: const Color(0xFFE57373),
                      onChanged: (bool? value) {
                        setState(() {
                          isTugasIndividu = value ?? false;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: displayWidth(context) * 0.03),
                  Text(
                    'Tugas Individu',
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.035,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: displayHeight(context) * 0.02),

              // Dropdown Peserta
              _buildDropdownPeserta(),

              // Divider
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: displayWidth(context) * 0.02,
                ),
                child: const Divider(color: Colors.black, thickness: 1),
              ),
              SizedBox(height: displayHeight(context) * 0.02),

              // Text Fields
              _buildTextField(
                'Judul Tugas',
                'Masukan Judul Tugas',
                judulController,
              ),
              _buildTextField(
                'Deskripsi Tugas',
                'Masukan Deskripsi Tugas',
                deskripsiController,
                maxLines: 5,
              ),

              // Gambar Upload Section
              _buildImageUpload(),

              // Deadline Field
              _buildTextField(
                'Deadline',
                'Masukan Tenggat Waktu',
                deadlineController,
              ),

              SizedBox(height: displayHeight(context) * 0.02),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE57373),
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
                  child: Text(
                    'Tambah Tugas',
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: displayHeight(context) * 0.05,
              ), // extra padding at bottom
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownPeserta() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Peserta Magang',
          style: TextStyle(
            fontSize: displayWidth(context) * 0.035,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: displayHeight(context) * 0.01),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: displayWidth(context) * 0.03,
            vertical: displayHeight(context) * 0.005,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9), // Almost white
            borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedPeserta,
              hint: Text(
                "Pilih Peserta",
                style: TextStyle(fontSize: displayWidth(context) * 0.035),
              ),
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
                size: displayWidth(context) * 0.06,
              ),
              items: listPeserta.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFE57373),
                        radius: displayWidth(context) * 0.045,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: displayWidth(context) * 0.06,
                        ),
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
        SizedBox(height: displayHeight(context) * 0.02),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: displayWidth(context) * 0.035,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: displayHeight(context) * 0.01),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(fontSize: displayWidth(context) * 0.035),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: displayWidth(context) * 0.035,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: displayWidth(context) * 0.04,
                vertical: displayHeight(context) * 0.015,
              ),
            ),
          ),
        ),
        SizedBox(height: displayHeight(context) * 0.02),
      ],
    );
  }

  Widget _buildImageUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gambar',
          style: TextStyle(
            fontSize: displayWidth(context) * 0.035,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: displayHeight(context) * 0.01),
        Row(
          children: [
            // Dummy selected image placeholder
            Container(
              width: displayWidth(context) * 0.25,
              height: displayWidth(context) * 0.2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  displayWidth(context) * 0.03,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  displayWidth(context) * 0.03,
                ),
                child: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/QR_code_for_mobile_English_Wikipedia.svg/1200px-QR_code_for_mobile_English_Wikipedia.svg.png', // Temporary image
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image,
                    color: Colors.grey,
                    size: displayWidth(context) * 0.1,
                  ),
                ),
              ),
            ),
            SizedBox(width: displayWidth(context) * 0.03),

            // Upload button
            GestureDetector(
              onTap: () {
                // Action upload gambar disiapkan
                print("Tap upload gambar");
              },
              child: Container(
                width: displayWidth(context) * 0.22,
                height: displayWidth(context) * 0.2,
                decoration: BoxDecoration(
                  color: const Color(0xFFE57373),
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.04,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: displayWidth(context) * 0.1,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: displayHeight(context) * 0.02),
      ],
    );
  }
}
