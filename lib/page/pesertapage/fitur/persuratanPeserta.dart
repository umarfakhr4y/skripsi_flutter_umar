part of '../../../conn/auth.dart';

class PersuratanPeserta extends StatefulWidget {
  const PersuratanPeserta({super.key});

  @override
  State<PersuratanPeserta> createState() => _PersuratanPesertaState();
}

class _PersuratanPesertaState extends State<PersuratanPeserta> {
  int _selectedTab = 0; // 0: Aktif, 1: Riwayat

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
          'Persuratan dan Perizinan',
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
            // Top Buttons
            Row(
              children: [
                Expanded(
                  child: _buildTopButton(
                    title: '+ Request\nSurat',
                    icon: Icons.description,
                    isPrimary: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTopButton(
                    title: '+ Izin\nKehadiran',
                    icon: Icons.calendar_today_outlined,
                    isPrimary: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Custom Tabs
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTab = 0;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedTab == 0
                                ? const Color(0xFFAD3B3E)
                                : Colors.grey.shade300,
                            width: _selectedTab == 0 ? 2 : 1,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Aktif',
                        style: TextStyle(
                          color: _selectedTab == 0
                              ? const Color(0xFFAD3B3E)
                              : const Color(0xFF666666),
                          fontWeight: _selectedTab == 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTab = 1;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedTab == 1
                                ? const Color(0xFFAD3B3E)
                                : Colors.grey.shade300,
                            width: _selectedTab == 1 ? 2 : 1,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Riwayat',
                        style: TextStyle(
                          color: _selectedTab == 1
                              ? const Color(0xFFAD3B3E)
                              : const Color(0xFF666666),
                          fontWeight: _selectedTab == 1
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Card 1: Sedang Diproses
            _buildRequestCard(
              borderColor: const Color(0xFFD49C31),
              title: 'Surat Nilai Kampus',
              statusText: 'Sedang Diproses',
              statusIcon: Icons.remove_circle_outline,
              statusColor: const Color(0xFF9E6D1A),
              statusBgColor: const Color(0xFFFCEBCC),
              description:
                  'Permohonan legalisir nilai untuk keperluan administrasi akademik semester genap.',
              dateText: 'Estimasi Selesai: 24 Oct 2023',
            ),
            const SizedBox(height: 16),

            // Card 2: Disetujui
            _buildRequestCard(
              borderColor: const Color(0xFF9E2C2C),
              title: 'Izin Cuti (Sakit)',
              statusText: 'Disetujui',
              statusIcon: Icons.check_circle,
              statusColor: const Color(0xFF9E2C2C),
              statusBgColor: const Color(0xFFF7D8D8),
              description:
                  'Izin sakit selama 2 hari (18-19 Oct) dikarenakan demam tinggi. Surat dokter terlampir.',
              hasDownloadButton: true,
            ),
            const SizedBox(height: 16),

            // Card 3: Ditolak
            _buildRequestCard(
              borderColor: const Color(0xFFC7282A),
              title: 'Peminjaman Laptop',
              statusText: 'Ditolak',
              statusIcon: Icons.cancel,
              statusColor: const Color(0xFFC7282A),
              statusBgColor: const Color(0xFFF7D8D8),
              description:
                  'Permohonan peminjaman MacBook Pro untuk project pengembangan UI/UX.',
              rejectionReason:
                  '"Stok perangkat saat ini sedang penuh digunakan oleh tim pengembang inti. Silakan gunakan perangkat pribadi atau hubungi IT untuk opsi pengganti."',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTopButton({
    required String title,
    required IconData icon,
    required bool isPrimary,
  }) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFFE96C72) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isPrimary
            ? null
            : Border.all(color: const Color(0xFFE96C72), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isPrimary
                      ? const Color(0xFFD3555D)
                      : const Color(0xFFFCEDEE),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isPrimary ? Colors.white : const Color(0xFFE96C72),
                  size: 20,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isPrimary ? Colors.white : const Color(0xFFAD3B3E),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard({
    required Color borderColor,
    required String title,
    required String statusText,
    required IconData statusIcon,
    required Color statusColor,
    required Color statusBgColor,
    required String description,
    String? dateText,
    bool hasDownloadButton = false,
    String? rejectionReason,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Colored left border
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ),
            // Card Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(statusIcon, size: 12, color: statusColor),
                              const SizedBox(width: 4),
                              Text(
                                statusText,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                    if (dateText != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            dateText,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (hasDownloadButton) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF6F6),
                          border: Border.all(
                            color: const Color(0xFFE96C72).withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.download_outlined,
                              size: 16,
                              color: Color(0xFFAD3B3E),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Download Dokumen',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFAD3B3E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (rejectionReason != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF6F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ALASAN PENOLAKAN',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFC7282A),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              rejectionReason,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                                fontStyle: FontStyle.italic,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
