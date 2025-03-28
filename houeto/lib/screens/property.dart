import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:houeto/screens/detail.dart';
import 'package:houeto/screens/logement.dart';

class PropertyPage extends StatefulWidget {
  const PropertyPage({Key? key}) : super(key: key);

  @override
  _PropertyPageState createState() => _PropertyPageState();
}

class _PropertyPageState extends State<PropertyPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawer: _buildAppDrawer(context),
        appBar: AppBar(
          title: Text('HOUETO'),
          actions: [
            IconButton(icon: Icon(Icons.person_outline), onPressed: () {}),
          ],
          backgroundColor: const Color.fromARGB(255, 129, 194, 248),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Mes propriétés',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
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
            Expanded(
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

  // Méthode pour construire la liste des propriétés
  Widget _buildPropertyList(String type) {
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

        // Convertir les documents Firestore en objets Logement
        List<Logement> logements =
            snapshot.data!.docs
                .map((doc) => Logement.fromFirestore(doc))
                .toList();

        // Filtrer les logements par type
        final filteredLogements =
            logements
                .where(
                  (logement) =>
                      type == 'Tous' ||
                      (type == 'Villas' && logement.typeLogement == 'Villa') ||
                      (type == 'Appartements' &&
                          logement.typeLogement == 'Appartement') ||
                      (type == 'Boutiques' &&
                          logement.typeLogement == 'Boutique'),
                )
                .toList();

        // Si aucun logement ne correspond au type
        if (filteredLogements.isEmpty) {
          return Center(
            child: Text(
              'Aucun ${type == 'Tous' ? 'logement' : type.substring(0, type.length - 1)} trouvé',
              style: const TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: filteredLogements.length,
          itemBuilder: (context, index) {
            final logement = filteredLogements[index];
            return _buildPropertyItem(context, logement);
          },
        );
      },
    );
  }

  // Méthode pour construire un élément de propriété
  Widget _buildPropertyItem(BuildContext context, Logement logement) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: ListTile(
        leading: Icon(
          logement.typeLogement == 'Villa'
              ? Icons.villa
              : logement.typeLogement == 'Appartement'
              ? Icons.apartment
              : Icons.store,
          size: 40,
          color: Colors.blue,
        ),
        title: Text(
          logement.titre,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${logement.typeLogement} • ${logement.superficie}m²'),
            Text('${logement.prixMensuel}FCFA/mois'),
            Text('Adresse: ${logement.adresse}'),
            if (logement.nombreChambres > 0)
              Text(
                '${logement.nombreChambres} chambres, ${logement.nombreSallesBain} salles de bain',
              ),
            if (logement.caracteristiques != null &&
                logement.caracteristiques!.isNotEmpty)
              Text(
                'Caractéristiques: ${logement.caracteristiques!.join(", ")}',
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chevron_right),
            Text(
              logement.disponible ? 'Disponible' : 'Loué',
              style: TextStyle(
                color: logement.disponible ? Colors.green : Colors.red,
                fontSize: 10,
              ),
            ),
          ],
        ),
        onTap: () {
          // Navigue vers les détails du logement
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LogementDetailsPage(logement: logement),
            ),
          );
        },
      ),
    );
  }

  // Méthode utilitaire pour créer des lignes de détails
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
