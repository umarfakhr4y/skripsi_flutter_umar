part of '../../conn/auth.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _isUploading = false;
  String? _profilePictureUrl;
  String _namaLengkap = "";
  String _email = "";
  String _universitas = "";
  String _divisi = "";
  String _noTelpon = "";
  String _role = "peserta";
  String _nipKaryawan = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access_token');

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('http://10.0.2.2:8000/api/user'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (mounted) {
            setState(() {
              _namaLengkap = data['data'] != null
                  ? (data['data']['nama_lengkap'] ?? "Tidak diketahui")
                  : "Tidak diketahui";
              _profilePictureUrl = data['data'] != null
                  ? data['data']['profile_picture_url']
                  : null;

              _email = data['email'] ?? "-";
              _role = data['role'] ?? "peserta";

              if (_role == 'peserta') {
                _universitas = data['data'] != null
                    ? (data['data']['universitas'] ?? "-")
                    : "-";
                _divisi = data['data'] != null
                    ? (data['data']['prodi'] ?? "-")
                    : "-";
                _noTelpon = data['data'] != null
                    ? (data['data']['no_telpon'] ?? "-")
                    : "-";
              } else if (_role == 'mentor') {
                _nipKaryawan = data['data'] != null
                    ? (data['data']['nip_karyawan'] ?? "-")
                    : "-";
                if (data['data'] != null && data['data']['divisi'] != null) {
                  _divisi = data['data']['divisi']['nama_divisi'] ?? "-";
                } else {
                  _divisi = data['data'] != null
                      ? (data['data']['divisi_id']?.toString() ?? "-")
                      : "-";
                }
              }

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
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _isUploading = true;
        });

        File file = File(result.files.single.path!);
        const storage = FlutterSecureStorage();
        String? token = await storage.read(key: 'access_token');

        if (token != null) {
          var request = http.MultipartRequest(
            'POST',
            Uri.parse('http://10.0.2.2:8000/api/profile/update-picture'),
          );
          request.headers['Authorization'] = 'Bearer $token';
          request.files.add(
            await http.MultipartFile.fromPath('profile_picture', file.path),
          );

          var response = await request.send();
          var responseData = await response.stream.bytesToString();
          var jsonResponse = jsonDecode(responseData);

          if (response.statusCode == 200 && jsonResponse['success'] == true) {
            setState(() {
              _profilePictureUrl = jsonResponse['path'];
            });
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Foto profil berhasil diperbarui!'),
                ),
              );
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(jsonResponse['message'] ?? 'Gagal upload foto'),
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString().replaceAll('Exception: ', '')}',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required String initialValue,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: displayWidth(context) * 0.03,
            color: const Color(0xFF6B5E5E),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: displayHeight(context) * 0.01),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: displayWidth(context) * 0.04,
            vertical:
                displayHeight(context) * 0.002, // inner padding for textfield
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(displayWidth(context) * 0.025),
          ),
          child: TextFormField(
            initialValue: initialValue,
            enabled: enabled,
            style: TextStyle(
              color: enabled ? Colors.black87 : Colors.grey[600],
              fontSize: displayWidth(context) * 0.038,
            ),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
        SizedBox(height: displayHeight(context) * 0.025),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Very light grey background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color(0xFF983A46), // Dark red back button
            size: displayWidth(context) * 0.06,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Account",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: displayWidth(context) * 0.045,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: displayWidth(context) * 0.05,
                    vertical: displayHeight(context) * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      Center(
                        child: GestureDetector(
                          onTap: _isUploading ? null : _pickAndUploadImage,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: displayWidth(context) * 0.13,
                                  backgroundColor: Colors.grey[400],
                                  backgroundImage: _profilePictureUrl != null
                                      ? NetworkImage(_profilePictureUrl!)
                                      : null,
                                  child: _profilePictureUrl == null
                                      ? Text(
                                          _namaLengkap.isNotEmpty
                                              ? _namaLengkap[0].toUpperCase()
                                              : '?',
                                          style: TextStyle(
                                            fontSize:
                                                displayWidth(context) * 0.11,
                                            color: Colors.white,
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                              if (_isUploading)
                                Container(
                                  width: displayWidth(context) * 0.26,
                                  height: displayWidth(context) * 0.26,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              else
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(
                                      displayWidth(context) * 0.015,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE46B72),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: displayWidth(context) * 0.04,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: displayHeight(context) * 0.04),

                      // Form Fields
                      _buildTextField(
                        context,
                        label: "NAMA LENGKAP",
                        initialValue: _namaLengkap,
                        enabled: false,
                      ),
                      if (_role == 'peserta') ...[
                        _buildTextField(
                          context,
                          label: "INSTANSI/UNIVERSITAS",
                          initialValue: _universitas,
                          enabled: false,
                        ),
                        _buildTextField(
                          context,
                          label: "PROGRAM STUDI",
                          initialValue: _divisi,
                          enabled: false,
                        ),
                        _buildTextField(
                          context,
                          label: "NOMOR WHATSAPP",
                          initialValue: _noTelpon,
                          enabled: false,
                        ),
                      ] else if (_role == 'mentor') ...[
                        _buildTextField(
                          context,
                          label: "NIP KARYAWAN",
                          initialValue: _nipKaryawan,
                          enabled: false,
                        ),
                        _buildTextField(
                          context,
                          label: "DIVISI",
                          initialValue: _divisi,
                          enabled: false,
                        ),
                      ],
                      _buildTextField(
                        context,
                        label: "ALAMAT EMAIL",
                        initialValue: _email,
                        enabled: false,
                      ),

                      SizedBox(height: displayHeight(context) * 0.02),

                      // Note instead of Save Button
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(displayWidth(context) * 0.04),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            displayWidth(context) * 0.03,
                          ),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue[700],
                              size: displayWidth(context) * 0.05,
                            ),
                            SizedBox(width: displayWidth(context) * 0.03),
                            Expanded(
                              child: Text(
                                "Untuk mengubah data diri (kecuali foto profil), silakan hubungi Administrator sistem.",
                                style: TextStyle(
                                  fontSize: displayWidth(context) * 0.03,
                                  color: Colors.blue[800],
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: displayHeight(context) * 0.04),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
