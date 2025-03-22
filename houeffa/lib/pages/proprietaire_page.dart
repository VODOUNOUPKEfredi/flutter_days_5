import 'package:flutter/material.dart';

class ProprietaireHomePage extends StatefulWidget {
  const ProprietaireHomePage({super.key});

  @override
  State<ProprietaireHomePage> createState() => _ProprietaireHomePageState();
}

class _ProprietaireHomePageState extends State<ProprietaireHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Propriétaire"),
    );
  }
}