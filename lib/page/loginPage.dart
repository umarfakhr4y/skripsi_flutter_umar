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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
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
        final role = result['data']['data']['role'];
        final token = result['data']['access_token'];

        const storage = FlutterSecureStorage();
        await storage.write(key: 'access_token', value: token);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'].toString())));

        if (role == 'admin') {
          // Jika ada halaman admin, panggil di sini
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Halaman Admin belum tersedia')),
          // );
          print('admin');
        } else if (role == 'mentor') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MentorMain()),
          );
          print('mentor');
        } else if (role == 'peserta') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PesertaMain()),
          );
          print('peserta');
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Role tidak dikenal: $role')));
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'].toString())));
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
                SizedBox(height: displayHeight(context) * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
