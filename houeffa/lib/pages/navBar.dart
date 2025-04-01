import 'package:flutter/material.dart';
import 'package:houeffa/pages/historique_payement.dart';
import 'package:houeffa/pages/message.dart';
import 'package:houeffa/pages/homePage.dart';
import 'package:houeffa/pages/profil_locataire.dart';
import 'package:houeffa/pages/validation_logement.dart';
import 'package:houeffa/ui/screens/profil.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;
  
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
       HomePage(), 
      const LogementValidationPage(),
       HistoriquePaiementsPage(), 
      const MessagesPage(),
      const ProfilLocatairePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
        margin: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.black,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}