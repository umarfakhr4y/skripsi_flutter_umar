part of '../conn/auth.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _emailText = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndPromptNotificationPermission();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkAndPromptNotificationPermission() async {
    try {
      final settings = await FirebaseMessaging.instance
          .getNotificationSettings();
      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        if (!mounted) return;
        _showNotificationPermissionDialog();
      }
    } catch (e) {
      print("Gagal memeriksa izin notifikasi: $e");
    }
  }

  void _showNotificationPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              displayWidth(dialogContext) * 0.05,
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(
            displayWidth(dialogContext) * 0.06,
            displayWidth(dialogContext) * 0.06,
            displayWidth(dialogContext) * 0.06,
            displayWidth(dialogContext) * 0.04,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: displayWidth(dialogContext) * 0.16,
                height: displayWidth(dialogContext) * 0.16,
                decoration: const BoxDecoration(
                  color: Color(0xFFFDE8EA),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_active_rounded,
                  color: const Color(0xFFAD3B3E),
                  size: displayWidth(dialogContext) * 0.08,
                ),
              ),
              SizedBox(height: displayHeight(dialogContext) * 0.02),
              Text(
                'Izin Notifikasi',
                style: TextStyle(
                  fontSize: displayWidth(dialogContext) * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: displayHeight(dialogContext) * 0.012),
              Text(
                'Mohon izinkan akses notifikasi agar seluruh pemberitahuan tugas baru, jadwal bimbingan, absensi, dan update penting lainnya dapat masuk langsung ke perangkat Anda.',
                style: TextStyle(
                  fontSize: displayWidth(dialogContext) * 0.033,
                  color: Colors.grey[700],
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: displayHeight(dialogContext) * 0.025),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAD3B3E),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      vertical: displayHeight(dialogContext) * 0.015,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        displayWidth(dialogContext) * 0.03,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(dialogContext);
                    try {
                      final newSettings = await FirebaseMessaging.instance
                          .requestPermission(
                            alert: true,
                            badge: true,
                            sound: true,
                          );
                      // Jika sistem Android menolak menampilkan dialog izin (karena user pernah klik "Don't allow")
                      if (newSettings.authorizationStatus !=
                          AuthorizationStatus.authorized) {
                        if (!mounted) return;
                        _showOpenSettingsDialog();
                      }
                    } catch (e) {
                      print("Error request permission: $e");
                    }
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontSize: displayWidth(dialogContext) * 0.038,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOpenSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(displayWidth(ctx) * 0.05),
          ),
          contentPadding: EdgeInsets.fromLTRB(
            displayWidth(ctx) * 0.06,
            displayWidth(ctx) * 0.06,
            displayWidth(ctx) * 0.06,
            displayWidth(ctx) * 0.04,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: displayWidth(ctx) * 0.16,
                height: displayWidth(ctx) * 0.16,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF3E0),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.settings_suggest_rounded,
                  color: Colors.orange.shade800,
                  size: displayWidth(ctx) * 0.08,
                ),
              ),
              SizedBox(height: displayHeight(ctx) * 0.02),
              Text(
                'Izin Notifikasi Dinonaktifkan',
                style: TextStyle(
                  fontSize: displayWidth(ctx) * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: displayHeight(ctx) * 0.012),
              Text(
                'Sistem Android tidak dapat memunculkan pop-up izin karena Anda sebelumnya memilih Dont allow.\n\nUntuk mengaktifkannya, silakan klik tombol di bawah untuk membuka Pengaturan Aplikasi, lalu aktifkan menu "Notifications".',
                style: TextStyle(
                  fontSize: displayWidth(ctx) * 0.033,
                  color: Colors.grey[700],
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: displayHeight(ctx) * 0.025),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: displayHeight(ctx) * 0.014,
                        ),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(
                        'Nanti Saja',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: displayWidth(ctx) * 0.035,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: displayWidth(ctx) * 0.02),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAD3B3E),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          vertical: displayHeight(ctx) * 0.014,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            displayWidth(ctx) * 0.03,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await Geolocator.openAppSettings();
                      },
                      child: Text(
                        'Buka Pengaturan',
                        style: TextStyle(
                          fontSize: displayWidth(ctx) * 0.035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _initPushNotification(String tokenAuth) async {
    await syncPushNotificationToken(tokenAuth);
  }

  void _showLengkapiDataDialog(String token) {
    final TextEditingController nimCtrl = TextEditingController();
    final TextEditingController univCtrl = TextEditingController();
    final TextEditingController prodiCtrl = TextEditingController();
    final TextEditingController alamatCtrl = TextEditingController();

    bool isSubmitting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  displayWidth(context) * 0.04,
                ),
              ),
              title: Text(
                'Lengkapi Data Diri',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: displayWidth(context) * 0.045,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Harap lengkapi data berikut sebelum akun Anda ditinjau oleh Admin.',
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.035,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.02),
                    TextField(
                      controller: nimCtrl,
                      decoration: const InputDecoration(labelText: 'NIM'),
                    ),
                    TextField(
                      controller: univCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Universitas',
                      ),
                    ),
                    TextField(
                      controller: prodiCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Program Studi',
                      ),
                    ),
                    TextField(
                      controller: alamatCtrl,
                      decoration: const InputDecoration(labelText: 'Alamat'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () {
                          // Batalkan dan hapus token dari storage
                          const FlutterSecureStorage().delete(
                            key: 'access_token',
                          );
                          Navigator.pop(context);
                        },
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (nimCtrl.text.isEmpty ||
                              univCtrl.text.isEmpty ||
                              prodiCtrl.text.isEmpty ||
                              alamatCtrl.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Semua kolom harus diisi'),
                              ),
                            );
                            return;
                          }

                          setStateDialog(() {
                            isSubmitting = true;
                          });

                          try {
                            final response = await http.post(
                              Uri.parse('$baseApiUrl/api/profile/update-data'),
                              headers: {
                                'Content-Type': 'application/json',
                                'Accept': 'application/json',
                                'Authorization': 'Bearer $token',
                              },
                              body: jsonEncode({
                                'nim': nimCtrl.text,
                                'universitas': univCtrl.text,
                                'prodi': prodiCtrl.text,
                                'alamat': alamatCtrl.text,
                              }),
                            );

                            if (response.statusCode == 200) {
                              const FlutterSecureStorage().delete(
                                key: 'access_token',
                              );
                              if (context.mounted) {
                                Navigator.pop(context); // Tutup dialog
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Data berhasil disimpan! Akun Anda sedang menunggu persetujuan Admin.',
                                    ),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 4),
                                  ),
                                );
                              }
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Gagal menyimpan data'),
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
                            if (context.mounted) {
                              setStateDialog(() {
                                isSubmitting = false;
                              });
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE84C63),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Simpan',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login dan Password tidak boleh kosong')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await AuthService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      if (result['success']) {
        final data = result['data'];
        final role = data['data']['role'];
        final token = data['access_token'];

        const storage = FlutterSecureStorage();
        await storage.write(key: 'access_token', value: token);

        if (data['is_incomplete'] == true) {
          if (mounted) {
            _showLengkapiDataDialog(token);
          }
          return;
        }

        // Call initPushNotification
        await _initPushNotification(token);

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result['message'].toString())));

          if (role == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminMain()),
            );
          } else if (role == 'mentor') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MentorMain()),
            );
          } else if (role == 'peserta') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PesertaMain()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Role tidak dikenal: $role')),
            );
          }
        }
      } else {
        String errMsg = result['message'].toString();
        if (errMsg.toLowerCase().contains('dinonaktifkan')) {
          const storage = FlutterSecureStorage();
          await storage.delete(key: 'access_token');

          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.04,
                  ),
                ),
                title: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: const Color(0xFFE84C63),
                      size: displayWidth(context) * 0.07,
                    ),
                    SizedBox(width: displayWidth(context) * 0.02),
                    Text(
                      'Akses Ditolak',
                      style: TextStyle(
                        color: const Color(0xFFE84C63),
                        fontWeight: FontWeight.bold,
                        fontSize: displayWidth(context) * 0.05,
                      ),
                    ),
                  ],
                ),
                content: Text(
                  errMsg,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: displayWidth(context) * 0.04,
                    height: 1.4,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Mengerti',
                      style: TextStyle(
                        color: const Color(0xFFE84C63),
                        fontWeight: FontWeight.bold,
                        fontSize: displayWidth(context) * 0.04,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(errMsg)));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: displayWidth(context) * 0.06,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: displayHeight(context) * 0.08),
                Center(
                  child: Text(
                    "Log In",
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.07,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.06),
                Text(
                  "Email",
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.04,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.01),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.03,
                    ),
                  ),
                  child: TextField(
                    controller: _emailController,
                    onChanged: (value) {
                      setState(() {
                        _emailText = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Inputyouremail@hmail.com",
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: displayWidth(context) * 0.035,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: displayWidth(context) * 0.04,
                        vertical: displayHeight(context) * 0.02,
                      ),
                      suffixIcon: _emailText.isEmpty
                          ? Icon(
                              Icons.check_circle_outline,
                              color: Colors.grey[400],
                              size: displayWidth(context) * 0.05,
                            )
                          : _isEmailValid(_emailText)
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: displayWidth(context) * 0.05,
                            )
                          : GestureDetector(
                              onTap: () {
                                _emailController.clear();
                                setState(() {
                                  _emailText = "";
                                });
                              },
                              child: Icon(
                                Icons.cancel,
                                color: Colors.red[400],
                                size: displayWidth(context) * 0.05,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.03),
                Text(
                  "Password",
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.04,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.01),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.03,
                    ),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: "Input your password",
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: displayWidth(context) * 0.035,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: displayWidth(context) * 0.04,
                        vertical: displayHeight(context) * 0.02,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        child: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey[400],
                          size: displayWidth(context) * 0.05,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.02),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LupaPasswordPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Lupa password?",
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.035,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.1),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE84C63),
                    minimumSize: Size(
                      double.infinity,
                      displayHeight(context) * 0.065,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        displayWidth(context) * 0.03,
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: displayHeight(context) * 0.03,
                          width: displayHeight(context) * 0.03,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Text(
                          "Log In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: displayWidth(context) * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),

                SizedBox(height: displayHeight(context) * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Belum punya akun? ",
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.035,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const registerPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.035,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE84C63),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: displayHeight(context) * 0.03),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PresetLogin(),
                      ),
                    );
                  },
                  child: Text(
                    "Gunakan Preset Login (Dev)",
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.035,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
