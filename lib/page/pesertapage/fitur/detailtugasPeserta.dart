part of '../../../conn/auth.dart';

class DetailTugasPeserta extends StatefulWidget {
  final Map<String, dynamic>? task;
  const DetailTugasPeserta({super.key, this.task});

  @override
  State<DetailTugasPeserta> createState() => _DetailTugasPesertaState();
}

class _DetailTugasPesertaState extends State<DetailTugasPeserta> {
  bool _isSubmitting = false;
  final TextEditingController _catatanController = TextEditingController();
  List<File> _selectedFiles = [];

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        return "${parts[2]}-${parts[1]}-${parts[0]}";
      }
    } catch (_) {}
    return dateStr;
  }

  String _calculateTimeRemaining(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      DateTime dt = DateTime.parse(dateStr);
      DateTime today = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      DateTime target = DateTime(dt.year, dt.month, dt.day);
      int diff = target.difference(today).inDays;
      if (diff > 0) {
        return "Sisa $diff hari lagi";
      } else if (diff == 0) {
        return "Hari Ini";
      } else {
        return "Terlambat ${diff.abs()} hari";
      }
    } catch (_) {}
    return '-';
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.pickFiles(allowMultiple: true);
      if (result != null) {
        setState(() {
          _selectedFiles.addAll(
            result.paths
                .where((path) => path != null)
                .map((path) => File(path!)),
          );
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memilih file: $e')));
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  void _showSubmitModal(BuildContext context) {
    final int? taskId = widget.task?['id'];
    if (taskId == null) return;

    _catatanController.text = widget.task?['catatan_peserta']?.toString() ?? '';
    _selectedFiles.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: displayWidth(context) * 0.05,
                right: displayWidth(context) * 0.05,
                top: displayHeight(context) * 0.02,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom +
                    displayHeight(context) * 0.03,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle Bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.02),
                    Text(
                      'Kumpulkan Tugas',
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.02),
                    Text(
                      'Catatan / Penjelasan Jawaban (Opsional)',
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.033,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _catatanController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText:
                            'Tuliskan penjelasan mengenai pengumpulan Anda...',
                        hintStyle: TextStyle(
                          fontSize: displayWidth(context) * 0.032,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.02),
                    Text(
                      'File / Foto Lampiran',
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.033,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final result = await FilePicker.pickFiles(
                          allowMultiple: true,
                        );
                        if (result != null) {
                          setModalState(() {
                            _selectedFiles.addAll(
                              result.paths
                                  .where((p) => p != null)
                                  .map((p) => File(p!)),
                            );
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.attach_file,
                        color: Color(0xFFE84C63),
                      ),
                      label: const Text(
                        'Pilih File / Foto',
                        style: TextStyle(
                          color: Color(0xFFE84C63),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE84C63)),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    if (_selectedFiles.isNotEmpty)
                      ..._selectedFiles.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final f = entry.value;
                        final name = f.path.split('/').last;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.insert_drive_file,
                                size: 16,
                                color: Color(0xFFE84C63),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: displayWidth(context) * 0.032,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setModalState(() {
                                    _selectedFiles.removeAt(idx);
                                  });
                                },
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        );
                      }),
                    SizedBox(height: displayHeight(context) * 0.03),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () async {
                                setModalState(() {
                                  _isSubmitting = true;
                                });
                                final response =
                                    await PesertaService.submitPenugasan(
                                      id: taskId,
                                      catatanPeserta: _catatanController.text
                                          .trim(),
                                      files: _selectedFiles,
                                    );
                                setModalState(() {
                                  _isSubmitting = false;
                                });

                                if (context.mounted) {
                                  Navigator.pop(ctx);
                                  if (response['success'] == true) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          response['message'] ??
                                              'Tugas berhasil dikumpulkan!',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.pop(context, true);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          response['message'] ??
                                              'Gagal mengumpulkan tugas.',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE84C63),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Kirim Jawaban',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.task?['judul_tugas']?.toString() ?? 'Tanpa Judul';
    final deskripsi =
        widget.task?['deskripsi']?.toString() ?? 'Tidak ada deskripsi.';
    final status = widget.task?['status_tugas']?.toString() ?? 'Aktif';
    final deadlineStr = widget.task?['deadline']?.toString();
    final formattedDeadline = _formatDate(deadlineStr);
    final timeRemaining = _calculateTimeRemaining(deadlineStr);
    final mentorName =
        widget.task?['mentor']?['nama_lengkap']?.toString() ?? 'Mentor';
    final List<dynamic> fotoList = widget.task?['foto_petunjuk'] ?? [];
    final catatanMentor = widget.task?['catatan_mentor']?.toString();
    final catatanPeserta = widget.task?['catatan_peserta']?.toString();
    final List<dynamic> filePengumpulan =
        widget.task?['file_pengumpulan'] ?? [];

    String tagLabel = 'AKTIF';
    Color badgeColor = const Color(0xFFE3F2FD);
    Color badgeTextColor = const Color(0xFF1976D2);

    if (status == 'Revisi') {
      tagLabel = 'REVISI';
      badgeColor = const Color(0xFFFFF0E6);
      badgeTextColor = const Color(0xFFD9534F);
    } else if (status == 'Ditinjau') {
      tagLabel = 'DITINJAU';
      badgeColor = const Color(0xFFFFF8E1);
      badgeTextColor = const Color(0xFFB8860B);
    } else if (status == 'Selesai') {
      tagLabel = 'SELESAI';
      badgeColor = const Color(0xFFE8F5E9);
      badgeTextColor = const Color(0xFF2E7D32);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text(
          'Detail Tugas',
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
              // Header Tags
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: displayWidth(context) * 0.03,
                      vertical: displayHeight(context) * 0.005,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(
                        displayWidth(context) * 0.05,
                      ),
                    ),
                    child: Text(
                      tagLabel,
                      style: TextStyle(
                        color: badgeTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: displayWidth(context) * 0.03,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: displayHeight(context) * 0.015),

              // Title
              Text(
                title,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: displayWidth(context) * 0.055,
                  height: 1.2,
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.03),

              // Info Cards Row
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      label: 'DITUGASKAN OLEH',
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: displayWidth(context) * 0.045,
                            backgroundColor: Colors.grey[300],
                            child: Icon(
                              Icons.person,
                              color: Colors.grey[700],
                              size: displayWidth(context) * 0.05,
                            ),
                          ),
                          SizedBox(width: displayWidth(context) * 0.02),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mentorName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: displayWidth(context) * 0.035,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Mentor Magang',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: displayWidth(context) * 0.025,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: displayWidth(context) * 0.04),
                  Expanded(
                    child: _buildInfoCard(
                      label: 'TENGGAT WAKTU',
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: const Color(0xFFE84C63),
                            size: displayWidth(context) * 0.06,
                          ),
                          SizedBox(width: displayWidth(context) * 0.02),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formattedDeadline,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: displayWidth(context) * 0.035,
                                    color: Colors.black87,
                                  ),
                                ),
                                if (status != 'Selesai')
                                  Text(
                                    timeRemaining,
                                    style: TextStyle(
                                      color: const Color(0xFFE84C63),
                                      fontSize: displayWidth(context) * 0.025,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: displayHeight(context) * 0.03),

              // Alert Banner Catatan Revisi Mentor (jika ada)
              if (status == 'Revisi' &&
                  catatanMentor != null &&
                  catatanMentor.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(displayWidth(context) * 0.04),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0E6),
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.03,
                    ),
                    border: Border.all(
                      color: const Color(0xFFD9534F),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: const Color(0xFFD9534F),
                            size: displayWidth(context) * 0.05,
                          ),
                          SizedBox(width: displayWidth(context) * 0.02),
                          Text(
                            'Catatan Revisi dari Mentor',
                            style: TextStyle(
                              color: const Color(0xFFD9534F),
                              fontWeight: FontWeight.bold,
                              fontSize: displayWidth(context) * 0.038,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: displayHeight(context) * 0.01),
                      Text(
                        catatanMentor,
                        style: TextStyle(
                          color: const Color(0xFF8B221F),
                          fontSize: displayWidth(context) * 0.035,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.03),
              ],

              // Lampiran
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lampiran Instruksi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: displayWidth(context) * 0.04,
                      color: Colors.black87,
                    ),
                  ),
                  if (fotoList.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LampiranInstruksiMentor(
                              images: fotoList
                                  .map((e) => e.toString())
                                  .toList(),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Lihat Semua (${fotoList.length})',
                        style: TextStyle(
                          color: const Color(0xFFE84C63),
                          fontWeight: FontWeight.w600,
                          fontSize: displayWidth(context) * 0.03,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: displayHeight(context) * 0.015),
              _buildLampiranImage(fotoList),
              SizedBox(height: displayHeight(context) * 0.03),

              // Deskripsi Tugas
              Text(
                'Deskripsi Tugas',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: displayWidth(context) * 0.04,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.015),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(displayWidth(context) * 0.04),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.04,
                  ),
                ),
                child: Text(
                  deskripsi,
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.035,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.02),

              // Section Jawaban / Tugas yang Dikumpulkan (jika ada)
              if ((catatanPeserta != null && catatanPeserta.isNotEmpty) ||
                  filePengumpulan.isNotEmpty) ...[
                SizedBox(height: displayHeight(context) * 0.015),
                Text(
                  'Jawaban / Pengumpulan Anda',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: displayWidth(context) * 0.04,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.015),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(displayWidth(context) * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.04,
                    ),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (catatanPeserta != null &&
                          catatanPeserta.isNotEmpty) ...[
                        Text(
                          'Catatan Anda:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: displayWidth(context) * 0.032,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          catatanPeserta,
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.035,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (filePengumpulan.isNotEmpty) ...[
                        Text(
                          'File Terlampir (${filePengumpulan.length}):',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: displayWidth(context) * 0.032,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...filePengumpulan.map((fileUrl) {
                          final fileName = fileUrl.toString().split('/').last;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.attachment,
                                  size: 16,
                                  color: Color(0xFFE84C63),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    fileName,
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.032,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.02),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: displayWidth(context) * 0.05,
          right: displayWidth(context) * 0.05,
          top: displayHeight(context) * 0.015,
          bottom: displayHeight(context) * 0.02,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(child: _buildBottomButton(status)),
      ),
    );
  }

  Widget _buildBottomButton(String status) {
    if (status == 'Ditinjau') {
      return ElevatedButton.icon(
        onPressed: null,
        icon: Icon(
          Icons.hourglass_empty,
          color: Colors.white,
          size: displayWidth(context) * 0.05,
        ),
        label: Text(
          'Menunggu Review Mentor',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: displayWidth(context) * 0.04,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          disabledBackgroundColor: Colors.grey[500],
          padding: EdgeInsets.symmetric(
            vertical: displayHeight(context) * 0.018,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
          ),
        ),
      );
    } else if (status == 'Selesai') {
      return ElevatedButton.icon(
        onPressed: null,
        icon: Icon(
          Icons.check_circle,
          color: Colors.white,
          size: displayWidth(context) * 0.05,
        ),
        label: Text(
          'Tugas Disetujui (Selesai)',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: displayWidth(context) * 0.04,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          disabledBackgroundColor: const Color(0xFF4CAF50),
          padding: EdgeInsets.symmetric(
            vertical: displayHeight(context) * 0.018,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
          ),
        ),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: () => _showSubmitModal(context),
        icon: Icon(
          Icons.upload_file,
          color: Colors.white,
          size: displayWidth(context) * 0.05,
        ),
        label: Text(
          status == 'Revisi' ? 'Kumpulkan Ulang (Revisi)' : 'Kumpulkan Tugas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: displayWidth(context) * 0.04,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE84C63),
          padding: EdgeInsets.symmetric(
            vertical: displayHeight(context) * 0.018,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
          ),
        ),
      );
    }
  }

  Widget _buildInfoCard({required String label, required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: displayWidth(context) * 0.03,
        vertical: displayHeight(context) * 0.015,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: displayWidth(context) * 0.025,
            ),
          ),
          SizedBox(height: displayHeight(context) * 0.01),
          child,
        ],
      ),
    );
  }

  Widget _buildLampiranImage(List<dynamic> fotoList) {
    if (fotoList.isEmpty) {
      return Container(
        width: double.infinity,
        height: displayHeight(context) * 0.12,
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
          border: Border.all(color: Colors.grey.shade300),
        ),
        alignment: Alignment.center,
        child: Text(
          'Tidak ada lampiran instruksi.',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: displayWidth(context) * 0.035,
          ),
        ),
      );
    }

    final firstImage = fotoList[0].toString();
    final imageUrl = '$baseApiUrl/storage/$firstImage';
    final fileName = firstImage.split('/').last;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LampiranInstruksiMentor(
              images: fotoList.map((e) => e.toString()).toList(),
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: displayHeight(context) * 0.22,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
            ),
          ),
          padding: EdgeInsets.all(displayWidth(context) * 0.03),
          alignment: Alignment.bottomLeft,
          child: Row(
            children: [
              Icon(
                Icons.image_outlined,
                color: Colors.white,
                size: displayWidth(context) * 0.04,
              ),
              SizedBox(width: displayWidth(context) * 0.02),
              Expanded(
                child: Text(
                  fileName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: displayWidth(context) * 0.03,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
