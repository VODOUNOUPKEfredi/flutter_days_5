import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
   final List<Map<String, dynamic>> properties = [
    {'type': 'Appartements', 'title': 'Appartement '},
    {'type': 'Villas', 'title': 'Villa Nice'},
    {'type': 'Boutiques', 'title': 'Boutique '},
  ];


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
           body: SingleChildScrollView (
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section vue d'ensemble
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Vue d\'ensemble', 
                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline, color: Colors.green,),
                      onPressed: () {},
                    ),
                  ],
         
                ),  
                 SizedBox(height: 10),
                // Cartes statistiques
                _buildStatsSection(context),
                SizedBox(height: 20),
                // Section des propriétés
                  Text('Mes propriétés', 
                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                         SizedBox(height: 20),

                   TabBar(
                isScrollable: true,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                  tabs: [
                    Tab(text: 'Tous'),
                    Tab(text: 'Villas'),
                    Tab(text: 'Appartements'),
                    Tab(text: 'Boutiques'),
                  ],
                ),

                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: TabBarView(
                    children: [
                      _buildPropertyList('Tous'),
                      _buildPropertyList('Villas'),
                      _buildPropertyList('Appartements'),
                      _buildPropertyList('Boutiques'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

                
                
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

  Widget _buildDashboardCard({required IconData icon, required String title, required String value}) {
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
          Text(title, 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
   Widget _buildPropertyList(String type) {
    final filteredProperties = properties.where((p) => 
      type == 'Tous' || p['type'] == type).toList();

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: filteredProperties.length,
      itemBuilder: (context, index) {
        return _buildPropertyItem(filteredProperties[index]);
      },
    );
  }

  Widget _buildPropertyItem(Map<String, dynamic> property) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.home, size: 40, color: Colors.blue),
        title: Text(property['title'], 
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${property['price']} • ${property['size']}'),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }

