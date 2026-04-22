part of '../conn/auth.dart';

class registerPage extends StatefulWidget {
  const registerPage({super.key});

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();

  String _emailText = "";
  String _confirmEmailText = "";

  @override
  void dispose() {
    _emailController.dispose();
    _confirmEmailController.dispose();
    super.dispose();
  }

  bool _isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    bool obscureText = false,
    Widget? suffixIcon,
    TextEditingController? controller,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
            borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: displayWidth(context) * 0.035,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: displayWidth(context) * 0.04,
                vertical: displayHeight(context) * 0.02,
              ),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
        SizedBox(height: displayHeight(context) * 0.025),
      ],
    );
  }

  Widget _buildEmailSuffixIcon(
    String text,
    TextEditingController controller,
    Function(String) updateState,
  ) {
    if (text.isEmpty) {
      return Icon(
        Icons.check_circle_outline,
        color: Colors.grey[400],
        size: displayWidth(context) * 0.05,
      );
    } else if (_isEmailValid(text)) {
      return Icon(
        Icons.check_circle,
        color: Colors.green,
        size: displayWidth(context) * 0.05,
      );
    } else {
      return GestureDetector(
        onTap: () {
          controller.clear();
          updateState("");
        },
        child: Icon(
          Icons.cancel,
          color: Colors.red[400],
          size: displayWidth(context) * 0.05,
        ),
      );
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
                SizedBox(height: displayHeight(context) * 0.04),
                Center(
                  child: Text(
                    "Register",
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.07,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.04),

                _buildTextField(
                  label: "Nama Lengkap",
                  hintText: "Masukan nama",
                ),

                _buildTextField(
                  label: "Email",
                  hintText: "Inputyouremail@hmail.com",
                  controller: _emailController,
                  onChanged: (val) => setState(() => _emailText = val),
                  suffixIcon: _buildEmailSuffixIcon(
                    _emailText,
                    _emailController,
                    (val) => setState(() => _emailText = val),
                  ),
                ),

                _buildTextField(
                  label: "Konfirmasi Email",
                  hintText: "Inputyouremail@hmail.com",
                  controller: _confirmEmailController,
                  onChanged: (val) => setState(() => _confirmEmailText = val),
                  suffixIcon: _buildEmailSuffixIcon(
                    _confirmEmailText,
                    _confirmEmailController,
                    (val) => setState(() => _confirmEmailText = val),
                  ),
                ),

                _buildTextField(
                  label: "No Telepon",
                  hintText: "Masukan no telepon",
                ),

                _buildTextField(
                  label: "Your password",
                  hintText: "Masukan password",
                  obscureText: !_isPasswordVisible,
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

                _buildTextField(
                  label: "Konfirmasi Password",
                  hintText: "Masukan password",
                  obscureText: !_isConfirmPasswordVisible,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                    child: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey[400],
                      size: displayWidth(context) * 0.05,
                    ),
                  ),
                ),

                SizedBox(height: displayHeight(context) * 0.01),
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
                    "Register",
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
                      "Sudah Punya Akun? ",
                      style: TextStyle(
                        fontSize: displayWidth(context) * 0.035,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Log In",
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
