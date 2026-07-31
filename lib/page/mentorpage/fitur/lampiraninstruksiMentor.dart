part of '../../../conn/auth.dart';

class LampiranInstruksiMentor extends StatefulWidget {
  final List<String>? images;
  final String? title;
  const LampiranInstruksiMentor({super.key, this.images, this.title});

  @override
  State<LampiranInstruksiMentor> createState() =>
      _LampiranInstruksiMentorState();
}

class _LampiranInstruksiMentorState extends State<LampiranInstruksiMentor> {
  final List<Map<String, String>> dummyImages = [
    {
      "name": "IMAGE_04.PNG",
      "url":
          "https://images.unsplash.com/photo-1551288049-bebda4e38f71?q=80&w=1000&auto=format&fit=crop", // Dummy chart image
    },
    {
      "name": "IMAGE_06.PNG",
      "url":
          "https://images.unsplash.com/photo-1579952363873-27f3bade9f55?q=80&w=1000&auto=format&fit=crop", // Dummy sports image
    },
    {
      "name": "IMAGE_REF_03.PNG",
      "url":
          "https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?q=80&w=1000&auto=format&fit=crop", // Dummy diagram image
    },
  ];

  bool _isImageFile(String fileNameOrUrl) {
    final lower = fileNameOrUrl.toLowerCase().split('?').first;
    final imageExtensions = [
      '.png',
      '.jpg',
      '.jpeg',
      '.gif',
      '.webp',
      '.bmp',
      '.heic',
      '.svg'
    ];
    for (final ext in imageExtensions) {
      if (lower.endsWith(ext)) return true;
    }
    return false;
  }

