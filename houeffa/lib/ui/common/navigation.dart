import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:houeffa/ui/screens/home_page.dart';
import 'package:houeffa/ui/screens/profil.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});
  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: FloatingNavbar(
        margin: EdgeInsets.only(bottom: 10),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
              FloatingNavbarItem(icon: Icons.home, title: 'Home'),
              FloatingNavbarItem(icon: Icons.explore, title: 'Explore'),
              FloatingNavbarItem(icon: Icons.chat_bubble_outline, title: 'Chats'),
              FloatingNavbarItem(icon: Icons.favorite_border, title: 'Chats'),
              FloatingNavbarItem(icon: Icons.settings, title: 'Settings'),
            ],
      ),
    );
  }
}
