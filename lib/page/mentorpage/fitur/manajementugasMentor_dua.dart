part of '../../../conn/auth.dart';

class ManajemenTugasMentordua extends StatefulWidget {
  const ManajemenTugasMentordua({super.key});

  @override
  State<ManajemenTugasMentordua> createState() =>
      _ManajemenTugasMentorduaState();
}

class _ManajemenTugasMentorduaState extends State<ManajemenTugasMentordua> {
  String selectedTab = 'Semua';
  final List<String> tabList = ['Semua', 'Ditinjau', 'Selesai'];

  List<Map<String, dynamic>> listPenugasan = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPenugasan();
  }

  Future<void> _fetchPenugasan() async {
    setState(() {
      _isLoading = true;
    });
    final result = await MentorService.getPenugasanMentor();
    if (mounted) {
      if (result['success'] && result['data'] is List) {
        final List<dynamic> data = result['data'];
        setState(() {
          listPenugasan = data.map((e) => e as Map<String, dynamic>).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = listPenugasan
        .where(
          (task) =>
              selectedTab.toLowerCase() == 'semua' ||
              (task['status_tugas'] ?? 'Aktif').toString().toLowerCase() ==
                  selectedTab.toLowerCase(),
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text(
          'Manajemen Tugas',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahTugasMentor()),
          );
          if (added == true) {
            _fetchPenugasan();
          }
        },
        backgroundColor: const Color(0xFFAD3B3E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchPenugasan,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: displayWidth(context) * 0.06,
              vertical: displayHeight(context) * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ringkasan Tugas Card
                _buildRingkasanCard(),
                SizedBox(height: displayHeight(context) * 0.025),

                // Filter Tabs (Aktif, Ditinjau, Selesai)
                _buildFilterTabs(),
                SizedBox(height: displayHeight(context) * 0.025),

                // Task Cards List or Loading
                _isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(
                            color: Color(0xFFAD3B3E),
                          ),
                        ),
                      )
                    : filteredTasks.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(displayWidth(context) * 0.1),
                          child: Text(
                            'Belum ada tugas pada status ini',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: displayWidth(context) * 0.038,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          return _buildTaskCard(filteredTasks[index]);
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRingkasanCard() {
    int countSemua = listPenugasan.length;
    int countDitinjau = listPenugasan
        .where(
          (t) =>
              (t['status_tugas'] ?? '').toString().toLowerCase() == 'ditinjau',
        )
        .length;
    int countSelesai = listPenugasan
        .where(
          (t) =>
              (t['status_tugas'] ?? '').toString().toLowerCase() == 'selesai',
        )
        .length;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(displayWidth(context) * 0.05),
      decoration: BoxDecoration(
        color: const Color(0xFFAD3B3E),
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.045),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAD3B3E).withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Tugas',
            style: TextStyle(
              color: Colors.white,
              fontSize: displayWidth(context) * 0.042,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: displayHeight(context) * 0.02),
          Row(
            children: [
              Expanded(child: _buildSummaryBox(countSemua.toString(), 'SEMUA')),
              SizedBox(width: displayWidth(context) * 0.03),
              Expanded(
                child: _buildSummaryBox(countDitinjau.toString(), 'REVIEW'),
              ),
              SizedBox(width: displayWidth(context) * 0.03),
              Expanded(
                child: _buildSummaryBox(countSelesai.toString(), 'SELESAI'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBox(String count, String label) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: displayHeight(context) * 0.015),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: displayWidth(context) * 0.06,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: displayHeight(context) * 0.005),
          Text(
            label,
            style: TextStyle(
              fontSize: displayWidth(context) * 0.026,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      padding: EdgeInsets.all(displayWidth(context) * 0.012),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.06),
      ),
      child: Row(
        children: tabList.map((tab) {
          final isSelected = selectedTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedTab = tab;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: displayHeight(context) * 0.013,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFAD3B3E)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.05,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  tab,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: displayWidth(context) * 0.035,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _updateTaskStatus(
    Map<String, dynamic> task,
    String newStatus, {
    String? catatanMentor,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFAD3B3E)),
      ),
    );

    int pesertaId = 0;
    if (task['peserta_magang_id'] != null) {
      pesertaId = int.tryParse(task['peserta_magang_id'].toString()) ?? 0;
    } else if (task['peserta'] != null &&
        task['peserta'] is Map &&
        task['peserta']['id'] != null) {
      pesertaId = int.tryParse(task['peserta']['id'].toString()) ?? 0;
    }

    final int id = int.tryParse(task['id'].toString()) ?? 0;
    final String judul = (task['judul_tugas'] ?? '').toString();
    final String deskripsi = (task['deskripsi'] ?? '').toString();
    final String deadline = (task['deadline'] ?? '').toString();
    final List<dynamic> fotoList = task['foto_petunjuk'] is List
        ? task['foto_petunjuk']
        : [];

    final result = await MentorService.updateStatusPenugasan(
      id: id,
      pesertaId: pesertaId,
      judulTugas: judul,
      deskripsi: deskripsi,
      deadline: deadline,
      statusTugas: newStatus,
      catatanMentor: catatanMentor,
      existingFotoPetunjuk: fotoList,
    );

    if (!mounted) return;
    Navigator.pop(context); // close progress dialog

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus == 'Selesai'
                ? 'Tugas berhasil disetujui (Selesai)!'
                : 'Catatan revisi berhasil dikirim!',
          ),
          backgroundColor: Colors.green,
        ),
      );
      _fetchPenugasan(); // Refresh task list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal mengubah status tugas'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _confirmSetujui(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          'Setujui Tugas?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Apakah Anda yakin ingin menyetujui hasil kerja ini? Tugas akan ditandai sebagai Selesai.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateTaskStatus(task, 'Selesai');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Setujui',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRevisiDialog(Map<String, dynamic> task) {
    final TextEditingController catatanController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          'Beri Revisi Tugas',
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
              Text(
                'Masukkan catatan atau arahan perbaikan yang perlu dikerjakan ulang oleh peserta magang:',
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.035,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.015),
              TextField(
                controller: catatanController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Contoh: Harap perbaiki diagram pada halaman 2...',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: displayWidth(context) * 0.033,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFFAD3B3E),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final text = catatanController.text.trim();
              if (text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Catatan revisi tidak boleh kosong'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              Navigator.pop(context);
              _updateTaskStatus(task, 'Revisi', catatanMentor: text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFAD3B3E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Kirim Revisi',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCatatanRevisiDialog(Map<String, dynamic> task) {
    final String catatan =
        task['catatan_mentor']?.toString().trim().isNotEmpty == true
        ? task['catatan_mentor'].toString()
        : 'Belum ada catatan revisi yang dicantumkan.';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            const Icon(Icons.rate_review, color: Color(0xFFE65100)),
            SizedBox(width: displayWidth(context) * 0.02),
            const Text(
              'Catatan Revisi Mentor',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFE65100),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Berikut adalah arahan revisi yang diberikan kepada peserta magang:',
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.033,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.015),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(displayWidth(context) * 0.04),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFB74D)),
                ),
                child: Text(
                  catatan,
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.035,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE65100),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Tutup',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasSubmission(Map<String, dynamic> task) {
    final files = task['file_pengumpulan'];
    final catatan = task['catatan_peserta'];
    final status = (task['status_tugas'] ?? '').toString().toLowerCase();
    if (status == 'ditinjau' || status == 'selesai' || status == 'revisi') {
      return true;
    }
    if (files is List && files.isNotEmpty) return true;
    if (catatan != null &&
        catatan.toString().trim().isNotEmpty &&
        catatan.toString() != 'null') {
      return true;
    }
    return false;
  }

  void _showHasilKerjaModal(Map<String, dynamic> task) {
    final String namaPeserta = task['peserta'] is Map
        ? (task['peserta']['nama_lengkap'] ?? '-')
        : '-';
    final String judul = task['judul_tugas'] ?? '-';
    final String catatanPeserta =
        (task['catatan_peserta'] != null &&
            task['catatan_peserta'].toString() != 'null' &&
            task['catatan_peserta'].toString().trim().isNotEmpty)
        ? task['catatan_peserta'].toString()
        : 'Peserta tidak melampirkan catatan.';

    final List<dynamic> rawFiles = task['file_pengumpulan'] ?? [];
    final List<String> fileList = rawFiles.map((e) => e.toString()).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top handle
                Center(
                  child: Container(
                    width: displayWidth(context) * 0.12,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.02),

                // Header & Close
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hasil Kerja Peserta Magang',
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Divider(color: Colors.grey[200]),
                SizedBox(height: displayHeight(context) * 0.015),

                // Info Peserta & Tugas
                Text(
                  namaPeserta,
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.04,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFAD3B3E),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Tugas: $judul',
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.035,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.025),

                // Catatan Peserta Section
                Text(
                  'Catatan dari Peserta:',
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.036,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.01),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(displayWidth(context) * 0.04),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    catatanPeserta,
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.034,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.025),

                // File Pengumpulan Section
                Text(
                  'File Pengumpulan / Lampiran (${fileList.length}):',
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.036,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.01),
                if (fileList.isEmpty)
                  Text(
                    'Tidak ada file yang dilampirkan.',
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.032,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  )
                else
                  ...fileList.map((fileUrl) {
                    final fileName = fileUrl.split('/').last;
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LampiranInstruksiMentor(images: fileList),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F4F8),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.blueGrey.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.attachment_rounded,
                              color: Color(0xFFAD3B3E),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                fileName,
                                style: TextStyle(
                                  fontSize: displayWidth(context) * 0.034,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(
                              Icons.visibility_outlined,
                              size: 18,
                              color: Color(0xFFAD3B3E),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                SizedBox(height: displayHeight(context) * 0.03),

                // Tutup button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAD3B3E),
                      padding: EdgeInsets.symmetric(
                        vertical: displayHeight(context) * 0.015,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Tutup',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: displayWidth(context) * 0.038,
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
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    String tag = (task['status_tugas'] ?? 'Aktif').toString().toUpperCase();
    Color tagBgColor = const Color(0xFFE3F2FD);
    Color tagTextColor = const Color(0xFF1976D2);

    if (tag == 'DITINJAU') {
      tagBgColor = const Color(0xFFFFF8E1);
      tagTextColor = const Color(0xFFB8860B);
    } else if (tag == 'SELESAI') {
      tagBgColor = const Color(0xFFE8F5E9);
      tagTextColor = const Color(0xFF2E7D32);
    } else if (tag == 'REVISI') {
      tagBgColor = const Color(0xFFFFF0E6);
      tagTextColor = const Color(0xFFD9534F);
    }

    String judul = task['judul_tugas'] ?? '-';
    String deadline = task['deadline'] ?? '-';
    if (deadline.contains('-')) {
      final parts = deadline.split('-');
      if (parts.length == 3 && parts[0].length == 4) {
        deadline = "${parts[2]}-${parts[1]}-${parts[0]}";
      }
    }
    String namaPeserta = '-';
    if (task['peserta'] is Map) {
      namaPeserta = task['peserta']['nama_lengkap'] ?? '-';
    }

    return Container(
      margin: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
      padding: EdgeInsets.all(displayWidth(context) * 0.045),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Tag and Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: displayWidth(context) * 0.03,
                  vertical: displayHeight(context) * 0.005,
                ),
                decoration: BoxDecoration(
                  color: tagBgColor,
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.02,
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: tagTextColor,
                    fontSize: displayWidth(context) * 0.027,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: displayWidth(context) * 0.038,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: displayWidth(context) * 0.015),
                  Text(
                    deadline,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: displayWidth(context) * 0.032,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: displayHeight(context) * 0.015),

          // Task Title
          Text(
            judul,
            style: TextStyle(
              fontSize: displayWidth(context) * 0.042,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: displayHeight(context) * 0.015),

          // Assigned User Box
          Container(
            padding: EdgeInsets.all(displayWidth(context) * 0.03),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: displayWidth(context) * 0.05,
                  backgroundColor: const Color(0xFFAD3B3E),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: displayWidth(context) * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Diberikan kepada:',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: displayWidth(context) * 0.03,
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.003),
                    Text(
                      namaPeserta,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: displayWidth(context) * 0.035,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: displayHeight(context) * 0.015),

          // Lihat Detail Button
          InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailTugasMentor(task: task),
                ),
              );
              _fetchPenugasan();
            },
            borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: displayHeight(context) * 0.015,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFBEAEA),
                borderRadius: BorderRadius.circular(
                  displayWidth(context) * 0.03,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lihat Detail',
                    style: TextStyle(
                      color: const Color(0xFFAD3B3E),
                      fontWeight: FontWeight.bold,
                      fontSize: displayWidth(context) * 0.035,
                    ),
                  ),
                  SizedBox(width: displayWidth(context) * 0.02),
                  Icon(
                    Icons.arrow_forward,
                    color: const Color(0xFFAD3B3E),
                    size: displayWidth(context) * 0.045,
                  ),
                ],
              ),
            ),
          ),
          if (_hasSubmission(task)) ...[
            SizedBox(height: displayHeight(context) * 0.012),
            InkWell(
              onTap: () {
                _showHasilKerjaModal(task);
              },
              borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: displayHeight(context) * 0.015,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFAD3B3E),
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.03,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFAD3B3E).withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_turned_in_outlined,
                      color: Colors.white,
                      size: displayWidth(context) * 0.045,
                    ),
                    SizedBox(width: displayWidth(context) * 0.02),
                    Text(
                      'Lihat Hasil Kerja',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: displayWidth(context) * 0.035,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if ((task['status_tugas'] ?? '').toString().toLowerCase() ==
              'ditinjau') ...[
            SizedBox(height: displayHeight(context) * 0.012),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showRevisiDialog(task),
                    icon: Icon(
                      Icons.edit_note,
                      color: const Color(0xFFD9534F),
                      size: displayWidth(context) * 0.045,
                    ),
                    label: Text(
                      'Beri Revisi',
                      style: TextStyle(
                        color: const Color(0xFFD9534F),
                        fontWeight: FontWeight.bold,
                        fontSize: displayWidth(context) * 0.033,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFD9534F)),
                      padding: EdgeInsets.symmetric(
                        vertical: displayHeight(context) * 0.015,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          displayWidth(context) * 0.03,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: displayWidth(context) * 0.03),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _confirmSetujui(task),
                    icon: Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: displayWidth(context) * 0.045,
                    ),
                    label: Text(
                      'Setujui (Selesai)',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: displayWidth(context) * 0.033,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      padding: EdgeInsets.symmetric(
                        vertical: displayHeight(context) * 0.015,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          displayWidth(context) * 0.03,
                        ),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if ((task['status_tugas'] ?? '').toString().toLowerCase() ==
              'revisi') ...[
            SizedBox(height: displayHeight(context) * 0.012),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showCatatanRevisiDialog(task),
                icon: Icon(
                  Icons.rate_review_outlined,
                  color: const Color(0xFFE65100),
                  size: displayWidth(context) * 0.045,
                ),
                label: Text(
                  'Lihat Catatan Revisi',
                  style: TextStyle(
                    color: const Color(0xFFE65100),
                    fontWeight: FontWeight.bold,
                    fontSize: displayWidth(context) * 0.035,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE65100), width: 1.5),
                  padding: EdgeInsets.symmetric(
                    vertical: displayHeight(context) * 0.015,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.03,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
