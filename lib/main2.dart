import 'dart:developer';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos_new/component/form/finance.dart';
import 'package:flutter_pos_new/component/form/report.dart';
import 'package:flutter_pos_new/component/mainmenu.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Animated Notch Bottom Bar',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }

class Main2 extends StatefulWidget {
  const Main2({Key? key}) : super(key: key);

  @override
  State<Main2> createState() => _Main2State();
}

class _Main2State extends State<Main2> {
  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 0);

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
      MainMenu(
        controller: (_controller),
      ),
    
      const Report1(),
      const Finance1()
    ];
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              /// Provide NotchBottomBarController
              notchBottomBarController: _controller,
              color: Colors.white,
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
              notchColor: Colors.blueAccent,

              /// restart app if you change removeMargins
              removeMargins: false,
              bottomBarWidth: 500,
              showShadow: false,
              durationInMilliSeconds: 300,

              itemLabelStyle: const TextStyle(fontSize: 10),

              elevation: 1,
              bottomBarItems: const [
                // BottomBarItem(
                //   inActiveItem: Icon(
                //     Icons.home_filled,
                //     color: Colors.blueGrey,
                //   ),
                //   activeItem: Icon(
                //     Icons.home_filled,
                //     color: Colors.blueAccent,
                //   ),
                //   itemLabel: 'Page 1',
                // ),
                BottomBarItem(
                  inActiveItem: Icon(Icons.home, color: Colors.blueGrey),
                  activeItem: Icon(
                    Icons.home,
                    color: Colors.yellow,
                  ),
                  itemLabel: 'Home',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.newspaper,
                    color: Colors.grey,
                  ),
                  activeItem: Icon(
                    Icons.newspaper,
                    color: Colors.yellow,
                  ),
                  itemLabel: 'Report',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.money,
                    color: Colors.grey,
                  ),
                  activeItem: Icon(
                    Icons.money,
                    color: Colors.yellow,
                  ),
                  itemLabel: 'Finance',
                ),
              ],
              onTap: (index) {
                log('current selected index $index');
                _pageController.jumpToPage(index);
              },
              kIconSize: 24.0,
            )
          : null,
    );
  }
}

/// add controller to check weather index through change or not. in page 1
// class Page1 extends StatelessWidget {
//   final NotchBottomBarController? controller;

//   const Page1({Key? key, this.controller}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.yellow,
//       child: Center(
//         /// adding GestureDetector
//         child: GestureDetector(
//           behavior: HitTestBehavior.translucent,
//           onTap: () {
//             controller?.jumpTo(2);
//           },
//           child: const Text('Page 1'),
//         ),
//       ),
//     );
//   }
// }

// class Page2 extends StatelessWidget {
//   const Page2({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         color: Colors.green, child: const Center(child: Text('Page 2')));
//   }
// }

// class Page3 extends StatelessWidget {
//   const Page3({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         color: Colors.red, child: const Center(child: Text('Page 3')));
//   }
// }

// class Page4 extends StatelessWidget {
//   const Page4({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         color: Colors.blue, child: const Center(child: Text('Page 4')));
//   }
// }

// class Page5 extends StatelessWidget {
//   const Page5({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         color: Colors.lightGreenAccent,
//         child: const Center(child: Text('Page 5')));
//   }
// }
