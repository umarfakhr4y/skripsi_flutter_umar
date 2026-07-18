part of '../../../conn/auth.dart';

class BimbinganPesertaMentor extends StatefulWidget {
  const BimbinganPesertaMentor({super.key});

  @override
  State<BimbinganPesertaMentor> createState() => _BimbinganPesertaMentorState();
}

class _BimbinganPesertaMentorState extends State<BimbinganPesertaMentor> {
  String selectedTab = 'Diajukan';

  bool _isLoadingBimbingan = true;
  List<dynamic> _listBimbingan = [];
  Set<int> _expandedIds = {};

  @override
  void initState() {
    super.initState();
    _fetchBimbingan();
  }

  Future<void> _fetchBimbingan() async {
    setState(() {
      _isLoadingBimbingan = true;
    });
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/mentor/bimbingan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          _listBimbingan = result['data'] ?? [];
          _isLoadingBimbingan = false;
        });
      } else {
        setState(() {
          _isLoadingBimbingan = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingBimbingan = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text(
          'Bimbingan',
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
              // Custom Tab Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTab('Diajukan'),
                  _buildTab('Dijadwalkan'),
                  _buildTab('Riwayat'),
                ],
              ),
              SizedBox(height: displayHeight(context) * 0.03),
              // List
              _isLoadingBimbingan
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(
                          color: Color(0xFFE84C63),
                        ),
                      ),
                    )
                  : Builder(
                      builder: (context) {
                        final displayedList = _listBimbingan.where((item) {
                          String status = (item['status'] ?? '')
                              .toString()
                              .toLowerCase();
                          bool isPast = item['is_past'] ?? false;

                          if (selectedTab == 'Diajukan')
                            return status == 'requested' && !isPast;
                          if (selectedTab == 'Dijadwalkan')
                            return (status == 'disetujui' ||
                                status == 'accepted') && !isPast;
                          if (selectedTab == 'Riwayat')
                            return status == 'selesai' ||
                                status == 'ditolak' ||
                                status == 'rejected' ||
                                isPast;
                          return false;
                        }).toList();

                        if (displayedList.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.only(
                              top: displayHeight(context) * 0.05,
                            ),
                            child: const Center(
                              child: Text(
                                "Belum ada data bimbingan",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: displayedList.length,
                          itemBuilder: (context, index) {
                            return _buildBimbinganCard(displayedList[index]);
                          },
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String title) {
    final isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = title;
        });
      },
      child: Container(
        padding: EdgeInsets.only(bottom: displayHeight(context) * 0.005),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFFE84C63) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: displayWidth(context) * 0.035,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.black : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildBimbinganCard(dynamic bimbingan) {
    final int bimbinganId = bimbingan['id'] ?? 0;
    final bool isExpanded = _expandedIds.contains(bimbinganId);

    return Container(
      margin: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedIds.remove(bimbinganId);
                } else {
                  _expandedIds.add(bimbinganId);
                }
              });
            },
            contentPadding: EdgeInsets.symmetric(
              horizontal: displayWidth(context) * 0.04,
              vertical: displayHeight(context) * 0.005,
            ),
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFE84C63),
              radius: displayWidth(context) * 0.055,
              child: Text(
                (bimbingan['peserta']?['nama'] ?? 'U')[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              bimbingan['peserta']?['nama'] ?? 'Unknown',
              style: TextStyle(
                fontSize: displayWidth(context) * 0.035,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'Dijadwalkan pada :' + bimbingan['tanggal'] ?? '',
              style: TextStyle(
                fontSize: displayWidth(context) * 0.03,
                color: Colors.grey[600],
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: Colors.black,
              size: displayWidth(context) * 0.06,
            ),
          ),
          if (isExpanded)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                Container(
                  width: double.infinity,
                  color: const Color(0xFFF9F9F9),
                  padding: EdgeInsets.symmetric(
                    horizontal: displayWidth(context) * 0.06,
                    vertical: displayHeight(context) * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Materi yang ingin dibahas',
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.03,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: displayHeight(context) * 0.005,
                        ),
                        child: Text(
                          bimbingan['topik'] ?? '-',
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.032,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (bimbingan['status'].toString().toLowerCase() ==
                        'requested' ||
                    bimbingan['status'].toString().toLowerCase() == 'menunggu')
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE84C63),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                          displayWidth(context) * 0.04,
                        ),
                        bottomRight: Radius.circular(
                          displayWidth(context) * 0.04,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _showAcceptBimbinganModal(context, bimbinganId);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: displayHeight(context) * 0.015,
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: displayWidth(context) * 0.06,
                                  ),
                                  SizedBox(
                                    height: displayHeight(context) * 0.005,
                                  ),
                                  Text(
                                    'Setujui',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: displayWidth(context) * 0.025,
                                      fontWeight: FontWeight.w500,
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
                              _updateBimbinganStatus(
                                bimbinganId,
                                'rejected',
                                null,
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: displayHeight(context) * 0.015,
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: displayWidth(context) * 0.05,
                                  ),
                                  SizedBox(
                                    height: displayHeight(context) * 0.005,
                                  ),
                                  Text(
                                    'Tolak',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: displayWidth(context) * 0.025,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(displayWidth(context) * 0.04),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                          displayWidth(context) * 0.04,
                        ),
                        bottomRight: Radius.circular(
                          displayWidth(context) * 0.04,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (bimbingan['link_meet'] != null &&
                            bimbingan['link_meet'] != '') ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: displayWidth(context) * 0.03,
                              vertical: displayHeight(context) * 0.012,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.blue.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.video_call,
                                  size: displayWidth(context) * 0.05,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: displayWidth(context) * 0.02),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Link Google Meet",
                                        style: TextStyle(
                                          fontSize:
                                              displayWidth(context) * 0.03,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      SizedBox(
                                        height: displayHeight(context) * 0.005,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Clipboard.setData(
                                            ClipboardData(
                                              text: bimbingan['link_meet'],
                                            ),
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Link disalin ke clipboard!",
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        },
                                        child: Text(
                                          bimbingan['link_meet'],
                                          style: TextStyle(
                                            fontSize:
                                                displayWidth(context) * 0.032,
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          Text(
                            'Status Bimbingan:',
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.03,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: displayHeight(context) * 0.005),
                          Text(
                            bimbingan['status'].toString().toUpperCase(),
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.032,
                              fontWeight: FontWeight.bold,
                              color:
                                  (bimbingan['status']
                                              .toString()
                                              .toLowerCase() ==
                                          'accepted' ||
                                      bimbingan['status']
                                              .toString()
                                              .toLowerCase() ==
                                          'disetujui')
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  void _showAcceptBimbinganModal(BuildContext context, int bimbinganId) {
    final TextEditingController linkController = TextEditingController();
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Setujui Bimbingan",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Masukkan Link Google Meet",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: linkController,
                      decoration: InputDecoration(
                        hintText: "https://meet.google.com/xxx-xxxx-xxx",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE84C63),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSubmitting
                            ? null
                            : () async {
                                if (linkController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Link Google Meet wajib diisi!",
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                setModalState(() {
                                  isSubmitting = true;
                                });

                                await _updateBimbinganStatus(
                                  bimbinganId,
                                  'accepted',
                                  linkController.text.trim(),
                                );

                                setModalState(() {
                                  isSubmitting = false;
                                });

                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE84C63),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Setujui",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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

  Future<void> _updateBimbinganStatus(
    int id,
    String status,
    String? linkMeet,
  ) async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      final Map<String, dynamic> body = {'status': status};
      if (linkMeet != null && linkMeet.isNotEmpty) {
        body['link_meet'] = linkMeet;
      }

      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/api/mentor/bimbingan/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Berhasil mengubah status bimbingan"),
            backgroundColor: Colors.green,
          ),
        );
        _fetchBimbingan(); // Refresh list after change
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal mengubah status"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Terjadi kesalahan sistem"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
