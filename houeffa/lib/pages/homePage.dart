import 'package:flutter/material.dart';

class LocataireHomePage extends StatefulWidget {
  const LocataireHomePage({super.key});

  @override
  State<LocataireHomePage> createState() => _LocataireHomePageState();
}

class _LocataireHomePageState extends State<LocataireHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Locataire"),
    );
  }
}