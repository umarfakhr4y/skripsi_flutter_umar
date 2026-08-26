part of '../../conn/auth.dart';

class DetailMentorAdmin extends StatefulWidget {
  final int mentorId;
  const DetailMentorAdmin({super.key, required this.mentorId});

  @override
  State<DetailMentorAdmin> createState() => _DetailMentorAdminState();
}

class _DetailMentorAdminState extends State<DetailMentorAdmin> {
  Map<String, dynamic>? _mentorData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetailMentor();
  }

  Future<void> _fetchDetailMentor() async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      final response = await http.get(
        Uri.parse('$baseApiUrl/api/admin/mentor/${widget.mentorId}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _mentorData = data['data'];
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text(
          'Profil Mentor',
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
        actions: [
          if (!_isLoading && _mentorData != null)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onSelected: (value) async {
                if (value == 'edit_profil') {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditMentorAdmin(mentorId: widget.mentorId),
                    ),
                  );
                  if (result == true) {
                    setState(() => _isLoading = true);
                    _fetchDetailMentor();
                  }
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit_profil',
                  child: Text('Edit Profil'),
                ),
              ],
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFE84C63)),
            )
          : _mentorData == null
          ? const Center(
              child: Text(
                "Gagal memuat data mentor",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(displayWidth(context) * 0.05),
                child: Column(
                  children: [
                    _buildProfilHeader(),
                    SizedBox(height: displayHeight(context) * 0.02),
                    _buildDataDiri(),
                    SizedBox(height: displayHeight(context) * 0.02),
                    _buildDaftarPeserta(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfilHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: displayHeight(context) * 0.03,
        horizontal: displayWidth(context) * 0.04,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: displayWidth(context) * 0.1,
            backgroundColor: Colors.grey[400],
            backgroundImage: _mentorData?['profile_picture_url'] != null
                ? NetworkImage(_mentorData!['profile_picture_url'])
                : null,
            child: _mentorData?['profile_picture_url'] == null
                ? Text(
                    (_mentorData?['nama_lengkap'] != null &&
                            _mentorData!['nama_lengkap'].isNotEmpty)
                        ? _mentorData!['nama_lengkap'][0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.08,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          SizedBox(height: displayHeight(context) * 0.02),
          Text(
            _mentorData?['nama_lengkap'] ?? 'Unknown',
            style: TextStyle(
              fontSize: displayWidth(context) * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: displayHeight(context) * 0.005),
          Text(
            '${_mentorData?['nip_karyawan'] ?? '-'} Ã¢â‚¬Â¢ ${_mentorData?['divisi'] ?? '-'}',
            style: TextStyle(
              fontSize: displayWidth(context) * 0.03,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDataDiri() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(displayWidth(context) * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline,
                color: const Color(0xFFE57373),
                size: displayWidth(context) * 0.05,
              ),
              SizedBox(width: displayWidth(context) * 0.02),
              Text(
                'Data Diri',
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: displayHeight(context) * 0.02),
          _buildDataRow('Email', _mentorData?['email'] ?? '-'),
          SizedBox(height: displayHeight(context) * 0.015),
          _buildDataRow('NIP Karyawan', _mentorData?['nip_karyawan'] ?? '-'),
          SizedBox(height: displayHeight(context) * 0.015),
          _buildDataRow('Divisi', _mentorData?['divisi'] ?? '-'),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: displayWidth(context) * 0.35,
          child: Text(
            label,
            style: TextStyle(
              fontSize: displayWidth(context) * 0.035,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: displayWidth(context) * 0.035,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDaftarPeserta() {
    List pesertaList = _mentorData?['peserta'] ?? [];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(displayWidth(context) * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.groups_outlined,
                    color: const Color(0xFF5C6BC0), // Indigo
                    size: displayWidth(context) * 0.05,
                  ),
                  SizedBox(width: displayWidth(context) * 0.02),
                  Text(
                    'Peserta Bimbingan',
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: displayWidth(context) * 0.03,
                  vertical: displayHeight(context) * 0.005,
                ),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.05,
                  ),
                ),
                child: Text(
                  '${_mentorData?['jumlah_peserta'] ?? 0}',
                  style: TextStyle(
                    color: Colors.indigo[700],
                    fontWeight: FontWeight.bold,
                    fontSize: displayWidth(context) * 0.035,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: displayHeight(context) * 0.02),
          if (pesertaList.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: displayHeight(context) * 0.02,
                ),
                child: Text(
                  'Belum ada peserta bimbingan',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: displayWidth(context) * 0.035,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pesertaList.length,
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.grey[200]),
              itemBuilder: (context, index) {
                final peserta = pesertaList[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPesertaMagangMentor(
                          pesertaId: peserta['id'],
                          isAdmin: true,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: displayHeight(context) * 0.01,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: displayWidth(context) * 0.05,
                          backgroundColor: Colors.indigo[100],
                          backgroundImage:
                              peserta['profile_picture_url'] != null
                              ? NetworkImage(peserta['profile_picture_url'])
                              : null,
                          child: peserta['profile_picture_url'] == null
                              ? Text(
                                  peserta['nama_lengkap'] != null &&
                                          peserta['nama_lengkap'].isNotEmpty
                                      ? peserta['nama_lengkap'][0].toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    fontSize: displayWidth(context) * 0.04,
                                    color: Colors.indigo[800],
                                  ),
                                )
                              : null,
                        ),
                        SizedBox(width: displayWidth(context) * 0.03),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                peserta['nama_lengkap'] ?? 'Unknown',
                                style: TextStyle(
                                  fontSize: displayWidth(context) * 0.035,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: displayHeight(context) * 0.005),
                              Text(
                                peserta['universitas'] ?? '-',
                                style: TextStyle(
                                  fontSize: displayWidth(context) * 0.03,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.grey[400],
                          size: displayWidth(context) * 0.05,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
