part of '../conn/auth.dart';

class PresetLogin extends StatefulWidget {
  const PresetLogin({Key? key}) : super(key: key);

  @override
  State<PresetLogin> createState() => _PresetLoginState();
}

class _PresetLoginState extends State<PresetLogin> {
  bool _isLoading = false;

  Future<void> _login(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthService.login(email, password);

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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Akun belum lengkap. Gunakan login manual.')),
            );
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'].toString())),
          );

          if (role == 'admin') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AdminMain()),
              (route) => false,
            );
          } else if (role == 'mentor') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MentorMain()),
              (route) => false,
            );
          } else if (role == 'peserta') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const PesertaMain()),
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Role tidak dikenal: $role')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'].toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildLoginButton({
    required String title,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          title,
          style: TextStyle(
            fontSize: displayWidth(context) * 0.04,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: displayHeight(context) * 0.02),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Developer Login Preset'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(displayWidth(context) * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLoginButton(
                  title: 'Login sbg Admin',
                  color: Colors.redAccent,
                  icon: Icons.admin_panel_settings,
                  onTap: () => _login('admin@mail.com', 'password123'),
                ),
                _buildLoginButton(
                  title: 'Login sbg Mentor',
                  color: Colors.blueAccent,
                  icon: Icons.person,
                  onTap: () => _login('mentor@vocasia.com', '123123123'),
                ),
                _buildLoginButton(
                  title: 'Login sbg Peserta',
                  color: Colors.green,
                  icon: Icons.school,
                  onTap: () => _login('peserta@vocasia.com', '123123123'),
                ),
                SizedBox(height: displayHeight(context) * 0.04),
                const Divider(),
                SizedBox(height: displayHeight(context) * 0.04),
                _buildLoginButton(
                  title: 'Login Manual',
                  color: Colors.grey[800]!,
                  icon: Icons.keyboard,
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const loginPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFFE84C63)),
              ),
            ),
        ],
      ),
    );
  }
}
