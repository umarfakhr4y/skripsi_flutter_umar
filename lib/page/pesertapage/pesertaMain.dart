part of '../../conn/auth.dart';

class PesertaMain extends StatefulWidget {
  const PesertaMain({Key? key}) : super(key: key);

  @override
  State<PesertaMain> createState() => PesertaMainState();
}

class PesertaMainState extends State<PesertaMain> {
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
      PesertaPage1(controller: (_controller)),
      const PesertaPage2(),
      const PesertaPage3(),
    ];
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          _controller.jumpTo(index);
        },
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
                  inActiveItem: Icon(Icons.apps_sharp, color: Colors.white),
                  activeItem: Icon(Icons.apps_sharp, color: Colors.white),
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
class PesertaPage1 extends StatelessWidget {
  final NotchBottomBarController? controller;
  const PesertaPage1({Key? key, this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PesertaHome();
  }
}

class PesertaPage2 extends StatelessWidget {
  const PesertaPage2({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PesertaMenu();
  }
}

class PesertaPage3 extends StatelessWidget {
  const PesertaPage3({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ProfilePage();
  }
}
