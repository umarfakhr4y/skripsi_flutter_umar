part of '../../../conn/auth.dart';

class PersuratanPesertaMentordua extends StatefulWidget {
  const PersuratanPesertaMentordua({super.key});

  @override
  State<PersuratanPesertaMentordua> createState() =>
      _PersuratanPesertaMentorduaState();
}

class _PersuratanPesertaMentorduaState
    extends State<PersuratanPesertaMentordua> {
  List<dynamic> dataPersuratan = [];
  bool _isLoading = true;
  final _storage = const FlutterSecureStorage();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchPersuratan();
  }

  Future<void> _fetchPersuratan() async {
    try {
      final token = await _storage.read(key: 'access_token');
      if (token == null) {
        setState(() => _isLoading = false);
        return;
      }

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/mentor/persuratan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        if (body['success']) {
          final fetchedData = body['data'] as List<dynamic>;

          if (mounted) {
            List<Future<void>> precacheTasks = [];
            for (var item in fetchedData) {
              final linkDokumen = item['link_dokumen']?.toString();
              if (linkDokumen != null) {
                final isImage = linkDokumen.toLowerCase().endsWith('.jpg') ||
                    linkDokumen.toLowerCase().endsWith('.jpeg') ||
                    linkDokumen.toLowerCase().endsWith('.png');
                if (isImage) {
                  precacheTasks.add(precacheImage(
                    NetworkImage('http://10.0.2.2:8000/storage/$linkDokumen'),
                    context,
                  ));
                }
              }
              final filePendukung = item['file_pendukung']?.toString();
              if (filePendukung != null) {
                final isImage2 = filePendukung.toLowerCase().endsWith('.jpg') ||
                    filePendukung.toLowerCase().endsWith('.jpeg') ||
                    filePendukung.toLowerCase().endsWith('.png');
                if (isImage2) {
                  precacheTasks.add(precacheImage(
                    NetworkImage('http://10.0.2.2:8000/storage/$filePendukung'),
                    context,
                  ));
                }
              }
            }

            if (precacheTasks.isNotEmpty) {
              await Future.wait(precacheTasks).catchError((_) => []);
            }

            if (mounted) {
              setState(() {
                dataPersuratan = fetchedData;
                _isLoading = false;
              });
            }
          }
        } else {
          if (mounted) setState(() => _isLoading = false);
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error fetching persuratan: $e');
      setState(() => _isLoading = false);
    }
  }

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
              Tab(text: "Persuratan"),
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
    final filteredData = dataPersuratan.where((item) {
      final name =
          item['peserta']?['nama_lengkap']?.toString().toLowerCase() ?? '';
      final type = item['jenis_surat']?.toString().toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || type.contains(query);
    }).toList();

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
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
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
            _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        color: Color(0xFFAD3B3E),
                      ),
                    ),
                  )
                : dataPersuratan.isEmpty
                ? const Center(child: Text("Belum ada pengajuan persuratan."))
                : filteredData.isEmpty
                ? const Center(child: Text("Hasil pencarian tidak ditemukan."))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final item = filteredData[index];
                      return _buildSuratCard(item as Map<String, dynamic>);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuratCard(Map<String, dynamic> data) {
    return _ExpandableSuratCard(
      data: data,
      onStatusUpdated: () {
        _fetchPersuratan();
      },
    );
  }
}

class _ExpandableSuratCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onStatusUpdated;

  const _ExpandableSuratCard({
    required this.data,
    required this.onStatusUpdated,
  });

  @override
  State<_ExpandableSuratCard> createState() => _ExpandableSuratCardState();
}

class _ExpandableSuratCardState extends State<_ExpandableSuratCard> {
  bool _isExpanded = false;

