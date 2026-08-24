part of '../../conn/auth.dart';

class EditProfileAdmin extends StatefulWidget {
  final int pesertaId;
  const EditProfileAdmin({super.key, required this.pesertaId});

  @override
  State<EditProfileAdmin> createState() => _EditProfileAdminState();
}

class _EditProfileAdminState extends State<EditProfileAdmin> {
  bool _isUploading = false;
  String? _profilePictureUrl;

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _universitasController = TextEditingController();
  final TextEditingController _prodiController = TextEditingController();
  final TextEditingController _noTelponController = TextEditingController();

  String _email = "";
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
    print(widget.pesertaId);
  }

  Future<void> _fetchProfileData() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access_token');

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse(
            'http://10.0.2.2:8000/api/admin/peserta/${widget.pesertaId}',
          ),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          if (jsonResponse['success'] == true) {
            final data = jsonResponse['data'];
            if (mounted) {
              setState(() {
                _namaController.text = data['nama_lengkap'] ?? "";
                _universitasController.text = data['universitas'] ?? "";
                _prodiController.text = data['prodi'] ?? "";
                _noTelponController.text = data['no_telpon'] ?? "";

                _profilePictureUrl = data['profile_picture_url'];
                _email = data['email'] ?? "-";

                _isLoading = false;
              });
            }
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
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/api/admin/peserta/${widget.pesertaId}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'nama_lengkap': _namaController.text,
          'universitas': _universitasController.text,
          'prodi': _prodiController.text,
          'no_telpon': _noTelponController.text,
        }),
      );

      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200 && jsonResponse['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil peserta berhasil diperbarui!'),
            ),
          );
          Navigator.pop(
            context,
            true,
          ); // Return true to signal refresh if needed
        }
      } else {
        if (mounted) {
          final errorMessage = jsonResponse['error'] != null
              ? '${jsonResponse['message']} - ${jsonResponse['error']}'
              : (jsonResponse['message'] ?? 'Gagal menyimpan profil');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessage)));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
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
            vertical: displayHeight(context) * 0.002,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(displayWidth(context) * 0.025),
          ),
          child: TextFormField(
            controller: controller,
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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color(0xFF983A46),
            size: displayWidth(context) * 0.06,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Edit Profil Peserta",
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
                                        _namaController.text.isNotEmpty
                                            ? _namaController.text[0]
                                                  .toUpperCase()
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
                          ],
                        ),
                      ),
                      SizedBox(height: displayHeight(context) * 0.04),

                      // Form Fields
                      _buildTextField(
                        context,
                        label: "NAMA LENGKAP",
                        controller: _namaController,
                        enabled: true,
                      ),
                      _buildTextField(
                        context,
                        label: "INSTANSI/UNIVERSITAS",
                        controller: _universitasController,
                        enabled: true,
                      ),
                      _buildTextField(
                        context,
                        label: "PROGRAM STUDI",
                        controller: _prodiController,
                        enabled: true,
                      ),
                      _buildTextField(
                        context,
                        label: "NOMOR WHATSAPP",
                        controller: _noTelponController,
                        enabled: true,
                      ),
                      // Email is read-only since it belongs to User model
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ALAMAT EMAIL",
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
                              vertical: displayHeight(context) * 0.015,
                            ),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F4F4),
                              borderRadius: BorderRadius.circular(
                                displayWidth(context) * 0.025,
                              ),
                            ),
                            child: Text(
                              _email,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: displayWidth(context) * 0.038,
                              ),
                            ),
                          ),
                          SizedBox(height: displayHeight(context) * 0.025),
                        ],
                      ),

                      SizedBox(height: displayHeight(context) * 0.02),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: displayHeight(context) * 0.06,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE84C63),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                displayWidth(context) * 0.03,
                              ),
                            ),
                            elevation: 0,
                          ),
                          child: _isSaving
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Simpan Perubahan",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: displayWidth(context) * 0.04,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
