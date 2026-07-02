part of '../../../conn/auth.dart';

class ManajemenTugasMentor extends StatefulWidget {
  const ManajemenTugasMentor({super.key});

  @override
  State<ManajemenTugasMentor> createState() => _ManajemenTugasMentorState();
}

class _ManajemenTugasMentorState extends State<ManajemenTugasMentor> {
  String selectedStatus = 'Tugas Aktif';
  final List<String> statusList = [
    'Tugas Aktif',
    'Perlu Ditinjau',
    'Tugas Selesai',
  ];

  final List<Map<String, dynamic>> dummyTasks = [
    {
      "judul": "Pembuatan logo untuk acara",
      "nama": "Umar Fakhriy",
      "deskripsi": "Pembuatan logo untuk acara",
      "isExpanded": true,
    },
    {
      "judul": "Pembuatan logo untuk acara",
      "nama": "Umar Fakhriy",
      "deskripsi": "Pembuatan logo untuk acara",
      "isExpanded": false,
    },
    {
      "judul": "Pembuatan logo untuk acara",
      "nama": "Umar Fakhriy",
      "deskripsi": "Pembuatan logo untuk acara",
      "isExpanded": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text(
          'Manajemen Tugas',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: displayWidth(context) * 0.05,
          ),
        ),
        backgroundColor: const Color(0xFFEEEEEE),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(displayWidth(context) * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stat Cards
              Row(
                children: [
                  Expanded(child: _buildStatCard('8', 'Tugas\nAktif')),
                  SizedBox(width: displayWidth(context) * 0.03),
                  Expanded(child: _buildStatCard('3', 'Perlu\nDitinjau')),
                  SizedBox(width: displayWidth(context) * 0.03),
                  Expanded(child: _buildStatCard('10', 'Tugas\nSelesai')),
                ],
              ),
              SizedBox(height: displayHeight(context) * 0.03),
              // Dropdown Section
              Text(
                'Pilih Status Tugas',
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.035,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.015),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: displayWidth(context) * 0.04,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.03,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedStatus,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                      size: displayWidth(context) * 0.06,
                    ),
                    items: statusList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.035,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue != null) selectedStatus = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.03),
              // Task List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dummyTasks.length,
                itemBuilder: (context, index) {
                  return _buildTaskCard(index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String number, String label) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: displayHeight(context) * 0.02),
      decoration: BoxDecoration(
        color: const Color(0xFFE84C63),
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.03),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: displayWidth(context) * 0.06,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: displayHeight(context) * 0.005),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: displayWidth(context) * 0.03,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(int index) {
    final task = dummyTasks[index];
    final isExpanded = task['isExpanded'] as bool;

    return Container(
      margin: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              setState(() {
                task['isExpanded'] = !isExpanded;
              });
            },
            contentPadding: EdgeInsets.symmetric(
              horizontal: displayWidth(context) * 0.04,
              vertical: displayHeight(context) * 0.005,
            ),
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFE84C63),
              radius: displayWidth(context) * 0.055,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: displayWidth(context) * 0.07,
              ),
            ),
            title: Text(
              task['judul'],
              style: TextStyle(
                fontSize: displayWidth(context) * 0.035,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              task['nama'],
              style: TextStyle(
                fontSize: displayWidth(context) * 0.03,
                color: Colors.grey[600],
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: Colors.black,
              size: displayWidth(context) * 0.06,
            ),
          ),
          if (isExpanded)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                Container(
                  width: double.infinity,
                  color: const Color(0xFFF9F9F9),
                  padding: EdgeInsets.symmetric(
                    horizontal: displayWidth(context) * 0.06,
                    vertical: displayHeight(context) * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Judul',
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.03,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: displayWidth(context) * 0.04,
                          top: displayHeight(context) * 0.005,
                          bottom: displayHeight(context) * 0.015,
                        ),
                        child: Text(
                          task['judul'],
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.032,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.03,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: displayWidth(context) * 0.04,
                          top: displayHeight(context) * 0.005,
                        ),
                        child: Text(
                          task['deskripsi'],
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.032,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE84C63),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(displayWidth(context) * 0.04),
                      bottomRight: Radius.circular(
                        displayWidth(context) * 0.04,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DetailTugasMentor(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: displayHeight(context) * 0.015,
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.more_horiz,
                                  color: Colors.white,
                                  size: displayWidth(context) * 0.06,
                                ),
                                SizedBox(
                                  height: displayHeight(context) * 0.005,
                                ),
                                Text(
                                  'Lihat Detail',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: displayWidth(context) * 0.025,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: displayHeight(context) * 0.015,
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: displayWidth(context) * 0.05,
                                ),
                                SizedBox(
                                  height: displayHeight(context) * 0.005,
                                ),
                                Text(
                                  'Hapus',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: displayWidth(context) * 0.025,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
