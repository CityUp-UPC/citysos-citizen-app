import 'package:flutter/material.dart';
import 'package:citysos_citizen/views/home_view.dart';
import 'package:citysos_citizen/views/feeds_view.dart';
import 'package:citysos_citizen/views/news_view.dart';
import 'package:citysos_citizen/views/user_view.dart';


class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  static final GlobalKey<_NavbarState> navigatorKey = GlobalKey<_NavbarState>();

  @override
  _NavbarState createState() => _NavbarState();

  static _NavbarState? of(BuildContext context) {
    return context.findAncestorStateOfType<_NavbarState>();
  }
}

class _NavbarState extends State<Navbar> {
  int selectedIndex = 0;

  void setIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final views = [
      const Home(),
      const Feeds(),
      const News(),
      const User(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: views,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        selectedItemColor: colors.primary,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(color: colors.primary),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.crisis_alert_outlined),
            activeIcon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary.withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.crisis_alert_rounded, color: colors.primary),
              ),
            ),
            label: 'SOS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback_outlined),
            activeIcon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary.withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.feedback_rounded, color: colors.primary),
              ),
            ),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_outlined),
            activeIcon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary.withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.newspaper_rounded, color: colors.primary),
              ),
            ),
            label: 'Noticias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary.withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.person_rounded, color: colors.primary),
              ),
            ),
            label: 'Usuario',
          ),
        ],
        backgroundColor: colors.background,
      ),
    );
  }
}