  Future<void> _updateStatus(
    String newStatus, {
    String? catatan,
    String? filePath,
  }) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'access_token');
    final id = widget.data['id'];

    final uri = Uri.parse(
      'http://10.0.2.2:8000/api/mentor/persuratan/$id/status',
    );
    var request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    request.fields['status'] = newStatus;

    if (catatan != null && catatan.isNotEmpty) {
      request.fields['catatan_mentor'] = catatan;
    }

    if (filePath != null) {
      request.files.add(
        await http.MultipartFile.fromPath('link_dokumen', filePath),
      );
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Color(0xFFAD3B3E)),
        ),
      );

      final response = await request.send();
      Navigator.pop(context); // close loading

      if (response.statusCode == 200) {
        widget.onStatusUpdated();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Berhasil mengubah status surat.')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Gagal mengubah status!')));
        }
      }
    } catch (e) {
      Navigator.pop(context); // close loading
      print('Exception update status: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan koneksi.')));
      }
    }
  }

  void _showTolakDialog() {
    TextEditingController catatanController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tolak Pengajuan'),
        content: TextField(
          controller: catatanController,
          decoration: const InputDecoration(
            hintText: 'Masukkan alasan penolakan...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (catatanController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Alasan penolakan tidak boleh kosong!'),
                  ),
                );
                return;
              }
              Navigator.pop(context);
              _updateStatus('ditolak', catatan: catatanController.text);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Tolak', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showUploadDialog() {
    TextEditingController catatanController = TextEditingController();
    String? selectedFilePath;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Selesai & Upload Dokumen'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: catatanController,
                    decoration: const InputDecoration(
                      hintText: 'Pesan untuk peserta (opsional)...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: [
                          'pdf',
                          'doc',
                          'docx',
                          'jpg',
                          'jpeg',
                          'png',
                        ],
                      );
                      if (result != null) {
                        setStateDialog(() {
                          selectedFilePath = result.files.single.path;
                        });
                      }
                    },
                    icon: const Icon(Icons.attach_file),
                    label: Text(
                      selectedFilePath != null
                          ? 'File terpilih'
                          : 'Pilih File Balasan',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black87,
                      elevation: 0,
                    ),
                  ),
                  if (selectedFilePath != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        selectedFilePath!.split('/').last,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedFilePath == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Anda harus memilih file dokumen!'),
                        ),
                      );
                      return;
                    }
                    Navigator.pop(context);
                    _updateStatus(
                      'selesai',
                      catatan: catatanController.text,
                      filePath: selectedFilePath,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAD3B3E),
                  ),
                  child: const Text(
                    'Kirim & Selesaikan',
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Red left border
              Container(width: 4, color: const Color(0xFFAD3B3E)),
              // Card content
              Expanded(
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
                        color: Colors.white,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              radius: displayWidth(context) * 0.06,
                              child: Icon(
                                Icons.person,
                                color: Colors.grey[400],
                                size: displayWidth(context) * 0.07,
                              ),
                            ),
                            SizedBox(width: displayWidth(context) * 0.04),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: displayHeight(context) * 0.005,
                                  ),
                                  Text(
                                    widget.data['peserta'] != null
                                        ? widget.data['peserta']['nama_lengkap']
                                        : '-',
                                    style: TextStyle(
                                      fontSize: displayWidth(context) * 0.035,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),

                                  if (widget.data['jenis_surat'] != null &&
                                      widget.data['jenis_surat']
                                          .toString()
                                          .isNotEmpty) ...[
                                    SizedBox(
                                      height: displayHeight(context) * 0.009,
                                    ),
                                    Text(
                                      'Membutuhkan "${widget.data['jenis_surat']}"',
                                      style: TextStyle(
                                        fontSize: displayWidth(context) * 0.03,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(width: displayWidth(context) * 0.02),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Builder(
                                  builder: (context) {
                                    String status =
                                        widget.data['status']
                                            ?.toString()
                                            .toUpperCase() ??
                                        'PENDING';
                                    Color statusColor;
                                    if (status == 'PENDING')
                                      statusColor = Colors.orange;
                                    else if (status == 'DIPROSES')
                                      statusColor = Colors.blue;
                                    else if (status == 'SELESAI')
                                      statusColor = Colors.green;
                                    else
                                      statusColor = Colors.red;

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                          color: statusColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              displayWidth(context) * 0.025,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 8),
                                Icon(
                                  _isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Colors.grey[400],
                                  size: displayWidth(context) * 0.05,
                                ),
                              ],
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
                                  _buildInfoItem(
                                    "Nama Pemohon",
                                    widget.data['peserta'] != null
                                        ? widget.data['peserta']['nama_lengkap']
                                        : '-',
                                  ),
                                  SizedBox(
                                    height: displayHeight(context) * 0.015,
                                  ),
                                  _buildInfoItem(
                                    "Keperluan",
                                    widget.data['keperluan'] ?? '-',
                                  ),
                                  SizedBox(
                                    height: displayHeight(context) * 0.015,
                                  ),
                                  _buildInfoItem(
                                    "Tanggal Pengajuan",
                                    widget.data['created_at'] != null
                                        ? "${DateTime.parse(widget.data['created_at']).day.toString().padLeft(2, '0')}-${DateTime.parse(widget.data['created_at']).month.toString().padLeft(2, '0')}-${DateTime.parse(widget.data['created_at']).year}"
                                        : '-',
                                  ),
                                  SizedBox(
                                    height: displayHeight(context) * 0.015,
                                  ),
                                  if (widget.data['file_pendukung'] != null &&
                                      widget.data['file_pendukung']
                                          .toString()
                                          .isNotEmpty &&
                                      widget.data['file_pendukung']
                                              .toString() !=
                                          'null') ...[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Dokumen Pendukung",
                                          style: TextStyle(
                                            fontSize:
                                                displayWidth(context) * 0.03,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              displayHeight(context) * 0.005,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: displayWidth(context) * 0.02,
                                          ),
                                          child: Builder(
                                            builder: (context) {
                                              final filePendukung = widget
                                                  .data['file_pendukung']
                                                  .toString();
                                              final isImage =
                                                  filePendukung
                                                      .toLowerCase()
                                                      .endsWith('.jpg') ||
                                                  filePendukung
                                                      .toLowerCase()
                                                      .endsWith('.jpeg') ||
                                                  filePendukung
                                                      .toLowerCase()
                                                      .endsWith('.png');

                                              if (isImage) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return Dialog(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          insetPadding:
                                                              const EdgeInsets.all(
                                                                10,
                                                              ),
                                                          child: Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: [
                                                              InteractiveViewer(
                                                                panEnabled:
                                                                    true,
                                                                minScale: 0.5,
                                                                maxScale: 4.0,
                                                                child: Image.network(
                                                                  'http://10.0.2.2:8000/storage/$filePendukung',
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  loadingBuilder:
                                                                      (
                                                                        BuildContext
                                                                        context,
                                                                        Widget
                                                                        child,
                                                                        ImageChunkEvent?
                                                                        loadingProgress,
                                                                      ) {
                                                                        if (loadingProgress ==
                                                                            null)
                                                                          return child;
                                                                        return SizedBox(
                                                                          width:
                                                                              300,
                                                                          height:
                                                                              300,
                                                                          child: Center(
                                                                            child: CircularProgressIndicator(
                                                                              value:
                                                                                  loadingProgress.expectedTotalBytes !=
                                                                                      null
                                                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                                                        loadingProgress.expectedTotalBytes!
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
                                                                        width:
                                                                            300,
                                                                        height:
                                                                            300,
                                                                        child: Center(
                                                                          child: Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Icon(
                                                                                Icons.broken_image,
                                                                                color: Colors.white,
                                                                                size: 50,
                                                                              ),
                                                                              SizedBox(
                                                                                height: 8,
                                                                              ),
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
                                                              ),
                                                              Positioned(
                                                                top: 10,
                                                                right: 10,
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    IconButton(
                                                                      icon: const Icon(Icons.download, color: Colors.white, size: 30),
                                                                      onPressed: () async {
                                                                        final url = Uri.parse('http://10.0.2.2:8000/storage/$filePendukung');
                                                                        try {
                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                            const SnackBar(content: Text('Menyimpan gambar...'), duration: Duration(seconds: 1)),
                                                                          );
                                                                          final request = await HttpClient().getUrl(url);
                                                                          final response = await request.close();
                                                                          if (response.statusCode == 200) {
                                                                            final bytes = await consolidateHttpClientResponseBytes(response);
                                                                            await Gal.putImageBytes(bytes);
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              const SnackBar(content: Text('Gambar berhasil disimpan ke Galeri!')),
                                                                            );
                                                                          } else {
                                                                            throw Exception('Gagal mengunduh: ${response.statusCode}');
                                                                          }
                                                                        } catch (e) {
                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                            SnackBar(content: Text('Gagal menyimpan gambar: $e')),
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
                                                                      onPressed: () => Navigator.pop(context),
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    child: Image.network(
                                                      'http://10.0.2.2:8000/storage/$filePendukung',
                                                      height:
                                                          displayHeight(
                                                            context,
                                                          ) *
                                                          0.1,
                                                      width:
                                                          displayWidth(
                                                            context,
                                                          ) *
                                                          0.2,
                                                      fit: BoxFit.cover,
                                                      loadingBuilder:
                                                          (
                                                            BuildContext
                                                            context,
                                                            Widget child,
                                                            ImageChunkEvent?
                                                            loadingProgress,
                                                          ) {
                                                            if (loadingProgress ==
                                                                null)
                                                              return child;
                                                            return Container(
                                                              height:
                                                                  displayHeight(
                                                                    context,
                                                                  ) *
                                                                  0.1,
                                                              width:
                                                                  displayWidth(
                                                                    context,
                                                                  ) *
                                                                  0.2,
                                                              color: Colors
                                                                  .grey
                                                                  .shade200,
                                                              child: const Center(
                                                                child: SizedBox(
                                                                  width: 24,
                                                                  height: 24,
                                                                  child: CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2,
                                                                    color: Color(
                                                                      0xFFAD3B3E,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) => Container(
                                                            height:
                                                                displayHeight(
                                                                  context,
                                                                ) *
                                                                0.1,
                                                            width:
                                                                displayWidth(
                                                                  context,
                                                                ) *
                                                                0.2,
                                                            color: Colors
                                                                .grey
                                                                .shade200,
                                                            child: const Icon(
                                                              Icons
                                                                  .broken_image,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return InkWell(
                                                  onTap: () async {
                                                    final url = Uri.parse(
                                                      'http://10.0.2.2:8000/storage/$filePendukung',
                                                    );
                                                    try {
                                                      await launchUrl(
                                                        url,
                                                        mode: LaunchMode
                                                            .externalApplication,
                                                      );
                                                    } catch (e) {
                                                      print(
                                                        'Could not launch $url: $e',
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal:
                                                              displayWidth(
                                                                context,
                                                              ) *
                                                              0.03,
                                                          vertical:
                                                              displayHeight(
                                                                context,
                                                              ) *
                                                              0.01,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade100,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      border: Border.all(
                                                        color: Colors
                                                            .grey
                                                            .shade300,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .insert_drive_file,
                                                          size:
                                                              displayWidth(
                                                                context,
                                                              ) *
                                                              0.04,
                                                          color: Colors
                                                              .grey
                                                              .shade700,
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              displayWidth(
                                                                context,
                                                              ) *
                                                              0.02,
                                                        ),
                                                        Text(
                                                          'Lihat Dokumen',
                                                          style: TextStyle(
                                                            fontSize:
                                                                displayWidth(
                                                                  context,
                                                                ) *
                                                                0.03,
                                                            color: Colors
                                                                .grey
                                                                .shade800,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: displayHeight(context) * 0.015,
                                    ),
                                  ],
                                  if (widget.data['catatan_mentor'] != null ||
                                      widget.data['link_dokumen'] != null) ...[
                                    const Divider(color: Colors.grey),
                                    SizedBox(
                                      height: displayHeight(context) * 0.015,
                                    ),
                                    Text(
                                      "Balasan / Catatan Anda",
                                      style: TextStyle(
                                        fontSize: displayWidth(context) * 0.035,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      height: displayHeight(context) * 0.015,
                                    ),
                                    if (widget.data['catatan_mentor'] != null)
                                      _buildInfoItem(
                                        "Catatan",
                                        widget.data['catatan_mentor'],
                                      ),
                                    if (widget.data['catatan_mentor'] != null)
                                      SizedBox(
                                        height: displayHeight(context) * 0.015,
                                      ),
                                    if (widget.data['link_dokumen'] != null)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Dokumen Balasan",
                                            style: TextStyle(
                                              fontSize:
                                                  displayWidth(context) * 0.03,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                displayHeight(context) * 0.005,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left:
                                                  displayWidth(context) * 0.02,
                                            ),
                                            child: Builder(
                                              builder: (context) {
                                                final linkDokumen = widget
                                                    .data['link_dokumen']
                                                    .toString();
                                                final isImage =
                                                    linkDokumen
                                                        .toLowerCase()
                                                        .endsWith('.jpg') ||
                                                    linkDokumen
                                                        .toLowerCase()
                                                        .endsWith('.jpeg') ||
                                                    linkDokumen
                                                        .toLowerCase()
                                                        .endsWith('.png');

                                                if (isImage) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return Dialog(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            insetPadding:
                                                                const EdgeInsets.all(
                                                                  10,
                                                                ),
                                                            child: Stack(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              children: [
                                                                InteractiveViewer(
                                                                  panEnabled:
                                                                      true,
                                                                  minScale: 0.5,
                                                                  maxScale: 4.0,
                                                                  child: Image.network(
                                                                    'http://10.0.2.2:8000/storage/$linkDokumen',
                                                                    fit: BoxFit
                                                                        .contain,
                                                                    loadingBuilder:
                                                                        (
                                                                          BuildContext
                                                                          context,
                                                                          Widget
                                                                          child,
                                                                          ImageChunkEvent?
                                                                          loadingProgress,
                                                                        ) {
                                                                          if (loadingProgress ==
                                                                              null)
                                                                            return child;
                                                                          return SizedBox(
                                                                            width:
                                                                                300,
                                                                            height:
                                                                                300,
                                                                            child: Center(
                                                                              child: CircularProgressIndicator(
                                                                                value:
                                                                                    loadingProgress.expectedTotalBytes !=
                                                                                        null
                                                                                    ? loadingProgress.cumulativeBytesLoaded /
                                                                                          loadingProgress.expectedTotalBytes!
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
                                                                          width:
                                                                              300,
                                                                          height:
                                                                              300,
                                                                          child: Center(
                                                                            child: Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.broken_image,
                                                                                  color: Colors.white,
                                                                                  size: 50,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 8,
                                                                                ),
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
                                                                ),
                                                                Positioned(
                                                                  top: 10,
                                                                  right: 10,
                                                                  child: Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      IconButton(
                                                                        icon: const Icon(Icons.download, color: Colors.white, size: 30),
                                                                        onPressed: () async {
                                                                          final url = Uri.parse('http://10.0.2.2:8000/storage/$linkDokumen');
                                                                          try {
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              const SnackBar(content: Text('Menyimpan gambar...'), duration: Duration(seconds: 1)),
                                                                            );
                                                                            final request = await HttpClient().getUrl(url);
                                                                            final response = await request.close();
                                                                            if (response.statusCode == 200) {
                                                                              final bytes = await consolidateHttpClientResponseBytes(response);
                                                                              await Gal.putImageBytes(bytes);
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                const SnackBar(content: Text('Gambar berhasil disimpan ke Galeri!')),
                                                                              );
                                                                            } else {
                                                                              throw Exception('Gagal mengunduh: ${response.statusCode}');
                                                                            }
                                                                          } catch (e) {
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              SnackBar(content: Text('Gagal menyimpan gambar: $e')),
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
                                                                        onPressed: () => Navigator.pop(context),
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
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      child: Image.network(
                                                        'http://10.0.2.2:8000/storage/$linkDokumen',
                                                        height:
                                                            displayHeight(
                                                              context,
                                                            ) *
                                                            0.1,
                                                        width:
                                                            displayWidth(
                                                              context,
                                                            ) *
                                                            0.2,
                                                        fit: BoxFit.cover,
                                                        loadingBuilder:
                                                            (
                                                              BuildContext
                                                              context,
                                                              Widget child,
                                                              ImageChunkEvent?
                                                              loadingProgress,
                                                            ) {
                                                              if (loadingProgress ==
                                                                  null)
                                                                return child;
                                                              return Container(
                                                                height:
                                                                    displayHeight(
                                                                      context,
                                                                    ) *
                                                                    0.1,
                                                                width:
                                                                    displayWidth(
                                                                      context,
                                                                    ) *
                                                                    0.2,
                                                                color: Colors
                                                                    .grey
                                                                    .shade200,
                                                                child: const Center(
                                                                  child: SizedBox(
                                                                    width: 24,
                                                                    height: 24,
                                                                    child: CircularProgressIndicator(
                                                                      strokeWidth:
                                                                          2,
                                                                      color: Color(
                                                                        0xFFAD3B3E,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                        errorBuilder:
                                                            (
                                                              context,
                                                              error,
                                                              stackTrace,
                                                            ) => Container(
                                                              height:
                                                                  displayHeight(
                                                                    context,
                                                                  ) *
                                                                  0.1,
                                                              width:
                                                                  displayWidth(
                                                                    context,
                                                                  ) *
                                                                  0.2,
                                                              color: Colors
                                                                  .grey
                                                                  .shade200,
                                                              child: const Icon(
                                                                Icons
                                                                    .broken_image,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return InkWell(
                                                    onTap: () async {
                                                      final url = Uri.parse(
                                                        'http://10.0.2.2:8000/storage/$linkDokumen',
                                                      );
                                                      try {
                                                        await launchUrl(
                                                          url,
                                                          mode: LaunchMode
                                                              .externalApplication,
                                                        );
                                                      } catch (e) {
                                                        print(
                                                          'Could not launch $url: $e',
                                                        );
                                                      }
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal:
                                                                displayWidth(
                                                                  context,
                                                                ) *
                                                                0.03,
                                                            vertical:
                                                                displayHeight(
                                                                  context,
                                                                ) *
                                                                0.01,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey
                                                            .shade100,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                        border: Border.all(
                                                          color: Colors
                                                              .grey
                                                              .shade300,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .insert_drive_file,
                                                            size:
                                                                displayWidth(
                                                                  context,
                                                                ) *
                                                                0.04,
                                                            color: Colors
                                                                .grey
                                                                .shade700,
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                displayWidth(
                                                                  context,
                                                                ) *
                                                                0.02,
                                                          ),
                                                          Text(
                                                            'Lihat Dokumen Balasan Anda',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  displayWidth(
                                                                    context,
                                                                  ) *
                                                                  0.03,
                                                              color: Colors
                                                                  .grey
                                                                  .shade800,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                displayHeight(context) * 0.015,
                                          ),
                                        ],
                                      ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bottom Action Bar
                      Builder(
                        builder: (context) {
                          final status =
                              widget.data['status']?.toString().toUpperCase() ??
                              'PENDING';

                          if (status == 'PENDING') {
                            return Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      _showTolakDialog();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical:
                                            displayHeight(context) * 0.015,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red[50],
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(
                                            displayWidth(context) * 0.04,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.close,
                                            color: Colors.red[600],
                                            size: displayWidth(context) * 0.05,
                                          ),
                                          SizedBox(
                                            height:
                                                displayHeight(context) * 0.005,
                                          ),
                                          Text(
                                            "Tolak",
                                            style: TextStyle(
                                              color: Colors.red[600],
                                              fontSize:
                                                  displayWidth(context) * 0.025,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      _updateStatus('diproses');
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical:
                                            displayHeight(context) * 0.015,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(
                                            displayWidth(context) * 0.04,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: displayWidth(context) * 0.05,
                                          ),
                                          SizedBox(
                                            height:
                                                displayHeight(context) * 0.005,
                                          ),
                                          Text(
                                            "Setujui (Proses)",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  displayWidth(context) * 0.025,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else if (status == 'DIPROSES') {
                            return Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      _showTolakDialog();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical:
                                            displayHeight(context) * 0.015,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red[50],
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(
                                            displayWidth(context) * 0.04,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.close,
                                            color: Colors.red[600],
                                            size: displayWidth(context) * 0.05,
                                          ),
                                          SizedBox(
                                            height:
                                                displayHeight(context) * 0.005,
                                          ),
                                          Text(
                                            "Batalkan",
                                            style: TextStyle(
                                              color: Colors.red[600],
                                              fontSize:
                                                  displayWidth(context) * 0.025,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      _showUploadDialog();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical:
                                            displayHeight(context) * 0.015,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(
                                            displayWidth(context) * 0.04,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.upload_file,
                                            color: Colors.white,
                                            size: displayWidth(context) * 0.05,
                                          ),
                                          SizedBox(
                                            height:
                                                displayHeight(context) * 0.005,
                                          ),
                                          Text(
                                            "Selesai & Upload",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  displayWidth(context) * 0.025,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            // Jika status SELESAI atau DITOLAK
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
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
                    color: value == 'PENDING'
                        ? Colors.orange.withOpacity(0.15)
                        : value == 'DIPROSES'
                        ? Colors.blue.withOpacity(0.15)
                        : value == 'SELESAI'
                        ? Colors.green.withOpacity(0.15)
                        : Colors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.025,
                      fontWeight: FontWeight.bold,
                      color: value == 'PENDING'
                          ? Colors.orange[700]
                          : value == 'DIPROSES'
                          ? Colors.blue[700]
                          : value == 'SELESAI'
                          ? Colors.green[700]
                          : Colors.red[700],
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
