part of '../../conn/auth.dart';

class EditMentorAdmin extends StatefulWidget {
  final int mentorId;
  const EditMentorAdmin({super.key, required this.mentorId});

  @override
  State<EditMentorAdmin> createState() => _EditMentorAdminState();
}

class _EditMentorAdminState extends State<EditMentorAdmin> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nipController = TextEditingController();
  int? _selectedDivisiId;

  bool _isLoading = true;
  bool _isSaving = false;
  List<dynamic> _divisiList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      // Fetch Mentor Data
      final mentorRes = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/admin/mentor/${widget.mentorId}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      // Fetch Divisi List
      final divisiRes = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/admin/divisi'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (mentorRes.statusCode == 200 && divisiRes.statusCode == 200) {
        final mentorData = json.decode(mentorRes.body)['data'];
        final divisiData = json.decode(divisiRes.body)['data'];

        if (mounted) {
          setState(() {
            _namaController.text = mentorData['nama_lengkap'] ?? '';
            _nipController.text = mentorData['nip_karyawan'] ?? '';
            _selectedDivisiId = mentorData['divisi_id'];
            _divisiList = divisiData ?? [];
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal memuat data mentor atau divisi')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_namaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama lengkap wajib diisi')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/api/admin/mentor/${widget.mentorId}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'nama_lengkap': _namaController.text,
          'nip_karyawan': _nipController.text,
          'divisi_id': _selectedDivisiId,
        }),
      );

      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200 && jsonResponse['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil mentor berhasil diperbarui!'),
            ),
          );
          Navigator.pop(context, true); // Return true to signal refresh
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text(
          'Edit Profil Mentor',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: displayWidth(context) * 0.05,
          ),
        ),
        backgroundColor: const Color(0xFFEEEEEE),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFE84C63)),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(displayWidth(context) * 0.05),
              child: Container(
                padding: EdgeInsets.all(displayWidth(context) * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      label: 'Nama Lengkap',
                      controller: _namaController,
                      icon: Icons.person_outline,
                    ),
                    SizedBox(height: displayHeight(context) * 0.02),
                    _buildTextField(
                      label: 'NIP Karyawan',
                      controller: _nipController,
                      icon: Icons.badge_outlined,
                    ),
                    SizedBox(height: displayHeight(context) * 0.02),
                    _buildDivisiDropdown(),
                    SizedBox(height: displayHeight(context) * 0.04),
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
                          elevation: 2,
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Simpan Perubahan',
                                style: TextStyle(
                                  fontSize: displayWidth(context) * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: displayWidth(context) * 0.035,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: displayHeight(context) * 0.01),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
              borderSide: const BorderSide(color: Color(0xFFE84C63)),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: displayHeight(context) * 0.015,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivisiDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Divisi',
          style: TextStyle(
            fontSize: displayWidth(context) * 0.035,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: displayHeight(context) * 0.01),
        Container(
          padding: EdgeInsets.symmetric(horizontal: displayWidth(context) * 0.03),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              hint: const Text('Pilih Divisi'),
              value: _selectedDivisiId,
              icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              items: _divisiList.map((divisi) {
                return DropdownMenuItem<int>(
                  value: divisi['id'],
                  child: Text(divisi['nama_divisi'] ?? 'Unknown'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDivisiId = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
