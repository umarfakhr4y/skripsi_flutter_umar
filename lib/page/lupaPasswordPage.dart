part of '../conn/auth.dart';

class LupaPasswordPage extends StatefulWidget {
  const LupaPasswordPage({super.key});

  @override
  State<LupaPasswordPage> createState() => _LupaPasswordPageState();
}

class _LupaPasswordPageState extends State<LupaPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Reset Password",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w800,
            fontSize: displayWidth(context) * 0.055,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: displayWidth(context) * 0.06,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: displayHeight(context) * 0.03),
                Text(
                  "Masukkan email yang terhubung ke akunmu dan kami akan mengirimkan link untuk mereset password",
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.035,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.04),
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
                    decoration: InputDecoration(
                      hintText: "Inputyouremail@gmail.com",
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: displayWidth(context) * 0.035,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: displayWidth(context) * 0.04,
                        vertical: displayHeight(context) * 0.02,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.05),
                ElevatedButton(
                  onPressed: () {},
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
                  child: Text(
                    "Reset Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: displayWidth(context) * 0.045,
                      fontWeight: FontWeight.bold,
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
}
