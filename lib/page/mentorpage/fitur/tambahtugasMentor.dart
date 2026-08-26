part of '../../../conn/auth.dart';

class TambahTugasMentor extends StatefulWidget {
  final Map<String, dynamic>? editTask;
  const TambahTugasMentor({super.key, this.editTask});

  @override
  State<TambahTugasMentor> createState() => _TambahTugasMentorState();
}

class _TambahTugasMentorState extends State<TambahTugasMentor> {
  // State for form
  bool isTugasIndividu = true;
  List<Map<String, dynamic>> listPeserta = [];
  Map<String, dynamic>? selectedPeserta;
  bool _isLoadingPeserta = true;
  String _selectedStatus = 'Aktif';
  List<String> _existingImages = [];

  // Controllers for input fields
  final TextEditingController judulController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.editTask != null) {
      judulController.text = widget.editTask!['judul_tugas'] ?? '';
      deskripsiController.text = widget.editTask!['deskripsi'] ?? '';
      _selectedStatus = widget.editTask!['status_tugas'] ?? 'Aktif';
      String dl = widget.editTask!['deadline'] ?? '';
      if (dl.isNotEmpty) {
        try {
          DateTime dt;
          if (dl.contains('-') && dl.split('-')[0].length == 4) {
            dt = DateTime.parse(dl);
          } else {
            final p = dl.split('-');
            dt = DateTime(int.parse(p[2]), int.parse(p[1]), int.parse(p[0]));
          }
          _selectedDeadlineDate = dt;
          deadlineController.text =
              "${dt.day.toString().padLeft(2, '0')} ${dt.month.toString().padLeft(2, '0')} ${dt.year}";
        } catch (_) {
          deadlineController.text = dl;
        }
      }
      if (widget.editTask!['foto_petunjuk'] != null &&
          widget.editTask!['foto_petunjuk'] is List) {
        _existingImages = (widget.editTask!['foto_petunjuk'] as List)
            .map((e) => e.toString())
            .toList();
      }
    }
    _fetchPeserta();
  }

  Future<void> _fetchPeserta() async {
    setState(() {
      _isLoadingPeserta = true;
    });
    final result = await MentorService.getPesertaAbsensi();
    if (mounted) {
      if (result['success'] && result['data'] is List) {
        final List<dynamic> data = result['data'];
        setState(() {
          listPeserta = data
              .map((item) => item as Map<String, dynamic>)
              .toList();
          if (widget.editTask != null && widget.editTask!['peserta'] != null) {
            final targetId = widget.editTask!['peserta']['id'];
            try {
              selectedPeserta = listPeserta.firstWhere(
                (p) => p['id'] == targetId,
              );
            } catch (_) {
              if (listPeserta.isNotEmpty) selectedPeserta = listPeserta.first;
            }
          } else if (listPeserta.isNotEmpty) {
            selectedPeserta = listPeserta.first;
          }
          _isLoadingPeserta = false;
        });
      } else {
        setState(() {
          _isLoadingPeserta = false;
        });
      }
    }
  }

  List<File> _selectedImages = [];
  bool _isSubmitting = false;
  DateTime? _selectedDeadlineDate;

  @override
  void dispose() {
    judulController.dispose();
    deskripsiController.dispose();
    deadlineController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'gif'],
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        for (var file in result.files) {
          if (file.path != null) {
            final f = File(file.path!);
            if (f.existsSync()) {
              _selectedImages.add(f);
            }
          }
        }
      });
    }
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingImages.removeAt(index);
    });
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _selectDeadline() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE84C63),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDeadlineDate = picked;
        deadlineController.text =
            "${picked.day.toString().padLeft(2, '0')} ${picked.month.toString().padLeft(2, '0')} ${picked.year}";
      });
    }
  }

  Future<void> _submitData() async {
    if (selectedPeserta == null || selectedPeserta?['id'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pilih peserta magang terlebih dahulu"),
          backgroundColor: Color(0xFFE84C63),
        ),
      );
      return;
    }

    if (judulController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Judul tugas tidak boleh kosong"),
          backgroundColor: Color(0xFFE84C63),
        ),
      );
      return;
    }

    if (deskripsiController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Deskripsi tugas tidak boleh kosong"),
          backgroundColor: Color(0xFFE84C63),
        ),
      );
      return;
    }

    if (deadlineController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Deadline tugas harus dipilih"),
          backgroundColor: Color(0xFFE84C63),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final int pesertaId = int.tryParse(selectedPeserta!['id'].toString()) ?? 0;

    String deadlineForApi = "";
    if (_selectedDeadlineDate != null) {
      deadlineForApi =
          "${_selectedDeadlineDate!.year}-${_selectedDeadlineDate!.month.toString().padLeft(2, '0')}-${_selectedDeadlineDate!.day.toString().padLeft(2, '0')}";
    } else {
      deadlineForApi = deadlineController.text.trim();
    }

    Map<String, dynamic> result;
    if (widget.editTask != null) {
      final int id = int.tryParse(widget.editTask!['id'].toString()) ?? 0;
      result = await MentorService.updatePenugasan(
        id: id,
        pesertaId: pesertaId,
        judulTugas: judulController.text.trim(),
        deskripsi: deskripsiController.text.trim(),
        deadline: deadlineForApi,
        statusTugas: _selectedStatus,
        fotoPetunjuk: _selectedImages,
        existingFotoPetunjuk: _existingImages,
      );
    } else {
      result = await MentorService.createPenugasan(
        pesertaId: pesertaId,
        judulTugas: judulController.text.trim(),
        deskripsi: deskripsiController.text.trim(),
        deadline: deadlineForApi,
        fotoPetunjuk: _selectedImages,
      );
    }

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ??
                  (widget.editTask != null
                      ? 'Tugas berhasil diperbarui!'
                      : 'Tugas berhasil ditambahkan!'),
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ?? 'Gagal membuat tugas. Silakan coba lagi.',
            ),
            backgroundColor: const Color(0xFFE84C63),
          ),
        );
      }
    }
  }

  Widget _buildStatusDropdown() {
    return Padding(
      padding: EdgeInsets.only(bottom: displayHeight(context) * 0.025),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status Tugas',
            style: TextStyle(
              fontSize: displayWidth(context) * 0.04,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: displayHeight(context) * 0.01),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: displayWidth(context) * 0.04,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedStatus,
                isExpanded: true,
                items: ['Aktif', 'Ditinjau', 'Selesai']
                    .map(
                      (status) =>
                          DropdownMenuItem(value: status, child: Text(status)),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedStatus = val;
                    });
                  }
                },
              ),
            ),
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
        title: Text(
          widget.editTask != null ? 'Edit Tugas' : 'Tambahkan Tugas',
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
                'Pilih Tenggat Waktu',
                deadlineController,
                readOnly: true,
                onTap: _selectDeadline,
              ),

              if (widget.editTask != null) _buildStatusDropdown(),

              SizedBox(height: displayHeight(context) * 0.02),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE84C63),
                    disabledBackgroundColor: Colors.grey,
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
                  child: _isSubmitting
                      ? SizedBox(
                          height: displayWidth(context) * 0.05,
                          width: displayWidth(context) * 0.05,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          widget.editTask != null
                              ? 'Simpan Perubahan'
                              : 'Tambah Tugas',
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
          child: _isLoadingPeserta
              ? Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: displayHeight(context) * 0.015,
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Color(0xFFE84C63),
                      ),
                    ),
                  ),
                )
              : DropdownButtonHideUnderline(
                  child: DropdownButton<Map<String, dynamic>>(
                    isExpanded: true,
                    value: selectedPeserta,
                    hint: Text(
                      listPeserta.isEmpty
                          ? "Tidak ada peserta magang"
                          : "Pilih Peserta",
                      style: TextStyle(fontSize: displayWidth(context) * 0.035),
                    ),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                      size: displayWidth(context) * 0.06,
                    ),
                    items: listPeserta.map((Map<String, dynamic> value) {
                      String nama =
                          value['nama_lengkap']?.toString() ?? 'Tanpa Nama';
                      String nim = value['nim']?.toString() ?? '-';
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: value,
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFFE84C63),
                              radius: displayWidth(context) * 0.045,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: displayWidth(context) * 0.06,
                              ),
                            ),
                            SizedBox(width: displayWidth(context) * 0.03),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    nama,
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.035,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    nim,
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.028,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (Map<String, dynamic>? newValue) {
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
    bool readOnly = false,
    VoidCallback? onTap,
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
            readOnly: readOnly,
            onTap: onTap,
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
          'Foto Petunjuk (Bisa >1 foto)',
          style: TextStyle(
            fontSize: displayWidth(context) * 0.035,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: displayHeight(context) * 0.01),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ..._existingImages.asMap().entries.map((entry) {
                int idx = entry.key;
                String path = entry.value;
                String fullUrl = path.startsWith('http')
                    ? path
                    : '$baseApiUrl/storage/$path';
                return Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        right: displayWidth(context) * 0.03,
                      ),
                      width: displayWidth(context) * 0.22,
                      height: displayWidth(context) * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          displayWidth(context) * 0.03,
                        ),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          displayWidth(context) * 0.03,
                        ),
                        child: Image.network(
                          fullUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: displayWidth(context) * 0.035,
                      child: GestureDetector(
                        onTap: () => _removeExistingImage(idx),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE84C63),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: displayWidth(context) * 0.035,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              ..._selectedImages.asMap().entries.map((entry) {
                int idx = entry.key;
                File file = entry.value;
                return Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        right: displayWidth(context) * 0.03,
                      ),
                      width: displayWidth(context) * 0.22,
                      height: displayWidth(context) * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          displayWidth(context) * 0.03,
                        ),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          displayWidth(context) * 0.03,
                        ),
                        child: Image.file(file, fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: displayWidth(context) * 0.035,
                      child: GestureDetector(
                        onTap: () => _removeImage(idx),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE84C63),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: displayWidth(context) * 0.035,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),

              // Upload button
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  width: displayWidth(context) * 0.22,
                  height: displayWidth(context) * 0.2,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE84C63),
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.04,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        color: Colors.white,
                        size: displayWidth(context) * 0.08,
                      ),
                      SizedBox(height: displayHeight(context) * 0.003),
                      Text(
                        'Upload',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: displayWidth(context) * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: displayHeight(context) * 0.02),
      ],
    );
  }
}
