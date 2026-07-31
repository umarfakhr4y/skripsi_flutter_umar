part of '../../../conn/auth.dart';

class DetailTugasMentor extends StatefulWidget {
  final Map<String, dynamic>? task;
  const DetailTugasMentor({super.key, this.task});

  @override
  State<DetailTugasMentor> createState() => _DetailTugasMentorState();
}

class _DetailTugasMentorState extends State<DetailTugasMentor> {
  Map<String, dynamic>? taskData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      taskData = widget.task;
    } else {
      _fetchDetail();
    }
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
    });
    final result = await MentorService.getPenugasanMentor();
    if (mounted) {
      if (result['success'] == true &&
          result['data'] is List &&
          (result['data'] as List).isNotEmpty) {
        setState(() {
          taskData = result['data'][0];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteTask() async {
    final taskId = taskData?['id'];
    if (taskId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ID tugas tidak ditemukan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Tugas'),
        content: const Text('Apakah Anda yakin ingin menghapus tugas ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE84C63),
            ),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Color(0xFFAD3B3E)),
        ),
      );

      final result = await MentorService.deletePenugasanMentor(
        int.parse(taskId.toString()),
      );
      if (!mounted) return;
      Navigator.pop(context); // Tutup loading dialog

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tugas berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Kembali ke halaman daftar
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Gagal menghapus tugas'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String status = (taskData?['status_tugas'] ?? 'Aktif').toString();
    Color tagBgColor = const Color(0xFFE84C63);
    Color tagTextColor = Colors.white;
    if (status.toLowerCase() == 'ditinjau') {
      tagBgColor = const Color(0xFFFFF8E1);
      tagTextColor = const Color(0xFFB8860B);
    } else if (status.toLowerCase() == 'selesai') {
      tagBgColor = const Color(0xFFE8F5E9);
      tagTextColor = const Color(0xFF2E7D32);
    }

    String judul = taskData?['judul_tugas'] ?? 'Detail Tugas';
    String deskripsi = taskData?['deskripsi'] ?? '-';
    String namaPeserta = '-';
    String nimPeserta = '-';
    if (taskData?['peserta'] is Map) {
      namaPeserta = taskData!['peserta']['nama_lengkap'] ?? '-';
      nimPeserta = 'NIM: ${taskData!['peserta']['nim'] ?? '-'}';
    }

    String deadlineStr = taskData?['deadline'] ?? '';
    String formattedDeadline = '-';
    String sisaHariText = '-';
    if (deadlineStr.isNotEmpty) {
      if (deadlineStr.contains('-')) {
        final parts = deadlineStr.split('-');
        if (parts.length == 3 && parts[0].length == 4) {
          formattedDeadline = "${parts[2]}-${parts[1]}-${parts[0]}";
        } else {
          formattedDeadline = deadlineStr;
        }
      } else {
        formattedDeadline = deadlineStr;
      }
      try {
        final date = DateTime.parse(deadlineStr);
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final diff = date.difference(today).inDays;
        if (diff > 0) {
          sisaHariText = 'Sisa $diff hari lagi';
        } else if (diff == 0) {
          sisaHariText = 'Hari ini';
        } else {
          sisaHariText = 'Terlewat ${diff.abs()} hari';
        }
      } catch (_) {
        sisaHariText = '-';
      }
    }

    List<String> fotoList = [];
    if (taskData?['foto_petunjuk'] is List) {
      fotoList = (taskData!['foto_petunjuk'] as List)
          .map((e) => e.toString())
          .toList();
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFAD3B3E)),
            )
          : SingleChildScrollView(
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
                            color: tagBgColor,
                            borderRadius: BorderRadius.circular(
                              displayWidth(context) * 0.05,
                            ),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: tagTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: displayWidth(context) * 0.03,
                            ),
                          ),
                        ),
                        SizedBox(width: displayWidth(context) * 0.02),
                        Text(
                          'TUGAS MAGANG',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                            fontSize: displayWidth(context) * 0.035,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: displayHeight(context) * 0.015),

                    // Title
                    Text(
                      judul,
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
                            label: 'DITUGASKAN KE',
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: displayWidth(context) * 0.045,
                                  backgroundColor: const Color(0xFFAD3B3E),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: displayWidth(context) * 0.02),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        namaPeserta,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              displayWidth(context) * 0.035,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        nimPeserta,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize:
                                              displayWidth(context) * 0.025,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        formattedDeadline,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              displayWidth(context) * 0.035,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        sisaHariText,
                                        style: TextStyle(
                                          color: const Color(0xFFE84C63),
                                          fontSize:
                                              displayWidth(context) * 0.025,
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LampiranInstruksiMentor(images: fotoList),
                              ),
                            );
                          },
                          child: Text(
                            'Lihat Semua',
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
                    SizedBox(height: displayHeight(context) * 0.04),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _deleteTask,
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: displayWidth(context) * 0.05,
                            ),
                            label: Text(
                              'Hapus',
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
                                borderRadius: BorderRadius.circular(
                                  displayWidth(context) * 0.05,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: displayWidth(context) * 0.04),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit_outlined,
                              color: Colors.black87,
                              size: displayWidth(context) * 0.05,
                            ),
                            label: Text(
                              'Edit Tugas',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: displayWidth(context) * 0.04,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: displayHeight(context) * 0.018,
                              ),
                              side: BorderSide(color: Colors.grey.shade400),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  displayWidth(context) * 0.05,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: displayHeight(context) * 0.02),
                  ],
                ),
              ),
            ),
    );
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

  Widget _buildLampiranImage(List<String> fotoList) {
    if (fotoList.isEmpty) {
      return Container(
        width: double.infinity,
        height: displayHeight(context) * 0.15,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
        ),
        alignment: Alignment.center,
        child: Text(
          'Tidak ada lampiran foto',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: displayWidth(context) * 0.035,
          ),
        ),
      );
    }

    String firstPath = fotoList[0];
    String fullUrl = firstPath.startsWith('http')
        ? firstPath
        : 'http://10.0.2.2:8000/storage/$firstPath';
    String fileName = 'petunjuk_1.jpg';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LampiranInstruksiMentor(images: fotoList),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: displayHeight(context) * 0.22,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
          image: DecorationImage(
            image: NetworkImage(fullUrl),
            fit: BoxFit.cover,
            onError: (_, __) {},
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
                  'petunjuk_satu.jpg',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: displayWidth(context) * 0.03,
                  ),
                  maxLines: 1,
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