  Future<void> _openInBrowser(String urlString) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Membuka file di web browser untuk mengunduh...'),
          duration: Duration(seconds: 2),
        ),
      );
      final Uri url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuka file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _downloadImage(String imageUrl, String fileName) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Menyimpan $fileName ke Galeri HP...'),
          duration: const Duration(seconds: 1),
        ),
      );
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        await Gal.putImageBytes(response.bodyBytes);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$fileName berhasil disimpan di Galeri HP!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Status ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan gambar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _downloadAllImages() async {
    final list = widget.images != null && widget.images!.isNotEmpty
        ? widget.images!
        : dummyImages.map((e) => e['url']!).toList();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Memproses semua lampiran...'),
        duration: Duration(seconds: 2),
      ),
    );

    int imageSuccessCount = 0;
    int docCount = 0;
    for (int i = 0; i < list.length; i++) {
      try {
        String path = list[i];
        String fullUrl = path.startsWith('http')
            ? path
            : 'http://10.0.2.2:8000/storage/$path';

        if (_isImageFile(fullUrl)) {
          final response = await http.get(Uri.parse(fullUrl));
          if (response.statusCode == 200) {
            await Gal.putImageBytes(response.bodyBytes);
            imageSuccessCount++;
          }
        } else {
          docCount++;
          await _openInBrowser(fullUrl);
        }
      } catch (_) {}
    }

    if (!mounted) return;
    if (imageSuccessCount > 0 || docCount > 0) {
      String msg = '';
      if (imageSuccessCount > 0 && docCount > 0) {
        msg =
            '$imageSuccessCount foto disimpan & $docCount dokumen diunduh via browser!';
      } else if (imageSuccessCount > 0) {
        msg = '$imageSuccessCount lampiran berhasil disimpan di Galeri HP!';
      } else {
        msg = '$docCount dokumen dibuka di browser untuk diunduh!';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memproses lampiran'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text(
          widget.title ?? 'Lampiran Instruksi',
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
            children: [
              // List of Files / Images
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.images != null && widget.images!.isNotEmpty
                    ? widget.images!.length
                    : dummyImages.length,
                itemBuilder: (context, index) {
                  String fileName = 'petunjuk_${index + 1}.jpg';
                  String fullUrl = '';
                  if (widget.images != null && widget.images!.isNotEmpty) {
                    String path = widget.images![index];
                    fullUrl = path.startsWith('http')
                        ? path
                        : 'http://10.0.2.2:8000/storage/$path';
                    fileName = path.split('/').last.split('?').first;
                    if (fileName.isEmpty) fileName = 'lampiran_${index + 1}';
                  } else {
                    fullUrl = dummyImages[index]['url']!;
                    fileName = dummyImages[index]['name']!;
                  }

                  if (_isImageFile(fullUrl)) {
                    return _buildLampiranCard(fileName, fullUrl);
                  } else {
                    return _buildDocumentCard(fileName, fullUrl);
                  }
                },
              ),

              SizedBox(height: displayHeight(context) * 0.03),

              // End indicator
              Column(
                children: [
                  Container(
                    width: displayWidth(context) * 0.1,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  SizedBox(height: displayHeight(context) * 0.015),
                  Text(
                    "Semua lampiran telah ditampilkan",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: displayWidth(context) * 0.03,
                    ),
                  ),
                ],
              ),

              // Extra space for FAB
              SizedBox(height: displayHeight(context) * 0.1),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _downloadAllImages,
        backgroundColor: const Color(0xFFA63C40), // Darker red from screenshot
        elevation: 4,
        child: Icon(
          Icons.save,
          color: Colors.white,
          size: displayWidth(context) * 0.06,
        ),
      ),
    );
  }

  Widget _buildLampiranCard(String name, String imageUrl) {
    return Container(
      margin: EdgeInsets.only(bottom: displayHeight(context) * 0.025),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    backgroundColor: Colors.black,
                    appBar: AppBar(
                      backgroundColor: Colors.black,
                      iconTheme: const IconThemeData(color: Colors.white),
                      elevation: 0,
                    ),
                    body: Center(
                      child: InteractiveViewer(
                        panEnabled: true,
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.white54,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(displayWidth(context) * 0.03),
                topRight: Radius.circular(displayWidth(context) * 0.03),
              ),
              child: Image.network(
                imageUrl,
                height: displayHeight(context) * 0.22,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: displayHeight(context) * 0.22,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: displayWidth(context) * 0.04,
              vertical: displayHeight(context) * 0.02,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: displayWidth(context) * 0.035,
                      color: Colors.grey[700],
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => _downloadImage(imageUrl, name),
                  icon: Icon(
                    Icons.file_download_outlined,
                    color: const Color(0xFFA63C40),
                    size: displayWidth(context) * 0.06,
                  ),
                  tooltip: 'Simpan ke Galeri',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(String name, String fileUrl) {
    IconData docIcon = Icons.insert_drive_file_outlined;
    Color iconBgColor = const Color(0xFFE3F2FD);
    Color iconColor = const Color(0xFF1976D2);

    final lower = name.toLowerCase();
    if (lower.endsWith('.pdf')) {
      docIcon = Icons.picture_as_pdf_outlined;
      iconBgColor = const Color(0xFFFDE8E8);
      iconColor = const Color(0xFFD9534F);
    } else if (lower.endsWith('.doc') || lower.endsWith('.docx')) {
      docIcon = Icons.description_outlined;
      iconBgColor = const Color(0xFFE6F2FF);
      iconColor = const Color(0xFF31708F);
    } else if (lower.endsWith('.xls') || lower.endsWith('.xlsx')) {
      docIcon = Icons.table_chart_outlined;
      iconBgColor = const Color(0xFFE8F5E9);
      iconColor = const Color(0xFF2E7D32);
    } else if (lower.endsWith('.zip') || lower.endsWith('.rar')) {
      docIcon = Icons.folder_zip_outlined;
      iconBgColor = const Color(0xFFFFF8E1);
      iconColor = const Color(0xFFB8860B);
    }

    return Container(
      margin: EdgeInsets.only(bottom: displayHeight(context) * 0.025),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _openInBrowser(fileUrl),
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
        child: Padding(
          padding: EdgeInsets.all(displayWidth(context) * 0.045),
          child: Row(
            children: [
              Container(
                width: displayWidth(context) * 0.14,
                height: displayWidth(context) * 0.14,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  docIcon,
                  color: iconColor,
                  size: displayWidth(context) * 0.08,
                ),
              ),
              SizedBox(width: displayWidth(context) * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: displayWidth(context) * 0.038,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: displayHeight(context) * 0.006),
                    Text(
                      'Dokumen / File • Klik untuk unduh via browser',
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.031,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: displayWidth(context) * 0.02),
              Container(
                padding: EdgeInsets.all(displayWidth(context) * 0.025),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBEAEA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.open_in_browser,
                  color: const Color(0xFFA63C40),
                  size: displayWidth(context) * 0.06,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
