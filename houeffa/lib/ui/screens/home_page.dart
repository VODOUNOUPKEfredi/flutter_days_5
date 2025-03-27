import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houeffa/ui/screens/detailspage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedFilter = 'Trending';

  final CollectionReference logementsCollection = FirebaseFirestore.instance
      .collection('logements');

  Stream<List<Map<String, dynamic>>> fetchLogements() {
    return logementsCollection.limit(3).snapshots().asyncMap((snapshot) async {
      List<Map<String, dynamic>> logementsList = [];

      for (var doc in snapshot.docs) {
        var logementDetails = await doc.reference.get();
        if (logementDetails.exists) {
          logementsList.add(logementDetails.data() as Map<String, dynamic>);
        }
      }

      print("Logements récupérés: ${logementsList.length}");
      return logementsList;
    });
  }

  Stream<List<Map<String, dynamic>>> fetchAllLogements() {
    return logementsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .skip(3)
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 249, 252, 255),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 20),
              _buildSearchBar(),
              SizedBox(height: 20),
              _buildCategoryFilters(),
              SizedBox(height: 20),
              _buildSectionHeader('Recommended Property'),
              SizedBox(height: 10),
              _buildRecommandations(context),
              SizedBox(height: 20),
              _buildSectionHeader('Most Popular'),
              SizedBox(height: 10),
              _buildLogementsListView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(backgroundColor: Colors.blue),
        Column(children: [Text("Current location"), Text("Calavi")]),
        IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Find something new',
        prefixIcon: Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            ['Trending', 'House', 'Apartment', 'Villa'].map((category) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: _buildFilterChip(
                  category,
                  selected: _selectedFilter == category,
                  onTap: () {
                    setState(() {
                      _selectedFilter = category;
                    });
                  },
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildFilterChip(
    String label, {
    bool selected = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? Colors.blue : Colors.grey),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text('See all', style: TextStyle(color: Colors.blue)),
      ],
    );
  }

  Widget _buildRecommandations(BuildContext context) {
    return SizedBox(
      height: 220,
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: fetchLogements(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune maison disponible'));
          }

          print("Données récupérées: ${snapshot.data!.length}");

          final logements = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: logements.length,
            itemBuilder: (context, index) {
              final logementData = logements[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(houseData: logementData),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          logementData['images'],
                          width: 150,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '\$${logementData['prixMensuel']} / mois',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        logementData['adresse'],
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLogementsListView() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: fetchAllLogements(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucune maison disponible'));
        }

        final logements = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: logements.length,
          itemBuilder: (context, index) {
            final logementData = logements[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(houseData: logementData),
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          logementData['images'],
                          width: 100,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              logementData['nom'] ?? "Maison",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "\$${logementData['prixMensuel']}",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    logementData['adresse'] ??
                                        "Adresse inconnue",
                                    style: TextStyle(color: Colors.grey[600]),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite_border, color: Colors.red),
                        onPressed: () {
                          // Action pour ajouter aux favoris
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
