part of '../../conn/auth.dart';

class MentorMain extends StatefulWidget {
  const MentorMain({Key? key}) : super(key: key);

  @override
  State<MentorMain> createState() => _MentorMainState();
}

class _MentorMainState extends State<MentorMain> {
  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 0,
  );

  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// widget list
    final List<Widget> bottomBarPages = [
      Page1(controller: (_controller)),
      const Page2(),
    ];
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
          bottomBarPages.length,
          (index) => bottomBarPages[index],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              /// Provide NotchBottomBarController
              notchBottomBarController: _controller,
              color: Color(0xFFE84C63),
              showLabel: true,
              textOverflow: TextOverflow.visible,
              maxLine: 1,
              shadowElevation: 5,
              kBottomRadius: 28.0,

              // notchShader: const SweepGradient(
              //   startAngle: 0,
              //   endAngle: pi / 2,
              //   colors: [Colors.red, Colors.green, Colors.orange],
              //   tileMode: TileMode.mirror,
              // ).createShader(Rect.fromCircle(center: Offset.zero, radius: 8.0)),
              notchColor: Color(0xFFE84C63),

              /// restart app if you change removeMargins
              removeMargins: false,
              bottomBarWidth: 500,
              showShadow: false,
              durationInMilliSeconds: 300,

              itemLabelStyle: const TextStyle(fontSize: 10),

              elevation: 1,
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(Icons.home_filled, color: Colors.white),
                  activeItem: Icon(Icons.home_filled, color: Colors.white),
                ),
                BottomBarItem(
                  inActiveItem: Icon(Icons.person, color: Colors.white),
                  activeItem: Icon(Icons.person, color: Colors.white),
                ),
              ],
              onTap: (index) {
                print('current selected index $index');
                _pageController.jumpToPage(index);
              },
              kIconSize: 24.0,
            )
          : null,
    );
  }
}

/// add controller to check weather index through change or not. in page 1
class Page1 extends StatelessWidget {
  final NotchBottomBarController? controller;
  const Page1({Key? key, this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MentorHome();
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MentorProfile();
  }
}
