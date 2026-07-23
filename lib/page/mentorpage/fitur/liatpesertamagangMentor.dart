part of '../../../conn/auth.dart';

class LiatPesertaMagangMentor extends StatefulWidget {
  const LiatPesertaMagangMentor({super.key});

  @override
  State<LiatPesertaMagangMentor> createState() =>
      _LiatPesertaMagangMentorState();
}

class _LiatPesertaMagangMentorState extends State<LiatPesertaMagangMentor> {
  List<dynamic> _allPesertaList = [];
  List<dynamic> _filteredPesertaList = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPeserta();
    _searchController.addListener(_filterPeserta);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPeserta() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPesertaList = _allPesertaList.where((peserta) {
        String nama = (peserta['nama_lengkap'] ?? '').toLowerCase();
        return nama.contains(query);
      }).toList();
    });
  }

  Future<void> _fetchPeserta() async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'access_token');

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/mentor/peserta'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            _allPesertaList = data['data'];
            _filteredPesertaList = data['data'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildShimmerPesertaCard() {
    return Container(
      margin: EdgeInsets.only(bottom: displayHeight(context) * 0.015),
      padding: EdgeInsets.symmetric(
        horizontal: displayWidth(context) * 0.04,
        vertical: displayHeight(context) * 0.015,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(displayWidth(context) * 0.02),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              width: displayWidth(context) * 0.1,
              height: displayWidth(context) * 0.1,
            ),
            SizedBox(width: displayWidth(context) * 0.04),
            Expanded(
              child: Container(
                height: displayWidth(context) * 0.035,
                color: Colors.white,
              ),
            ),
            SizedBox(width: displayWidth(context) * 0.1),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: displayWidth(context) * 0.04,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPesertaCard(dynamic peserta) {
    String name = peserta['nama_lengkap'] ?? 'Unknown';
    return GestureDetector(
      onTap: () {
        print(peserta['id']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailPesertaMagangMentor(pesertaId: peserta['id']),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: displayHeight(context) * 0.015),
        padding: EdgeInsets.symmetric(
          horizontal: displayWidth(context) * 0.04,
          vertical: displayHeight(context) * 0.015,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(displayWidth(context) * 0.02),
              decoration: const BoxDecoration(
                color: Color(
                  0xFFEA6E7D, // Sedikit lebih soft dari merah utama untuk mengikuti desain UI
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: displayWidth(context) * 0.06,
              ),
            ),
            SizedBox(width: displayWidth(context) * 0.04),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.035,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black87,
              size: displayWidth(context) * 0.04,
            ),
          ],
        ),
      ),
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
          "Peserta Magang",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: displayWidth(context) * 0.05,
          ),
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: displayWidth(context) * 0.06,
          ),
          child: Column(
            children: [
              SizedBox(height: displayHeight(context) * 0.01),
              // Search Bar
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: displayWidth(context) * 0.02,
                  vertical: displayHeight(context) * 0.005,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    displayWidth(context) * 0.08,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(displayWidth(context) * 0.015),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEA6E7D),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: displayWidth(context) * 0.04,
                      ),
                    ),
                    SizedBox(width: displayWidth(context) * 0.03),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Cari Nama Peserta",
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: displayWidth(context) * 0.035,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.03),

              // List of Peserta
              Expanded(
                child: _isLoading
                    ? ListView.builder(
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return _buildShimmerPesertaCard();
                        },
                      )
                    : _filteredPesertaList.isEmpty
                    ? const Center(
                        child: Text(
                          "Tidak ada data peserta magang",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredPesertaList.length,
                        itemBuilder: (context, index) {
                          return _buildPesertaCard(_filteredPesertaList[index]);
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
