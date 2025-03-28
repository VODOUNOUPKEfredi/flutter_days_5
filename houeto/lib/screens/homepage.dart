import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
   const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HOUETO'),
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () {},
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 129, 194, 248),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vue d\'ensemble', 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
              ),
              SizedBox(height: 10),
              // Cartes statistiques
              _buildStatsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildDashboardCard(
              icon: Icons.mail_outline, 
              title: 'Notifications', 
              value: '00/00'
            ),
            _buildDashboardCard(
              icon: Icons.home_work_outlined, 
              title: ' Total Propriétés', 
              value: '00/00'
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildDashboardCard(
              icon: Icons.home_outlined, 
              title: 'Propriétés louées', 
              value: '00/00'
            ),
            _buildDashboardCard(
              icon: Icons.leaderboard_outlined, 
              title: ' En attente', 
              value: '00/0'
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDashboardCard({
    required IconData icon, 
    required String title, 
    required String value
  }) {
    return Container(
      width: 150,
      height: 130,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 25, color: Colors.blue),
          SizedBox(height: 8),
          Text(
            title, 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
          ),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}