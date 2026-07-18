part of '../conn/auth.dart';

class GetRolePage extends StatefulWidget {
  const GetRolePage({super.key});

  @override
  State<GetRolePage> createState() => _GetRolePageState();
}

class _GetRolePageState extends State<GetRolePage> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<void> _checkRole() async {
    try {
      // Ambil token dari storage
      String? token = await _storage.read(key: 'access_token');

      if (token == null) {
        print("Token tidak ditemukan, silahkan login ulang.");
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const loginPage()),
          );
        }
        return;
      }

      // Hit API untuk mendapatkan data user
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final role = data['role']; // Menyesuaikan dengan struktur JSON backend Anda

        print("===============================");
        print("LOGIN BERHASIL!");
        print("Role Pengguna Saat Ini: $role");
        print("===============================");

        // Navigasi berdasarkan role
        if (!mounted) return;
        
        if (role == 'peserta') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PesertaMain()),
          );
        } else if (role == 'mentor') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MentorMain()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Role tidak dikenal: $role')),
          );
          await _storage.delete(key: 'access_token');
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const loginPage()),
            );
          }
        }
      } else {
        print("Gagal mengambil data user. Status code: ${response.statusCode}");
        await _storage.delete(key: 'access_token');
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const loginPage()),
          );
        }
      }
    } catch (e) {
      print("Terjadi kesalahan saat mengambil role: $e");
      await _storage.delete(key: 'access_token');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const loginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFFE84C63), // Warna utama aplikasi Anda (merah)
        ),
      ),
    );
  }
}
