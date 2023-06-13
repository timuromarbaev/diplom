import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:language_detection_diplom/pages/home_page.dart';
import 'package:language_detection_diplom/pages/profile_page.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  @override
  List<ScreenHiddenDrawer> _pages = [];

  final myTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();

    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Homepage',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: const Color.fromARGB(255, 58, 112, 206),
        ),
        const HomePage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Favorites',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: const Color.fromARGB(255, 58, 112, 206),
        ),
        ProfilePage(),
      ),
    ];
  }

  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: const Color.fromARGB(221, 50, 50, 50),
      screens: _pages,
      initPositionSelected: 0,
      slidePercent: 45,
    );
  }
}
