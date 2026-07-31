part of '../../../conn/auth.dart';

class LampiranInstruksiMentor extends StatefulWidget {
  final List<String>? images;
  const LampiranInstruksiMentor({super.key, this.images});

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
        content: Text('Menyimpan semua lampiran ke Galeri HP...'),
        duration: Duration(seconds: 2),
      ),
    );

    int successCount = 0;
    for (int i = 0; i < list.length; i++) {
      try {
        String path = list[i];
        String fullUrl = path.startsWith('http')
            ? path
            : 'http://10.0.2.2:8000/storage/$path';
        final response = await http.get(Uri.parse(fullUrl));
        if (response.statusCode == 200) {
          await Gal.putImageBytes(response.bodyBytes);
          successCount++;
        }
      } catch (_) {}
    }

    if (!mounted) return;
    if (successCount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$successCount lampiran berhasil disimpan di Galeri HP!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan lampiran'),
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
          'Lampiran Instruksi',
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
              // List of Images
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.images != null && widget.images!.isNotEmpty
                    ? widget.images!.length
                    : dummyImages.length,
                itemBuilder: (context, index) {
                  String fileName = 'petunjuk_${index + 1}.jpg';
                  if (widget.images != null && widget.images!.isNotEmpty) {
                    String path = widget.images![index];
                    String fullUrl = path.startsWith('http')
                        ? path
                        : 'http://10.0.2.2:8000/storage/$path';
                    return _buildLampiranCard(fileName, fullUrl);
                  } else {
                    return _buildLampiranCard(
                      fileName,
                      dummyImages[index]['url']!,
                    );
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
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: displayWidth(context) * 0.035,
                    color: Colors.grey[700],
                    letterSpacing: 0.5,
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
}
