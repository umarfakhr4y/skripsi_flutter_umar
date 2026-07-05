part of '../conn/auth.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  String _emailText = "";

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
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
                    "Log In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: displayWidth(context) * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MentorMain(),
                      ),
                    );
                  },
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
                    "Mentor",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: displayWidth(context) * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PesertaMain(),
                      ),
                    );
                  },
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
                    "Peserta",
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
                SizedBox(height: displayHeight(context) * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
