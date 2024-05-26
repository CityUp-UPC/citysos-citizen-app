import 'package:citysos_citizen/views/home_view.dart';
import 'package:citysos_citizen/views/login_view.dart';
import 'package:citysos_citizen/views/notifications_view.dart';
import 'package:citysos_citizen/views/news_view.dart';
import 'package:citysos_citizen/views/register_view.dart';
import 'package:citysos_citizen/views/user_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final views = [
      const Home(),
      const Login(),
      const Register(),
      const User(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: views,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (_selectedIndex) {
          setState(() {
            selectedIndex = _selectedIndex;
          });
        },
        selectedItemColor: colors.primary,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(color: colors.primary),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary.withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.home_filled, color: colors.primary),
              ),
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            activeIcon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary.withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.newspaper, color: colors.primary),
              ),
            ),
            label: 'Noticias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            activeIcon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary.withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.notifications, color: colors.primary),
              ),
            ),
            label: 'Notificaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            activeIcon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary.withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.person, color: colors.primary),
              ),
            ),
            label: 'Perfil',
          ),
        ],
        backgroundColor: colors.background,
      ),
    );
  }
}
