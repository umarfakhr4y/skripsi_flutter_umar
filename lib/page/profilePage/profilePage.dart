part of '../../conn/auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  String _namaLengkap = "";
  String _email = "";
  String? _profilePictureUrl;

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
          Uri.parse('$baseApiUrl/api/user'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (mounted) {
            setState(() {
              _email = data['email'] ?? "No Email";
              _namaLengkap = data['data'] != null
                  ? (data['data']['nama_lengkap'] ?? "No Name")
                  : "No Name";
              _profilePictureUrl = data['data'] != null
                  ? data['data']['profile_picture_url']
                  : null;
              _isLoading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _namaLengkap = "Gagal memuat";
              _email = "Gagal memuat";
              _isLoading = false;
            });
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _namaLengkap = "Error";
            _email = "Error";
            _isLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _namaLengkap = "Token tidak ditemukan";
          _email = "Token tidak ditemukan";
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildMenuOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget route,
  }) {
    return _buildMenuOptionAction(
      context,
      icon: icon,
      title: title,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
      },
    );
  }

  Widget _buildMenuOptionAction(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
        padding: EdgeInsets.all(displayWidth(context) * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(displayWidth(context) * 0.02),
              decoration: BoxDecoration(
                color: const Color(0xFFF9EAEB), // Light pinkish
                borderRadius: BorderRadius.circular(
                  displayWidth(context) * 0.02,
                ),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF983A46),
                size: displayWidth(context) * 0.05,
              ),
            ),
            SizedBox(width: displayWidth(context) * 0.04),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.035,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[600],
              size: displayWidth(context) * 0.04,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Very light grey background
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
              left: displayWidth(context) * 0.05,
              right: displayWidth(context) * 0.05,
              bottom: displayHeight(context) * 0.15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: displayHeight(context) * 0.03),
                // Header (Logo)
                Container(
                  padding: EdgeInsets.all(displayWidth(context) * 0.02),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9EAEB), // Light pinkish
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.02,
                    ),
                  ),
                  child: InkWell(
                    onTap: () async {
                      const storage = FlutterSecureStorage();
                      await storage.delete(key: 'access_token');

                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const loginPage(),
                          ),
                        );
                      }
                    },
                    child: Icon(
                      Icons.logout,
                      color: const Color(0xFF983A46),
                      size: displayWidth(context) * 0.05,
                    ),
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.04),

                // Bagian Avatar dan Profil
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            padding: EdgeInsets.all(
                              displayWidth(context) * 0.015,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(
                                  0xFFFDE8EB,
                                ), // light red outer border
                                width: 3,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: displayWidth(context) * 0.12,
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
                                        fontSize: displayWidth(context) * 0.1,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: displayHeight(context) * 0.02),
                      _isLoading
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Column(
                                children: [
                                  Container(
                                    width: displayWidth(context) * 0.4,
                                    height: displayWidth(context) * 0.05,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  SizedBox(
                                    height: displayHeight(context) * 0.01,
                                  ),
                                  Container(
                                    width: displayWidth(context) * 0.3,
                                    height: displayWidth(context) * 0.035,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                Text(
                                  _namaLengkap,
                                  style: TextStyle(
                                    fontSize: displayWidth(context) * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(
                                  height: displayHeight(context) * 0.005,
                                ),
                                Text(
                                  _email,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: displayWidth(context) * 0.035,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.04),

                // Bagian Menu List
                _buildMenuOption(
                  context,
                  icon: Icons.person_outline,
                  title: "Edit Profil",
                  route: EditProfile(),
                ),
                _buildMenuOptionAction(
                  context,
                  icon: Icons.lock_outline,
                  title: "Ubah Password",
                  onTap: () => _showEditPasswordDialog(context),
                ),
                _buildMenuOption(
                  context,
                  icon: Icons.notifications_none,
                  title: "Pengaturan Notifikasi",
                  route: const PengaturanNotifikasiPage(),
                ),

                _buildMenuOption(
                  context,
                  icon: Icons.info_outline,
                  title: "Tentang Aplikasi",
                  route: const AboutPage(),
                ),

                // Footer Version
                Center(
                  child: Text(
                    "Version 2.4.1 Build 2024",
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.025,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _showEditPasswordDialog(BuildContext context) {
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();
    bool isSubmitting = false;
    bool obscureOld = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(displayWidth(context) * 0.05),
              ),
              title: const Text('Ubah Password', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: oldPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Password Lama',
                        suffixIcon: IconButton(
                          icon: Icon(obscureOld ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setStateDialog(() => obscureOld = !obscureOld),
                        ),
                      ),
                      obscureText: obscureOld,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: newPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Password Baru (min. 6)',
                        suffixIcon: IconButton(
                          icon: Icon(obscureNew ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setStateDialog(() => obscureNew = !obscureNew),
                        ),
                      ),
                      obscureText: obscureNew,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Konfirmasi Password Baru',
                        suffixIcon: IconButton(
                          icon: Icon(obscureConfirm ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setStateDialog(() => obscureConfirm = !obscureConfirm),
                        ),
                      ),
                      obscureText: obscureConfirm,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          final oldPass = oldPasswordController.text;
                          final newPass = newPasswordController.text;
                          final confirmPass = confirmPasswordController.text;

                          if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Semua field harus diisi')),
                            );
                            return;
                          }

                          if (newPass.length < 6) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Password baru minimal 6 karakter')),
                            );
                            return;
                          }

                          if (newPass != confirmPass) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Password baru dan konfirmasi tidak cocok')),
                            );
                            return;
                          }

                          setStateDialog(() => isSubmitting = true);

                          const storage = FlutterSecureStorage();
                          String? token = await storage.read(key: 'access_token');
                          
                          if (token == null) {
                            setStateDialog(() => isSubmitting = false);
                            return;
                          }

                          try {
                            final response = await http.post(
                              Uri.parse('$baseApiUrl/api/profile/update-password'),
                              headers: {
                                'Authorization': 'Bearer $token',
                                'Content-Type': 'application/json',
                                'Accept': 'application/json',
                              },
                              body: jsonEncode({
                                'old_password': oldPass,
                                'new_password': newPass,
                                'new_password_confirmation': confirmPass,
                              }),
                            );

                            final data = jsonDecode(response.body);
                            setStateDialog(() => isSubmitting = false);

                            if (response.statusCode == 200 && data['success'] == true) {
                              Navigator.pop(context); // close password dialog
                              
                              // Clear token & Logout
                              await storage.delete(key: 'access_token');
                              if (context.mounted) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Berhasil'),
                                    content: const Text('Password berhasil diubah. Silakan login kembali dengan password yang baru.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context); // close popup
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(builder: (context) => const loginPage()),
                                            (route) => false,
                                          );
                                        },
                                        child: const Text('OK'),
                                      )
                                    ],
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(data['message'] ?? 'Gagal mengubah password')),
                              );
                            }
                          } catch (e) {
                            setStateDialog(() => isSubmitting = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Terjadi kesalahan: $e')),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE84C63),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 16, height: 16,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Simpan', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
