part of '../../conn/auth.dart';

class AdminManajemen extends StatefulWidget {
  const AdminManajemen({Key? key}) : super(key: key);

  @override
  State<AdminManajemen> createState() => _AdminManajemenState();
}

class _AdminManajemenState extends State<AdminManajemen> {
  String _selectedTab = 'Peserta Magang';
  bool _isLoading = true;
  List<dynamic> _pesertaList = [];
  List<dynamic> _mentorList = [];
  List<dynamic> _divisiList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final pRes = await AdminService.getPeserta();
    final mRes = await AdminService.getMentor();
    final dRes = await AdminService.getDivisi();

    if (mounted) {
      setState(() {
        if (pRes['success']) _pesertaList = pRes['data'] ?? [];
        if (mRes['success']) _mentorList = mRes['data'] ?? [];
        if (dRes['success']) _divisiList = dRes['data'] ?? [];
        _isLoading = false;
      });
    }
  }

  void _showAddDivisiDialog() {
    final TextEditingController namaController = TextEditingController();
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  displayWidth(context) * 0.05,
                ),
              ),
              title: const Text(
                'Tambah Divisi Baru',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      labelText: 'Nama Divisi',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          displayWidth(context) * 0.02,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (namaController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Nama divisi tidak boleh kosong'),
                              ),
                            );
                            return;
                          }

                          setStateDialog(() => isSubmitting = true);

                          final res = await AdminService.tambahDivisi(
                            namaController.text,
                          );

                          setStateDialog(() => isSubmitting = false);

                          if (res['success']) {
                            Navigator.pop(context);
                            setState(() => _isLoading = true);
                            _fetchData();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  res['message'] ?? 'Berhasil menambah divisi',
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  res['message'] ?? 'Gagal menambah divisi',
                                ),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE84C63),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        displayWidth(context) * 0.02,
                      ),
                    ),
                  ),
                  child: isSubmitting
                      ? SizedBox(
                          width: displayWidth(context) * 0.04,
                          height: displayWidth(context) * 0.04,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Simpan',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditDivisiDialog(dynamic item) {
    final TextEditingController namaController = TextEditingController(
      text: item['nama_divisi'] ?? '',
    );
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  displayWidth(context) * 0.05,
                ),
              ),
              title: const Text(
                'Edit Divisi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      labelText: 'Nama Divisi',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          displayWidth(context) * 0.02,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (namaController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Nama divisi tidak boleh kosong'),
                              ),
                            );
                            return;
                          }

                          setStateDialog(() => isSubmitting = true);

                          final res = await AdminService.editDivisi(
                            item['id'],
                            namaController.text,
                          );

                          setStateDialog(() => isSubmitting = false);

                          if (!mounted) return;

                          if (res['success']) {
                            Navigator.pop(dialogContext);
                            setState(() => _isLoading = true);
                            _fetchData();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  res['message'] ?? 'Berhasil mengubah divisi',
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  res['message'] ?? 'Gagal mengubah divisi',
                                ),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE84C63),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        displayWidth(context) * 0.02,
                      ),
                    ),
                  ),
                  child: isSubmitting
                      ? SizedBox(
                          width: displayWidth(context) * 0.04,
                          height: displayWidth(context) * 0.04,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Simpan',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _hapusDivisi(dynamic item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(displayWidth(context) * 0.05),
        ),
        title: const Text('Konfirmasi Hapus'),
        content: Text('Yakin ingin menghapus divisi ${item['nama_divisi']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext); // Tutup dialog konfirmasi
              setState(() => _isLoading = true);
              final res = await AdminService.hapusDivisi(item['id']);

              if (!mounted) return;

              if (res['success']) {
                _fetchData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      res['message'] ?? 'Berhasil menghapus divisi',
                    ),
                  ),
                );
              } else {
                setState(() => _isLoading = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(res['message'] ?? 'Gagal menghapus divisi'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // Show 5 dummy shimmer cards
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
          padding: EdgeInsets.all(displayWidth(context) * 0.04),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Avatar Shimmer
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: CircleAvatar(
                  radius: displayWidth(context) * 0.06,
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(width: displayWidth(context) * 0.04),
              // Text Content Shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: displayWidth(context) * 0.04,
                        width: displayWidth(context) * 0.4,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.01),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: displayWidth(context) * 0.03,
                        width: displayWidth(context) * 0.25,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Badge & More Icon Shimmer
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: displayHeight(context) * 0.02,
                      width: displayWidth(context) * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(displayWidth(context) * 0.02),
                      ),
                    ),
                  ),
                  SizedBox(height: displayHeight(context) * 0.015),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: displayWidth(context) * 0.05,
                      width: displayWidth(context) * 0.05,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatarWidget(String? name, Color bgColor) {
    String initial = 'U';
    if (name != null && name.isNotEmpty) {
      initial = name[0].toUpperCase();
    }
    return CircleAvatar(
      radius: displayWidth(context) * 0.06,
      backgroundColor: bgColor,
      child: Text(
        initial,
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: displayWidth(context) * 0.04,
        ),
      ),
    );
  }

  Widget _buildList() {
    if (_selectedTab == 'Peserta Magang') {
      if (_pesertaList.isEmpty) return const Text('Tidak ada data peserta');
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _pesertaList.length,
        itemBuilder: (context, index) {
          final item = _pesertaList[index];
          return _buildUserCard(
            name: item['nama_lengkap'] ?? 'Tanpa Nama',
            roleDesc: '${item['universitas'] ?? '-'} • ${item['prodi'] ?? '-'}',
            badgeText: 'PESERTA',
            badgeColor: const Color(0xFFB04A50),
            badgeBgColor: const Color(0xFFE46B72),
            avatarWidget: _buildAvatarWidget(
              item['nama_lengkap'],
              const Color(0xFFE46B72),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPesertaMagangMentor(
                    pesertaId: item['id'] ?? 0,
                    isAdmin: true,
                  ),
                ),
              );
            },
          );
        },
      );
    } else if (_selectedTab == 'Mentor') {
      if (_mentorList.isEmpty) return const Text('Tidak ada data mentor');
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _mentorList.length,
        itemBuilder: (context, index) {
          final item = _mentorList[index];
          final divisiName = item['divisi'] != null
              ? item['divisi']['nama_divisi']
              : '-';
          return _buildUserCard(
            name: item['nama_lengkap'] ?? 'Tanpa Nama',
            roleDesc: 'Mentor • $divisiName',
            badgeText: 'MENTOR',
            badgeColor: const Color(0xFFC78D32),
            badgeBgColor: const Color(0xFFFDE68A),
            avatarWidget: _buildAvatarWidget(
              item['nama_lengkap'],
              const Color(0xFFFDE68A),
            ),
          );
        },
      );
    } else if (_selectedTab == 'Divisi') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: _showAddDivisiDialog,
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: displayWidth(context) * 0.05,
            ),
            label: Text(
              'Tambah Divisi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: displayWidth(context) * 0.035,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE84C63),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  displayWidth(context) * 0.03,
                ),
              ),
              padding: EdgeInsets.symmetric(
                vertical: displayHeight(context) * 0.015,
              ),
              elevation: 0,
            ),
          ),
          SizedBox(height: displayHeight(context) * 0.02),
          if (_divisiList.isEmpty)
            const Center(child: Text('Tidak ada data divisi'))
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _divisiList.length,
              itemBuilder: (context, index) {
                final item = _divisiList[index];
                return _buildUserCard(
                  name: item['nama_divisi'] ?? 'Tanpa Nama',
                  roleDesc: item['deskripsi'] ?? '',
                  badgeText: 'DIVISI',
                  badgeColor: Colors.white,
                  badgeBgColor: Colors.black87,
                  avatarWidget: CircleAvatar(
                    radius: displayWidth(context) * 0.06,
                    backgroundColor: Colors.grey[200],
                    child: Icon(Icons.business, color: Colors.grey[600]),
                  ),
                  onEdit: () => _showEditDivisiDialog(item),
                  onDelete: () => _hapusDivisi(item),
                );
              },
            ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchData,
          color: const Color(0xFFE84C63),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(displayWidth(context) * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom AppBar (Logo & Avatar)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "v",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.08,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            letterSpacing: -1.0,
                          ),
                        ),
                        TextSpan(
                          text: "o",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.08,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFFE84C63), // Red
                            letterSpacing: -1.0,
                          ),
                        ),
                        TextSpan(
                          text: "casia",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.08,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            letterSpacing: -1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: displayHeight(context) * 0.03),

              // Title and Subtitle
              Text(
                'Manajemen',
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.065,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.01),
              Text(
                'Kelola Peserta Magang, Mentor dan Divisi.',
                style: TextStyle(
                  fontSize: displayWidth(context) * 0.035,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              SizedBox(height: displayHeight(context) * 0.03),

              // Tabs
              Row(
                children: [
                  _buildTab('Peserta Magang'),
                  SizedBox(width: displayWidth(context) * 0.02),
                  _buildTab('Mentor'),
                  SizedBox(width: displayWidth(context) * 0.02),
                  _buildTab('Divisi'),
                ],
              ),
              SizedBox(height: displayHeight(context) * 0.03),

              // Search and Filter
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(
                          displayWidth(context) * 0.03,
                        ),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari ...',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: displayWidth(context) * 0.035,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[600],
                            size: displayWidth(context) * 0.05,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: displayHeight(context) * 0.015,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: displayWidth(context) * 0.03),
                  Container(
                    padding: EdgeInsets.all(displayWidth(context) * 0.03),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(
                        displayWidth(context) * 0.03,
                      ),
                    ),
                    child: Icon(
                      Icons.filter_list,
                      color: Colors.black87,
                      size: displayWidth(context) * 0.05,
                    ),
                  ),
                ],
              ),
              SizedBox(height: displayHeight(context) * 0.03),

              // User List
              _isLoading
                  ? _buildShimmerList()
                  : _buildList(),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildTab(String text) {
    bool isSelected = _selectedTab == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = text;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: displayWidth(context) * 0.04,
          vertical: displayHeight(context) * 0.01,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB04A50) : Colors.grey[100],
          borderRadius: BorderRadius.circular(displayWidth(context) * 0.05),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: displayWidth(context) * 0.035,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard({
    required String name,
    required String roleDesc,
    required String badgeText,
    required Color badgeColor,
    required Color badgeBgColor,
    required Widget avatarWidget,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    VoidCallback? onTap,
  }) {
    bool isMentor = badgeText == 'MENTOR';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
        padding: EdgeInsets.all(displayWidth(context) * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(displayWidth(context) * 0.04),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            avatarWidget,
            SizedBox(width: displayWidth(context) * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: displayHeight(context) * 0.005),
                  Text(
                    roleDesc,
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.03,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: displayWidth(context) * 0.02,
                    vertical: displayHeight(context) * 0.005,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBgColor,
                    borderRadius: BorderRadius.circular(
                      displayWidth(context) * 0.02,
                    ),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.025,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
                  ),
                ),
                if (onEdit != null || onDelete != null) ...[
                  SizedBox(height: displayHeight(context) * 0.01),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black87,
                      size: displayWidth(context) * 0.05,
                    ),
                    onSelected: (value) {
                      if (value == 'edit' && onEdit != null) onEdit();
                      if (value == 'delete' && onDelete != null) onDelete();
                    },
                    itemBuilder: (context) => [
                      if (onEdit != null)
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                      if (onDelete != null)
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Hapus', style: TextStyle(color: Colors.red)),
                        ),
                    ],
                  )
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
