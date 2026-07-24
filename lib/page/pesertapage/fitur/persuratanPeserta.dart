part of '../../../conn/auth.dart';

class PersuratanPeserta extends StatefulWidget {
  const PersuratanPeserta({super.key});

  @override
  State<PersuratanPeserta> createState() => _PersuratanPesertaState();
}

class _PersuratanPesertaState extends State<PersuratanPeserta> {
  int _selectedTab = 0; // 0: Aktif, 1: Riwayat
  final TextEditingController _jenisSuratController = TextEditingController();
  final TextEditingController _keperluanController = TextEditingController();
  String? _selectedFileName;
  String? _selectedFilePath;
  bool _isSubmitting = false;
  bool _isLoadingData = true;
  List<dynamic> _persuratanList = [];

  @override
  void initState() {
    super.initState();
    _fetchPersuratanData();
  }

  Future<void> _fetchPersuratanData() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access_token');

    if (token == null) {
      if (mounted) setState(() => _isLoadingData = false);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/peserta/persuratan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          final fetchedData = data['data'] as List<dynamic>;

          if (mounted) {
            List<Future<void>> precacheTasks = [];
            for (var item in fetchedData) {
              final linkDokumen = item['link_dokumen']?.toString();
              if (linkDokumen != null) {
                final isImage =
                    linkDokumen.toLowerCase().endsWith('.jpg') ||
                    linkDokumen.toLowerCase().endsWith('.jpeg') ||
                    linkDokumen.toLowerCase().endsWith('.png');
                if (isImage) {
                  precacheTasks.add(
                    precacheImage(
                      NetworkImage('http://10.0.2.2:8000/storage/$linkDokumen'),
                      context,
                    ),
                  );
                }
              }
              final filePendukung = item['file_pendukung']?.toString();
              if (filePendukung != null) {
                final isImage2 =
                    filePendukung.toLowerCase().endsWith('.jpg') ||
                    filePendukung.toLowerCase().endsWith('.jpeg') ||
                    filePendukung.toLowerCase().endsWith('.png');
                if (isImage2) {
                  precacheTasks.add(
                    precacheImage(
                      NetworkImage(
                        'http://10.0.2.2:8000/storage/$filePendukung',
                      ),
                      context,
                    ),
                  );
                }
              }
            }

            if (precacheTasks.isNotEmpty) {
              await Future.wait(precacheTasks).catchError((_) => []);
            }

            if (mounted) {
              setState(() {
                _persuratanList = fetchedData;
                _isLoadingData = false;
              });
            }
          }
        }
      } else {
        if (mounted) setState(() => _isLoadingData = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingData = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFAD3B3E)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Persuratan dan Perizinan',
          style: TextStyle(
            color: Color(0xFFAD3B3E),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Buttons
            Row(
              children: [
                Expanded(
                  child: _buildTopButton(
                    title: '+ Request\nSurat',
                    icon: Icons.description,
                    isPrimary: true,
                    onTap: _showRequestSuratDialog,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTopButton(
                    title: '+ Izin\nKehadiran',
                    icon: Icons.calendar_today_outlined,
                    isPrimary: false,
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Custom Tabs
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTab = 0;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedTab == 0
                                ? const Color(0xFFAD3B3E)
                                : Colors.grey.shade300,
                            width: _selectedTab == 0 ? 2 : 1,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Persuratan',
                        style: TextStyle(
                          color: _selectedTab == 0
                              ? const Color(0xFFAD3B3E)
                              : const Color(0xFF666666),
                          fontWeight: _selectedTab == 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTab = 1;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedTab == 1
                                ? const Color(0xFFAD3B3E)
                                : Colors.grey.shade300,
                            width: _selectedTab == 1 ? 2 : 1,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Perizinan',
                        style: TextStyle(
                          color: _selectedTab == 1
                              ? const Color(0xFFAD3B3E)
                              : const Color(0xFF666666),
                          fontWeight: _selectedTab == 1
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (_isLoadingData)
              ...List.generate(
                3,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              width: 4,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 150,
                                          height: 18,
                                          color: Colors.white,
                                        ),
                                        Container(
                                          width: 80,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      width: double.infinity,
                                      height: 12,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      width: 200,
                                      height: 12,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      width: 120,
                                      height: 12,
                                      color: Colors.white,
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
                ),
              )
            else if (_persuratanList.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Belum ada riwayat pengajuan surat.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ..._persuratanList.map((item) {
                String statusText;
                IconData statusIcon;
                Color statusColor;
                Color statusBgColor;
                String? catatanTitle;
                Color? catatanColor;

                switch (item['status']) {
                  case 'diproses':
                    statusText = 'Sedang Diproses';
                    statusIcon = Icons.remove_circle_outline;
                    statusColor = Colors.blue;
                    statusBgColor = Colors.blue.withOpacity(0.15);
                    catatanTitle = 'PESAN DARI MENTOR';
                    catatanColor = Colors.blue;
                    break;
                  case 'selesai':
                    statusText = 'Selesai';
                    statusIcon = Icons.check_circle;
                    statusColor = Colors.green;
                    statusBgColor = Colors.green.withOpacity(0.15);
                    catatanTitle = 'PESAN DARI MENTOR';
                    catatanColor = Colors.green;
                    break;
                  case 'ditolak':
                    statusText = 'Ditolak';
                    statusIcon = Icons.cancel;
                    statusColor = const Color(0xFFC7282A);
                    statusBgColor = const Color(0xFFF7D8D8);
                    catatanTitle = 'ALASAN PENOLAKAN';
                    catatanColor = const Color(0xFFC7282A);
                    break;
                  case 'pending':
                  default:
                    statusText = 'Menunggu';
                    statusIcon = Icons.access_time;
                    statusColor = Colors.orange;
                    statusBgColor = Colors.orange.withOpacity(0.15);
                    catatanTitle = 'PESAN DARI MENTOR';
                    catatanColor = Colors.orange;
                    break;
                }

                String dateText =
                    'Diajukan: ${item['created_at'] != null ? item['created_at'].toString().substring(0, 10) : '-'}';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildRequestCard(
                    borderColor: statusColor,
                    title: item['jenis_surat'] ?? 'Tidak ada judul',
                    statusText: statusText,
                    statusIcon: statusIcon,
                    statusColor: statusColor,
                    statusBgColor: statusBgColor,
                    description: item['keperluan'] ?? '-',
                    dateText: dateText,
                    linkDokumen: item['link_dokumen'],
                    catatanMentor: item['catatan_mentor'],
                    catatanTitle: catatanTitle,
                    catatanColor: catatanColor,
                    filePendukung: item['file_pendukung'],
                  ),
                );
              }).toList(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _submitRequestSurat() async {
    if (_jenisSuratController.text.trim().isEmpty ||
        _keperluanController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jenis Surat dan Keperluan wajib diisi!')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      if (token == null) {
        throw Exception('Token tidak ditemukan, silakan login ulang.');
      }

      var uri = Uri.parse('http://10.0.2.2:8000/api/peserta/persuratan');
      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields['jenis_surat'] = _jenisSuratController.text.trim();
      request.fields['keperluan'] = _keperluanController.text.trim();

      if (_selectedFilePath != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file_pendukung',
            _selectedFilePath!,
          ),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pengajuan surat berhasil dikirim!')),
          );
          Navigator.pop(context); // Tutup dialog
          _fetchPersuratanData(); // Refresh list after successful submit
        }
      } else {
        throw Exception(
          'Gagal mengirim pengajuan surat: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showRequestSuratDialog() {
    String? selectedJenisSurat;
    _jenisSuratController.clear();
    _keperluanController.clear();
    _selectedFileName = null;
    _selectedFilePath = null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Request Surat',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFAD3B3E),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jenis Surat',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: 'Pilih Jenis Surat',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      value: selectedJenisSurat,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                      ),
                      isExpanded: true,
                      items:
                          [
                            'Surat Keterangan Aktif Magang',
                            'Surat Keterangan Selesai Magang',
                            'Surat Izin Observasi / Penelitian',
                            'Surat Lembar Penilaian / Evaluasi Magang',
                            'Lainnya',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(fontSize: 13),
                              ),
                            );
                          }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setStateDialog(() {
                            selectedJenisSurat = newValue;
                            if (newValue != 'Lainnya') {
                              _jenisSuratController.text = newValue;
                            } else {
                              _jenisSuratController.clear();
                            }
                          });
                        }
                      },
                    ),
                    if (selectedJenisSurat == 'Lainnya') ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Jenis Surat Lainnya',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _jenisSuratController,
                        decoration: InputDecoration(
                          hintText: 'Cth: Surat Keterangan Sakit / Cuti',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    const Text(
                      'Keperluan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _keperluanController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Jelaskan keperluan surat...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'File Pendukung (Opsional)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        FilePickerResult? result = await FilePicker.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: [
                            'jpg',
                            'jpeg',
                            'png',
                            'pdf',
                            'doc',
                            'docx',
                          ],
                        );

                        if (result != null) {
                          setStateDialog(() {
                            _selectedFileName = result.files.single.name;
                            _selectedFilePath = result.files.single.path;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.upload_file,
                              color: Colors.grey.shade600,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _selectedFileName ?? 'Pilih file (Max 5MB)',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _selectedFileName != null
                                      ? Colors.black87
                                      : Colors.grey.shade600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => Navigator.pop(context),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitRequestSurat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAD3B3E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Kirim',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTopButton({
    required String title,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFFE96C72) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isPrimary
            ? null
            : Border.all(color: const Color(0xFFE96C72), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isPrimary
                      ? const Color(0xFFD3555D)
                      : const Color(0xFFFCEDEE),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isPrimary ? Colors.white : const Color(0xFFE96C72),
                  size: 20,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isPrimary ? Colors.white : const Color(0xFFAD3B3E),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard({
    required Color borderColor,
    required String title,
    required String statusText,
    required IconData statusIcon,
    required Color statusColor,
    required Color statusBgColor,
    required String description,
    String? dateText,
    String? linkDokumen,
    String? catatanMentor,
    String? catatanTitle,
    Color? catatanColor,
    String? filePendukung,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Colored left border
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ),
            // Card Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(statusIcon, size: 12, color: statusColor),
                              const SizedBox(width: 4),
                              Text(
                                statusText,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                    if (dateText != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            dateText,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (filePendukung != null) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'File Pendukung Anda:',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (filePendukung.toLowerCase().endsWith('.jpg') ||
                          filePendukung.toLowerCase().endsWith('.jpeg') ||
                          filePendukung.toLowerCase().endsWith('.png'))
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  insetPadding: const EdgeInsets.all(10),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      InteractiveViewer(
                                        panEnabled: true,
                                        minScale: 0.5,
                                        maxScale: 4.0,
                                        child: Image.network(
                                          'http://10.0.2.2:8000/storage/$filePendukung',
                                          fit: BoxFit.contain,
                                          loadingBuilder:
                                              (
                                                BuildContext context,
                                                Widget child,
                                                ImageChunkEvent?
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child: CircularProgressIndicator(
                                                    value:
                                                        loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                        : null,
                                                    color: Colors.white,
                                                  ),
                                                );
                                              },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Center(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.broken_image,
                                                          color: Colors.white,
                                                          size: 50,
                                                        ),
                                                        SizedBox(height: 8),
                                                        Text(
                                                          'Gagal memuat gambar',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'http://10.0.2.2:8000/storage/$filePendukung',
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (
                                    BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      height: 80,
                                      width: 80,
                                      color: Colors.grey.shade200,
                                      child: const Center(
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Color(0xFFAD3B3E),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    height: 80,
                                    width: 80,
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                        )
                      else
                        InkWell(
                          onTap: () async {
                            final url = Uri.parse(
                              'http://10.0.2.2:8000/storage/$filePendukung',
                            );
                            try {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                            } catch (e) {
                              print('Could not launch $url: $e');
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.insert_drive_file,
                                  size: 16,
                                  color: Colors.grey.shade700,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Lihat Dokumen',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                    if (catatanMentor != null || linkDokumen != null) ...[
                      const SizedBox(height: 16),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 8),
                      const Text(
                        "Balasan Dari Mentor :",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (catatanMentor != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (catatanColor ?? const Color(0xFFC7282A))
                                .withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                catatanTitle ?? 'CATATAN',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      catatanColor ?? const Color(0xFFC7282A),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                catatanMentor,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                  fontStyle: FontStyle.italic,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (linkDokumen != null) ...[
                        const SizedBox(height: 16),
                        Builder(
                          builder: (context) {
                            final isImage =
                                linkDokumen.toLowerCase().endsWith('.jpg') ||
                                linkDokumen.toLowerCase().endsWith('.jpeg') ||
                                linkDokumen.toLowerCase().endsWith('.png');

                            if (isImage) {
                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        backgroundColor: Colors.transparent,
                                        insetPadding: const EdgeInsets.all(10),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            InteractiveViewer(
                                              panEnabled: true,
                                              minScale: 0.5,
                                              maxScale: 4.0,
                                              child: Image.network(
                                                'http://10.0.2.2:8000/storage/$linkDokumen',
                                                fit: BoxFit.contain,
                                                loadingBuilder:
                                                    (
                                                      BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                      loadingProgress,
                                                    ) {
                                                      if (loadingProgress ==
                                                          null)
                                                        return child;
                                                      return SizedBox(
                                                        width: 300,
                                                        height: 300,
                                                        child: Center(
                                                          child: CircularProgressIndicator(
                                                            value:
                                                                loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                          .cumulativeBytesLoaded /
                                                                      loadingProgress
                                                                          .expectedTotalBytes!
                                                                : null,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => const SizedBox(
                                                      width: 300,
                                                      height: 300,
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .broken_image,
                                                              color:
                                                                  Colors.white,
                                                              size: 50,
                                                            ),
                                                            SizedBox(height: 8),
                                                            Text(
                                                              'Gagal memuat gambar',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 10,
                                              right: 10,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.download,
                                                      color: Colors.white,
                                                      size: 30,
                                                    ),
                                                    onPressed: () async {
                                                      final url = Uri.parse(
                                                        'http://10.0.2.2:8000/storage/$linkDokumen',
                                                      );
                                                      try {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                              'Menyimpan gambar...',
                                                            ),
                                                            duration: Duration(
                                                              seconds: 1,
                                                            ),
                                                          ),
                                                        );
                                                        final request =
                                                            await HttpClient()
                                                                .getUrl(url);
                                                        final response =
                                                            await request
                                                                .close();
                                                        if (response
                                                                .statusCode ==
                                                            200) {
                                                          final bytes =
                                                              await consolidateHttpClientResponseBytes(
                                                                response,
                                                              );
                                                          await Gal.putImageBytes(
                                                            bytes,
                                                          );
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                'Gambar berhasil disimpan ke Galeri!',
                                                              ),
                                                            ),
                                                          );
                                                        } else {
                                                          throw Exception(
                                                            'Gagal mengunduh: ${response.statusCode}',
                                                          );
                                                        }
                                                      } catch (e) {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'Gagal menyimpan gambar: $e',
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  const SizedBox(width: 8),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size: 30,
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    'http://10.0.2.2:8000/storage/$linkDokumen',
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (
                                          BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress,
                                        ) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            width: double.infinity,
                                            height: 150,
                                            color: Colors.grey.shade200,
                                            child: const Center(
                                              child: SizedBox(
                                                width: 24,
                                                height: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Color(0xFFAD3B3E),
                                                    ),
                                              ),
                                            ),
                                          );
                                        },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              width: double.infinity,
                                              height: 150,
                                              color: Colors.grey.shade200,
                                              child: const Icon(
                                                Icons.broken_image,
                                                color: Colors.grey,
                                              ),
                                            ),
                                  ),
                                ),
                              );
                            }

                            return InkWell(
                              onTap: () async {
                                final url = Uri.parse(
                                  'http://10.0.2.2:8000/storage/$linkDokumen',
                                );
                                try {
                                  await launchUrl(
                                    url,
                                    mode: LaunchMode.externalApplication,
                                  );
                                } catch (e) {
                                  print('Could not launch $url: $e');
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFDF6F6),
                                  border: Border.all(
                                    color: const Color(
                                      0xFFE96C72,
                                    ).withOpacity(0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.download_outlined,
                                      size: 16,
                                      color: Color(0xFFAD3B3E),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Download Dokumen Balasan',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFAD3B3E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
