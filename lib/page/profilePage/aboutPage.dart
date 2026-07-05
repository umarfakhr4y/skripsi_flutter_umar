part of '../../conn/auth.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://vocasia.id/about-us');
    // LaunchMode.inAppWebView akan membuka web browser terintegrasi di dalam aplikasi
    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
      debugPrint('Could not launch $url');
    }
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
          "Tentang Aplikasi",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: displayWidth(context) * 0.045,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.language,
              size: displayWidth(context) * 0.25,
              color: const Color(0xFFE46B72),
            ),
            SizedBox(height: displayHeight(context) * 0.03),
            Text(
              "Kunjungi situs web resmi Vocasia\nuntuk informasi lebih lanjut.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: displayWidth(context) * 0.035,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            SizedBox(height: displayHeight(context) * 0.05),
            ElevatedButton(
              onPressed: _launchUrl,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE46B72), // Soft red background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.06,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: displayWidth(context) * 0.1,
                  vertical: displayHeight(context) * 0.02,
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Buka Tentang Kami",
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: displayWidth(context) * 0.03),
                  Icon(
                    Icons.open_in_new,
                    color: Colors.white,
                    size: displayWidth(context) * 0.05,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
