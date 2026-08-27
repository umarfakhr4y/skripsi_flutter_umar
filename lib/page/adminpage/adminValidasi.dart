part of '../../conn/auth.dart';

class AdminValidasi extends StatefulWidget {
  const AdminValidasi({Key? key}) : super(key: key);

  @override
  State<AdminValidasi> createState() => _AdminValidasiState();
}

class _AdminValidasiState extends State<AdminValidasi> {
  bool _isLoading = true;
  List<dynamic> _pendingList = [];

  @override
  void initState() {
    super.initState();
    _fetchPendingRegistrations();
  }

  Future<void> _fetchPendingRegistrations() async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      final response = await http.get(
        Uri.parse('$baseApiUrl/api/admin/pending-registrations'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            _pendingList = data['data'];
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal mengambil data pendaftaran pending'),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
      }
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "U";
    List<String> names = name.split(" ");
    String initials = "";
    int numWords = names.length > 2 ? 2 : names.length;
    for (int i = 0; i < numWords; i++) {
      if (names[i].isNotEmpty) {
        initials += names[i][0].toUpperCase();
      }
    }
    return initials.isEmpty ? "U" : initials;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(displayWidth(context) * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom AppBar (Logo & Avatar)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "v",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.08,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            letterSpacing: -1.0,
                          ),
                        ),
                        TextSpan(
                          text: "o",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.08,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFFE84C63), // Red
                            letterSpacing: -1.0,
                          ),
                        ),
                        TextSpan(
                          text: "casia",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.08,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            letterSpacing: -1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: displayHeight(context) * 0.03),

              // Title and Subtitle
              Text(
                'Pendaftaran Pending',
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.01),
              Text(
                'Tinjau dan setujui pengguna baru yang bergabung di\nplatform.',
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.035,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.03),

              // User List
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _pendingList.isEmpty
                  ? Center(
                      child: Text(
                        'Tidak ada pendaftaran pending.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: displayWidth(context) * 0.04,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _pendingList.length,
                      itemBuilder: (context, index) {
                        final peserta = _pendingList[index];
                        final nama = peserta['nama_lengkap'] ?? 'Tanpa Nama';
                        final univ = peserta['universitas'] ?? '-';
                        final prodi = peserta['prodi'] ?? '-';
                        final desc = "$univ\n$prodi";
                        final dateStr = peserta['created_at'] ?? '';
                        String timeText = 'Baru saja';

                        if (dateStr.isNotEmpty) {
                          try {
                            final date = DateTime.parse(dateStr);
                            timeText = "${date.day}/${date.month}/${date.year}";
                          } catch (_) {}
                        }

                        return _buildPendingCard(
                          context: context,
                          initials: _getInitials(nama),
                          avatarBgColor: const Color(0xFFE2E8F0),
                          avatarTextColor: Colors.black54,
                          name: nama,
                          roleBadge: 'Peserta',
                          badgeBgColor: const Color(0xFFFDE8EB),
                          badgeTextColor: const Color(0xFFB04A50),
                          timeText: 'Mendaftar pada $timeText',
                          descText: desc,
                          onApprove: () => _showApproveDialog(peserta['id']),
                          onReject: () => _showRejectDialog(peserta['id']),
                        );
                      },
                    ),
              SizedBox(height: displayHeight(context) * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showApproveDialog(int pesertaId) async {
    bool isFetchingMentors = true;
    List<dynamic> mentors = [];
    int? selectedMentorId;
    bool isSubmitting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            // Fetch mentors only once
            if (isFetchingMentors && mentors.isEmpty) {
              _fetchMentors()
                  .then((fetchedMentors) {
                    if (mounted) {
                      setStateDialog(() {
                        mentors = fetchedMentors;
                        isFetchingMentors = false;
                      });
                    }
                  })
                  .catchError((e) {
                    if (mounted) {
                      setStateDialog(() {
                        isFetchingMentors = false;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal memuat data mentor: $e')),
                      );
                    }
                  });
            }

            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  displayWidth(context) * 0.04,
                ),
              ),
              title: Text(
                'Pilih Mentor',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: displayWidth(context) * 0.05,
                  color: Colors.black87,
                ),
              ),
              content: isFetchingMentors
                  ? const SizedBox(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFB04A50),
                        ),
                      ),
                    )
                  : mentors.isEmpty
                  ? Text(
                      'Tidak ada mentor tersedia.',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: displayWidth(context) * 0.035,
                      ),
                    )
                  : DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: 'Pilih Mentor',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.grey[50],
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: displayWidth(context) * 0.04,
                          vertical: displayHeight(context) * 0.02,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            displayWidth(context) * 0.03,
                          ),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            displayWidth(context) * 0.03,
                          ),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            displayWidth(context) * 0.03,
                          ),
                          borderSide: const BorderSide(
                            color: Color(0xFFB04A50),
                            width: 1.5,
                          ),
                        ),
                      ),
                      value: selectedMentorId,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey[600],
                      ),
                      items: mentors.map<DropdownMenuItem<int>>((m) {
                        return DropdownMenuItem<int>(
                          value: m['id'],
                          child: Text(
                            m['nama_lengkap'] ?? 'Tanpa Nama',
                            style: const TextStyle(color: Colors.black87),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setStateDialog(() {
                          selectedMentorId = val;
                        });
                      },
                    ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: isSubmitting
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: displayWidth(context) * 0.05,
                          vertical: displayHeight(context) * 0.012,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(
                            displayWidth(context) * 0.05,
                          ),
                        ),
                        child: Text(
                          'Batal',
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.035,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: displayWidth(context) * 0.02),
                    GestureDetector(
                      onTap: isSubmitting || selectedMentorId == null
                          ? null
                          : () async {
                              setStateDialog(() {
                                isSubmitting = true;
                              });
                              try {
                                const storage = FlutterSecureStorage();
                                String? token = await storage.read(
                                  key: 'access_token',
                                );
                                final response = await http.put(
                                  Uri.parse(
                                    '$baseApiUrl/api/admin/pending-registrations/$pesertaId/approve',
                                  ),
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'Accept': 'application/json',
                                    'Authorization': 'Bearer $token',
                                  },
                                  body: jsonEncode({
                                    'mentor_magang_id': selectedMentorId,
                                  }),
                                );
                                if (response.statusCode == 200) {
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Peserta berhasil disetujui!',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    _fetchPendingRegistrations();
                                  }
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Gagal menyetujui peserta',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Terjadi kesalahan: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } finally {
                                if (mounted) {
                                  setStateDialog(() {
                                    isSubmitting = false;
                                  });
                                }
                              }
                            },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: displayWidth(context) * 0.05,
                          vertical: displayHeight(context) * 0.012,
                        ),
                        decoration: BoxDecoration(
                          color: (isSubmitting || selectedMentorId == null)
                              ? Colors.grey[400]
                              : const Color(0xFFB04A50),
                          borderRadius: BorderRadius.circular(
                            displayWidth(context) * 0.05,
                          ),
                        ),
                        child: isSubmitting
                            ? SizedBox(
                                width: displayWidth(context) * 0.04,
                                height: displayWidth(context) * 0.04,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Simpan',
                                style: TextStyle(
                                  fontSize: displayWidth(context) * 0.035,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<List<dynamic>> _fetchMentors() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access_token');

    final response = await http.get(
      Uri.parse('$baseApiUrl/api/admin/mentor'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return data['data'];
      }
    }
    throw Exception('Gagal load mentor');
  }

  Future<void> _showRejectDialog(int pesertaId) async {
    bool isSubmitting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  displayWidth(context) * 0.04,
                ),
              ),
              title: Text(
                'Tolak Pendaftaran',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: displayWidth(context) * 0.05,
                  color: Colors.black87,
                ),
              ),
              content: Text(
                'Apakah Anda yakin ingin menolak dan menghapus data pendaftaran peserta ini secara permanen?',
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.035,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: isSubmitting
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: displayWidth(context) * 0.05,
                          vertical: displayHeight(context) * 0.012,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(
                            displayWidth(context) * 0.05,
                          ),
                        ),
                        child: Text(
                          'Batal',
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.035,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: displayWidth(context) * 0.02),
                    GestureDetector(
                      onTap: isSubmitting
                          ? null
                          : () async {
                              setStateDialog(() {
                                isSubmitting = true;
                              });

                              try {
                                const storage = FlutterSecureStorage();
                                String? token = await storage.read(
                                  key: 'access_token',
                                );

                                final response = await http.delete(
                                  Uri.parse(
                                    '$baseApiUrl/api/admin/pending-registrations/$pesertaId/reject',
                                  ),
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'Accept': 'application/json',
                                    'Authorization': 'Bearer $token',
                                  },
                                );

                                if (response.statusCode == 200) {
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Pendaftaran berhasil ditolak dan dihapus!',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    _fetchPendingRegistrations();
                                  }
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Gagal menolak peserta'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Terjadi kesalahan: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } finally {
                                if (mounted) {
                                  setStateDialog(() {
                                    isSubmitting = false;
                                  });
                                }
                              }
                            },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: displayWidth(context) * 0.05,
                          vertical: displayHeight(context) * 0.012,
                        ),
                        decoration: BoxDecoration(
                          color: isSubmitting
                              ? Colors.grey[400]
                              : Colors.red[700],
                          borderRadius: BorderRadius.circular(
                            displayWidth(context) * 0.05,
                          ),
                        ),
                        child: isSubmitting
                            ? SizedBox(
                                width: displayWidth(context) * 0.04,
                                height: displayWidth(context) * 0.04,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Hapus',
                                style: TextStyle(
                                  fontSize: displayWidth(context) * 0.035,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPendingCard({
    required BuildContext context,
    required String initials,
    required Color avatarBgColor,
    required Color avatarTextColor,
    required String name,
    required String roleBadge,
    required Color badgeBgColor,
    required Color badgeTextColor,
    required String timeText,
    required String descText,
    required VoidCallback onApprove,
    required VoidCallback onReject,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
      padding: EdgeInsets.all(displayWidth(context) * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: displayWidth(context) * 0.07,
                backgroundColor: avatarBgColor,
                child: Text(
                  initials,
                  style: TextStyle(
                    color: avatarTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: displayWidth(context) * 0.045,
                  ),
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
                        fontSize: displayWidth(context) * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.01),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: displayWidth(context) * 0.02,
                            vertical: displayHeight(context) * 0.003,
                          ),
                          decoration: BoxDecoration(
                            color: badgeBgColor,
                            borderRadius: BorderRadius.circular(
                              displayWidth(context) * 0.03,
                            ),
                          ),
                          child: Text(
                            roleBadge,
                            style: TextStyle(
                              fontSize: displayWidth(context) * 0.028,
                              fontWeight: FontWeight.w600,
                              color: badgeTextColor,
                            ),
                          ),
                        ),
                        SizedBox(width: displayWidth(context) * 0.03),
                        Text(
                          timeText,
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.028,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: displayHeight(context) * 0.015),
                    Text(
                      descText,
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.035,
                        color: Colors.grey[700],
                        height: 1.3,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: displayHeight(context) * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Tolak button
              GestureDetector(
                onTap: onReject,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: displayWidth(context) * 0.04,
                    vertical: displayHeight(context) * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.05,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.close,
                        size: displayWidth(context) * 0.035,
                        color: Colors.black87,
                      ),
                      SizedBox(width: displayWidth(context) * 0.01),
                      Text(
                        'Tolak',
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.032,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: displayWidth(context) * 0.02),
              // Setujui button
              GestureDetector(
                onTap: onApprove,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: displayWidth(context) * 0.04,
                    vertical: displayHeight(context) * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB04A50),
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.05,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        size: displayWidth(context) * 0.035,
                        color: Colors.white,
                      ),
                      SizedBox(width: displayWidth(context) * 0.01),
                      Text(
                        'Setujui',
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.032,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
