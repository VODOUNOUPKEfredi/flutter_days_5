import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:houeto/screens/detail.dart'; // Assurez-vous que le chemin est correct
import 'package:houeto/screens/logement.dart'; // Assurez-vous que le chemin est correct

class PropertyPage extends StatefulWidget {
  const PropertyPage({Key? key}) : super(key: key);

  @override
  _PropertyPageState createState() => _PropertyPageState();
}

class _PropertyPageState extends State<PropertyPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'Tous';
  String _selectedLocation = '';
  double _minPrice = 0;
  double _maxPrice = 1000000;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        drawer: _buildAppDrawer(context),
        appBar: AppBar(
          title: Text('HOUETO'),
          backgroundColor: const Color.fromARGB(255, 129, 194, 248),
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: _buildPropertyGrid(),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour construire le drawer de l'application
  Widget _buildAppDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 129, 194, 248),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 30, child: Icon(Icons.person, size: 40)),
                SizedBox(height: 10),
                Text(
                  'Jean',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text('jean@gmail.com', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profil'),
            onTap: () {
              // Navigation vers la page Profil
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Propriétés'),
            onTap: () {
              // Navigation vers la liste des propriétés
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Paramètres'),
            onTap: () {
              // Navigation vers les paramètres
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Rechercher une propriété',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {}); // Trigger filtering
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              DropdownButton<String>(
                value: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value ?? 'Tous';
                  });
                },
                items: ['Tous', 'Villa', 'Appartement', 'Boutique']
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
              ),
              SizedBox(width: 20),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Localisation',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedLocation = value;
                    });
                  },
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => _showPriceFilterDialog(context),
                child: Text('Filtrer par prix'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPriceFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        double tempMinPrice = _minPrice;
        double tempMaxPrice = _maxPrice;

        return AlertDialog(
          title: Text('Filtrer par prix'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Min: ${tempMinPrice.toInt()}'),
              Slider(
                value: tempMinPrice,
                min: 0,
                max: 1000000,
                divisions: 100,
                onChanged: (value) {
                  tempMinPrice = value;
                },
              ),
              Text('Max: ${tempMaxPrice.toInt()}'),
              Slider(
                value: tempMaxPrice,
                min: 0,
                max: 1000000,
                divisions: 100,
                onChanged: (value) {
                  tempMaxPrice = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _minPrice = tempMinPrice;
                  _maxPrice = tempMaxPrice;
                });
                Navigator.pop(context);
              },
              child: Text('Appliquer'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPropertyGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('logements').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Erreur de chargement'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Aucun logement trouvé'));
        }

        List<Logement> logements = snapshot.data!.docs
            .map((doc) => Logement.fromFirestore(doc))
            .toList();

        final filteredLogements = logements.where((logement) {
          final matchesSearch = logement.titre
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
          final matchesType = _selectedType == 'Tous' ||
              logement.typeLogement == _selectedType;
          final matchesLocation = _selectedLocation.isEmpty ||
              logement.localisation
                  .toLowerCase()
                  .contains(_selectedLocation.toLowerCase());
          final matchesPrice = logement.prix >= _minPrice &&
              logement.prix <= _maxPrice;

          return matchesSearch && matchesType && matchesLocation && matchesPrice;
        }).toList();

        if (filteredLogements.isEmpty) {
          return Center(
            child: Text(
              'Aucun logement correspondant trouvé',
              style: const TextStyle(fontSize: 16),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: filteredLogements.length,
          itemBuilder: (context, index) {
            final logement = filteredLogements[index];
            return _buildPropertyGridItem(context, logement);
          },
        );
      },
    );
  }

  Widget _buildPropertyGridItem(BuildContext context, Logement logement) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LogementDetailsPage(logement: logement),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: _buildPropertyImage(logement),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                logement.titre,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyImage(Logement logement) {
    return Image.asset(
      'assets/${logement.images?[0] ?? 'default.png'}',
      fit: BoxFit.cover,
    );
  }
}

class Logement {
  final String id;
  final String titre;
  final String typeLogement;
  final String localisation; // Field for location
  final double prix;         // Field for price
  final List<String>? images;

  Logement({
    required this.id,
    required this.titre,
    required this.typeLogement,
    required this.localisation,
    required this.prix,
    this.images,
  });

  factory Logement.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Logement(
      id: doc.id,
      titre: data['titre'] ?? '',
      typeLogement: data['typeLogement'] ?? '',
      localisation: data['localisation'] ?? '', // Map localisation field
      prix: (data['prix'] != null ? data['prix'].toDouble() : 0.0), // Map price field
      images: List<String>.from(data['images'] ?? []),
    );
  }
}

// Assurez-vous que LogementDetailsPage est défini comme ceci:
class LogementDetailsPage extends StatelessWidget {
  final Logement logement;

  const LogementDetailsPage({Key? key, required this.logement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(logement.titre),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Détails de ${logement.titre}'),
            // ... Affichez les autres détails ici
          ],
        ),
      ),
    );
  }
}