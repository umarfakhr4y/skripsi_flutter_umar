part of '../../conn/auth.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required String initialValue,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: displayWidth(context) * 0.03,
            color: const Color(0xFF6B5E5E),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: displayHeight(context) * 0.01),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: displayWidth(context) * 0.04,
            vertical:
                displayHeight(context) * 0.002, // inner padding for textfield
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(displayWidth(context) * 0.025),
          ),
          child: TextFormField(
            initialValue: initialValue,
            enabled: enabled,
            style: TextStyle(
              color: enabled ? Colors.black87 : Colors.grey[600],
              fontSize: displayWidth(context) * 0.038,
            ),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
        SizedBox(height: displayHeight(context) * 0.025),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Very light grey background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color(0xFF983A46), // Dark red back button
            size: displayWidth(context) * 0.06,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Account",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: displayWidth(context) * 0.045,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: displayWidth(context) * 0.05,
              vertical: displayHeight(context) * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: CircleAvatar(
                      radius: displayWidth(context) * 0.13,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: const NetworkImage(
                        'https://i.pravatar.cc/150?img=11', // Placeholder avatar
                      ),
                    ),
                  ),
                ),
                SizedBox(height: displayHeight(context) * 0.04),

                // Form Fields
                _buildTextField(
                  context,
                  label: "NAMA LENGKAP",
                  initialValue: "Fikri Ardiansyah",
                ),
                _buildTextField(
                  context,
                  label: "INSTANSI/UNIVERSITAS",
                  initialValue: "Universitas Indonesia",
                ),
                _buildTextField(context, label: "DIVISI", initialValue: "IT"),
                _buildTextField(
                  context,
                  label: "NOMOR WHATSAPP",
                  initialValue: "+62   81234567890",
                ),
                _buildTextField(
                  context,
                  label: "ALAMAT EMAIL",
                  initialValue: "fikri.ardiansyah@unj.ac.id",
                  enabled: false, // Email is disabled/greyed out in screenshot
                ),

                SizedBox(height: displayHeight(context) * 0.02),

                // Save Button
                ElevatedButton(
                  onPressed: () {
                    // Logic simpan
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFFE46B72,
                    ), // Soft red background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        displayWidth(context) * 0.06,
                      ), // Pill shape
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: displayHeight(context) * 0.02,
                    ),
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Simpan Perubahan",
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: displayWidth(context) * 0.02),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: displayWidth(context) * 0.05,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: displayHeight(context) * 0.03),

                // Footer Text
                Center(
                  child: Text(
                    "Perubahan akan divalidasi oleh sistem dalam 1x24 jam.",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: displayWidth(context) * 0.03,
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
