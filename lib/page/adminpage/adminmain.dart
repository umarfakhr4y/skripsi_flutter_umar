part of '../../conn/auth.dart';

class AdminMain extends StatefulWidget {
  const AdminMain({Key? key}) : super(key: key);

  @override
  State<AdminMain> createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AdminHome(),
    const AdminManajemen(),
    const AdminValidasi(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFE84C63),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart), // Dashboard icon
            label: 'Dasbor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people), // Management icon
            label: 'Manajemen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add_check), // Validation icon
            label: 'Validasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings), // Account icon
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}
