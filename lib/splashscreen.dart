part of 'conn/auth.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    try {
      const storage = FlutterSecureStorage();
      // Tambahkan timeout agar tidak hang selamanya jika keystore bermasalah
      String? token = await storage
          .read(key: 'access_token')
          .timeout(const Duration(seconds: 5));
      print('===== TOKEN SAAT INI =====');
      print(token);
      print('==========================');

      if (!mounted) return;

      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          if (token != null && token.isNotEmpty) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const GetRolePage()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const loginPage()),
            );
          }
        }
      });
    } catch (e) {
      print('===== ERROR BACA TOKEN =====');
      print(e.toString());
      print('============================');
      // Jika error, tetap arahkan ke halaman login
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const loginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/vocasia-connect-logo.png',
          width: displayWidth(context) * 0.65,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
