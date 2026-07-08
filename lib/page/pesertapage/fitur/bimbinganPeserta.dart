part of '../../../conn/auth.dart';

class BimbinganPeserta extends StatefulWidget {
  const BimbinganPeserta({super.key});

  @override
  State<BimbinganPeserta> createState() => _BimbinganPesertaState();
}

class _BimbinganPesertaState extends State<BimbinganPeserta> {
  int _selectedIndex = 0; // 0 for Aktif, 1 for Riwayat

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFAD3B3E)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Bimbingan',
          style: TextStyle(
            color: Color(0xFFAD3B3E),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Segmented Control
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedIndex == 0
                              ? const Color(0xFFAD3B3E)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Aktif',
                          style: TextStyle(
                            color: _selectedIndex == 0
                                ? Colors.white
                                : const Color(0xFF666666),
                            fontWeight: _selectedIndex == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedIndex == 1
                              ? const Color(0xFFAD3B3E)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Riwayat',
                          style: TextStyle(
                            color: _selectedIndex == 1
                                ? Colors.white
                                : const Color(0xFF666666),
                            fontWeight: _selectedIndex == 1
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // + Request Bimbingan Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEA5455),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                shadowColor: const Color(0xFFEA5455).withOpacity(0.4),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    '+ Request Bimbingan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section Title
            const Text(
              'Jadwal Aktif',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Card 1
            _buildScheduleCard(
              avatarUrl:
                  'https://i.pravatar.cc/150?img=32', // Rina Safitri placeholder
              name: 'Rina Safitri',
              role: 'Senior Product Designer',
              status: 'DISETUJUI',
              statusBgColor: const Color(0xFFFDE8D0),
              statusTextColor: const Color(0xFFB87834),
              icon: Icons.calendar_today_outlined,
              dateTime: '24 Okt 2023, 14:00 WIB',
            ),
            const SizedBox(height: 16),

            // Card 2
            _buildScheduleCard(
              avatarUrl:
                  'https://i.pravatar.cc/150?img=11', // Budi Darmawan placeholder
              name: 'Budi Darmawan',
              role: 'Lead Developer',
              status: 'MENUNGGU',
              statusBgColor: const Color(0xFFEBEBEB),
              statusTextColor: const Color(0xFF666666),
              icon: Icons.access_time,
              dateTime: '27 Okt 2023, 10:30 WIB',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard({
    required String avatarUrl,
    required String name,
    required String role,
    required String status,
    required Color statusBgColor,
    required Color statusTextColor,
    required IconData icon,
    required String dateTime,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(avatarUrl),
                backgroundColor: Colors.grey.shade200,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      role,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: statusTextColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: const Color(0xFFAD3B3E)),
                const SizedBox(width: 8),
                Text(
                  dateTime,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
