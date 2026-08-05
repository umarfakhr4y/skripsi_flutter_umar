part of '../../conn/auth.dart';

class MentorNotif extends StatefulWidget {
  const MentorNotif({super.key});

  @override
  State<MentorNotif> createState() => _MentorNotifState();
}

class _MentorNotifState extends State<MentorNotif> {
  List<dynamic> _notifikasiList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifikasi();
  }

  Future<void> _fetchNotifikasi() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access_token');

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('http://10.0.2.2:8000/api/notifikasi'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (mounted) {
            setState(() {
              if (data['success'] == true) {
                _notifikasiList = data['data'] ?? [];
              }
              _isLoading = false;
            });
          }
        } else {
          if (mounted) setState(() => _isLoading = false);
        }
      } catch (e) {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatTime(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      DateTime date = DateTime.parse(dateString).toLocal();
      Duration diff = DateTime.now().difference(date);

      if (diff.inMinutes < 1) return 'Baru saja';
      if (diff.inHours < 1) return '${diff.inMinutes} menit lalu';
      if (diff.inDays < 1) return '${diff.inHours} jam lalu';
      if (diff.inDays < 7) return '${diff.inDays} hari lalu';
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return '';
    }
  }

  Widget _buildNotifCard(Map<String, dynamic> notif) {
    String category = notif['judul'] ?? 'Notifikasi';
    String time = _formatTime(notif['created_at'] ?? '');
    String description = notif['pesan'] ?? '';
    bool isRead = notif['is_read'] ?? true;
    int notifId = notif['id'] ?? 0;
    String tipe = notif['tipe'] ?? '';

    return GestureDetector(
      onTap: () async {
        if (!isRead) {
          try {
            const storage = FlutterSecureStorage();
            String? token = await storage.read(key: 'access_token');
            if (token != null) {
              await http.put(
                Uri.parse('http://10.0.2.2:8000/api/notifikasi/$notifId/read'),
                headers: {
                  'Authorization': 'Bearer $token',
                  'Accept': 'application/json',
                },
              );
              setState(() {
                notif['is_read'] = true;
              });
            }
          } catch (e) {
            // ignore error
          }
        }

        if (tipe == 'absensi_harian') {
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AbsensiPesertaMentor(),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
        padding: EdgeInsets.all(displayWidth(context) * 0.04),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : const Color(0xFFFDE8EB),
          borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
          border: isRead
              ? null
              : Border.all(color: const Color(0xFFE84C63).withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications_active,
                  color: const Color(0xFFE84C63), // Red color
                  size: displayWidth(context) * 0.045,
                ),
                SizedBox(width: displayWidth(context) * 0.02),
                Expanded(
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.035,
                      fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: displayWidth(context) * 0.02),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.03,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            SizedBox(height: displayHeight(context) * 0.015),
            Text(
              description,
              style: TextStyle(
                fontSize: displayWidth(context) * 0.035,
                color: isRead ? Colors.black87 : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
          padding: EdgeInsets.all(displayWidth(context) * 0.04),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: displayWidth(context) * 0.045,
                      height: displayWidth(context) * 0.045,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: displayWidth(context) * 0.02),
                    Expanded(
                      child: Container(
                        height: displayWidth(context) * 0.035,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: displayWidth(context) * 0.1),
                    Container(
                      width: displayWidth(context) * 0.15,
                      height: displayWidth(context) * 0.03,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: displayHeight(context) * 0.015),
                Container(
                  width: double.infinity,
                  height: displayWidth(context) * 0.035,
                  color: Colors.white,
                ),
                SizedBox(height: displayHeight(context) * 0.005),
                Container(
                  width: displayWidth(context) * 0.5,
                  height: displayWidth(context) * 0.035,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Aktifitas Terbaru",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: displayWidth(context) * 0.05,
          ),
        ),
        titleSpacing: 0, // Removes extra spacing to align closer to back button
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: displayWidth(context) * 0.06,
          ),
          child: Column(
            children: [
              SizedBox(height: displayHeight(context) * 0.02),
              Expanded(
                child: _isLoading
                    ? _buildShimmerList()
                    : _notifikasiList.isEmpty
                    ? Center(
                        child: Text(
                          "Belum ada aktifitas terbaru",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _notifikasiList.length,
                        itemBuilder: (context, index) {
                          return _buildNotifCard(_notifikasiList[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
