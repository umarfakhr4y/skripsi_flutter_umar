part of '../../../conn/auth.dart';

class EvaluasiPeserta extends StatefulWidget {
  const EvaluasiPeserta({super.key});

  @override
  State<EvaluasiPeserta> createState() => _EvaluasiPesertaState();
}

class _EvaluasiPesertaState extends State<EvaluasiPeserta> {
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
          'Evaluasi',
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
            // Total Feedback Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFAD3B3E),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TOTAL FEEDBACK',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '3',
                        style: TextStyle(
                          color: Color(0xFFAD3B3E),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Feedback Card 1 (With Reply)
            _buildFeedbackCard(
              avatarUrl: 'https://i.pravatar.cc/150?img=11', // Placeholder avatar
              name: 'Umar Fakhriy',
              role: 'Mentor Senior • UI/UX Design',
              date: '12 Jan 2024',
              topicIcon: Icons.integration_instructions,
              topicTitle: 'Integrasi API',
              feedbackText: 'Pekerjaan kamu pada modul Integrasi API sangat bagus. Struktur kodenya bersih dan penanganan error sudah diimplementasikan dengan baik. Saya sangat suka bagaimana kamu mendokumentasikan setiap endpoint.',
              hasReply: true,
              replyName: 'Alex Johnson (Intern)',
              replyDate: '13 Jan 2024',
              replyText: 'Terima kasih atas masukannya Kak Umar! Saya akan mencoba menerapkan dokumentasi yang sama untuk modul Pembayaran nanti.',
              actionType: 1, // 1 for "Balas", 2 for "Tulis Komentar", 3 for "Sudah Dibalas"
            ),
            const SizedBox(height: 16),
            
            // Feedback Card 2 (No Reply, Needs Action)
            _buildFeedbackCard(
              avatarUrl: 'https://i.pravatar.cc/150?img=5',
              name: 'Umar Fakhriy',
              role: 'Mentor Senior • UI/UX Design',
              date: '10 Jan 2024',
              topicIcon: Icons.palette,
              topicTitle: 'Desain UI',
              feedbackText: 'Untuk desain dashboard, perhatikan kontras pada teks label. Beberapa bagian terasa agak sulit dibaca pada layar kecil. Sisanya, penggunaan whitespace sudah sangat baik.',
              hasReply: false,
              actionType: 2,
            ),
            const SizedBox(height: 16),
            
            // Feedback Card 3 (No Reply, Done)
            _buildFeedbackCard(
              avatarUrl: 'https://i.pravatar.cc/150?img=1',
              name: 'Umar Fakhriy',
              role: 'Mentor Senior',
              date: '05 Jan 2024',
              topicIcon: Icons.group,
              topicTitle: 'Kerja Sama Tim',
              feedbackText: 'Komunikasi kamu selama daily stand-up sangat efektif. Terus pertahankan inisiatif untuk membantu rekan tim yang kesulitan.',
              hasReply: false,
              actionType: 3,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackCard({
    required String avatarUrl,
    required String name,
    required String role,
    required String date,
    required IconData topicIcon,
    required String topicTitle,
    required String feedbackText,
    required bool hasReply,
    String? replyName,
    String? replyDate,
    String? replyText,
    required int actionType,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              CircleAvatar(
                radius: 20,
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
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  date,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Topic
          Row(
            children: [
              Icon(topicIcon, size: 14, color: const Color(0xFFAD3B3E)),
              const SizedBox(width: 6),
              Text(
                topicTitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFAD3B3E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          
          // Feedback Text
          Text(
            feedbackText,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF666666),
              height: 1.5,
            ),
          ),
          
          if (hasReply) ...[
            const SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                children: [
                  Container(
                    width: 2,
                    color: const Color(0xFFE87A7D),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: const Color(0xFFE87A7D),
                                child: const Icon(
                                  Icons.person,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  replyName ?? '',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF8B2B2D),
                                  ),
                                ),
                              ),
                              Text(
                                replyDate ?? '',
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: Color(0xFF888888),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            replyText ?? '',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF666666),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 20),
          
          // Actions
          if (actionType == 1) // Balas (Solid Red)
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFAD3B3E),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.reply, size: 16, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            'Balas',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.more_horiz,
                      size: 20,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ],
            )
          else if (actionType == 2) // Tulis Komentar (Outline Red)
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE87A7D)),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 16, color: Color(0xFFAD3B3E)),
                          SizedBox(width: 6),
                          Text(
                            'Tulis Komentar',
                            style: TextStyle(
                              color: Color(0xFFAD3B3E),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.bookmark_border,
                      size: 20,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ],
            )
          else if (actionType == 3) // Sudah Dibalas (Grey Solid)
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.done_all, size: 16, color: Color(0xFF888888)),
                    SizedBox(width: 6),
                    Text(
                      'Sudah Dibalas',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
