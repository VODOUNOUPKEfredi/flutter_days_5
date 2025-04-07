import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> logements = [
  {
    'titre': 'Villa Luxueuse',
    'typeLogement': 'Villa',
    'superficie': 250.0,
    'prixMensuel': 350000,
    'adresse': 'Cadjèhoun',
    'nombrePieces': 6,
    'nombreChambres': 4,
    'nombreSallesBain': 3,
    'meuble': true,
    'disponible': true,
    'description': 'Belle villa moderne avec vue panoramique',
    'caracteristiques': ['Piscine', 'Jardin', 'Terrasse', 'Garage'],
    'images': ['assets/Villa1.jpg'],
    'latitude': 6.3702, 
    'longitude': 2.3912,
  },
  {
    'titre': 'Golden Villa',
    'typeLogement': 'Villa',
    'superficie': 300.0,
    'prixMensuel': 400000,
    'adresse': 'Cadjèhoun',
    'nombrePieces': 5,
    'nombreChambres': 4,
    'nombreSallesBain': 2,
    'meuble': false,
    'disponible': true,
    'description': 'Villa moderne avec belle vue sur la plage',
    'caracteristiques': ['Jardin', 'Balcon', 'Proche plage'],
    'images': ['assets/Villa2.jpg'],
    'latitude': 6.3702, 
    'longitude': 2.3912,
  },

  {
    'titre': 'Saphir Villa',
    'typeLogement': 'Villa',
    'superficie': 250.0,
    'prixMensuel': 500000,
    'adresse': 'Cadjèhoun',
    'nombrePieces': 7,
    'nombreChambres': 3,
    'nombreSallesBain': 3,
    'meuble': true,
    'disponible': true,
    'description': 'Grande villa de luxe avec équipements haut de gamme',
    'caracteristiques': ['Piscine', 'Cuisine équipée', 'Chambre staff'],
    'images': ['assets/Villa3.jpg'],
    'latitude': 6.3702, 
    'longitude': 2.3912,
  },

  {
    'titre': 'Villa Madrid',
    'typeLogement': 'Villa',
    'superficie': 180.0,
    'prixMensuel': 600000,
    'adresse': 'Cadjèhoun',
    'nombrePieces': 5,
    'nombreChambres': 3,
    'nombreSallesBain': 2,
    'meuble': false,
    'disponible': true,
    'description':
        'Charmante villa dans un quartier calme, idéale pour une famille.',
    'caracteristiques': ['Jardin', 'Terrasse', 'Sécurité 24h/24'],
    'images': ['assets/Villa4.jpg'],
    'latitude': 6.3702, 
    'longitude': 2.3912,
  },

  {
    'titre': 'Appartement A',
    'typeLogement': 'Appartement',
    'superficie': 75.5,
    'prixMensuel': 80000,
    'adresse': 'Fidjrossè',
    'nombrePieces': 3,
    'nombreChambres': 2,
    'nombreSallesBain': 1,
    'meuble': true,
    'disponible': true,
    'description': 'Appartement lumineux et moderne',
    'caracteristiques': ['Balcon', 'Cuisine équipée'],
    'images': ['assets/Appart1.jpg'],
    'latitude': 6.3702, 
    'longitude': 2.3912,
  },
  {
    'titre': 'Appartement B',
    'typeLogement': 'Appartement',
    'superficie': 55.0,
    'prixMensuel': 50000,
    'adresse': 'Fidjrossè',
    'nombrePieces': 2,
    'nombreChambres': 1,
    'nombreSallesBain': 1,
    'meuble': false,
    'disponible': true,
    'description': 'Petit appartement idéal pour célibataire',
    'caracteristiques': ['Proche Commissariat', 'Calme'],
    'images': ['assets/Appart2.jpg'],
    'latitude': 6.3702, 
    'longitude': 2.3912,
  },

  {
    'titre': 'Appartement C',
    'typeLogement': 'Appartement',
    'superficie': 70.0,
    'prixMensuel': 80000,
    'adresse': 'Fidjrossè',
    'nombrePieces': 3,
    'nombreChambres': 2,
    'nombreSallesBain': 1,
    'meuble': true,
    'disponible': true,
    'description': 'Appartement meublé à 5min de la plage, idéal pour famille.',
    'caracteristiques': ['Climatisation', 'Connexion WiFi', 'Balcon'],
    'images': ['assets/Appart3.jpg'],
    'latitude': 6.3702, 
    'longitude': 2.3912,
  },

  {
    'titre': 'Appartement D',
    'typeLogement': 'Appartement',
    'superficie': 40.0,
    'prixMensuel': 70000,
    'adresse': 'Fidjrossè',
    'nombrePieces': 2,
    'nombreChambres': 2,
    'nombreSallesBain': 1,
    'meuble': false,
    'disponible': true,
    'description': 'Appartement moderne dans immeuble sécurisé avec parking.',
    'caracteristiques': ['Compteur personnel', 'Calme', 'Sécurité'],
    'images': ['assets/Appart4.jpg'],
    'latitude': 6.3702, 
    'longitude': 2.3912,
  },
  {
    'titre': 'Boutique Commerce',
    'typeLogement': 'Boutique',
    'superficie': 100.0,
    'prixMensuel': 30000,
    'adresse': 'Houéyiho',
    'nombrePieces': 2,
    'nombreChambres': 0,
    'nombreSallesBain': 1,
    'meuble': true,
    'disponible': true,
    'description': 'Local commercial bien situé',
    'caracteristiques': ['Vitrine', 'Arrière-boutique'],
    'images': ['assets/Bout1.jpg'],
    'latitude': 6.3702, 
    'longitude': 2.3912,
  },
  {
    'titre': 'Boutique Centre Commercial',
    'typeLogement': 'Boutique',
    'superficie': 80.0,
    'prixMensuel': 30000,
    'adresse': 'Houéyiho',
    'nombrePieces': 1,
    'nombreChambres': 0,
    'nombreSallesBain': 1,
    'meuble': false,
    'disponible': true,
    'description': 'Emplacement visible dans un centre commercial',
    'caracteristiques': ['Grande vitrine', 'Haute visibilité'],
    'images': ['assets/Bout2.jpg'],
    'latitude': 6.3702, 
    'longitude': 2.3912,
  },

  {
    'titre': 'Boutique Commerce',
    'typeLogement': 'Boutique',
    'superficie': 35.0,
    'prixMensuel': 40000,
    'adresse': 'Missèbo',
    'nombrePieces': 2,
    'nombreChambres': 0,
    'nombreSallesBain': 1,
    'meuble': false,
    'disponible': true,
    'description': 'Boutique spacieuse dans zone de grand marché.',
    'caracteristiques': ['Zone animée', 'Sécurité assurée'],
    'images': ['assets/Bout3.jpg'],
    'latitude': 6.3702, 
    'longitude': 2.3912,
  },

  {
    'titre': 'Boutique Commerce',
    'typeLogement': 'Boutique',
    'superficie': 35.0,
    'prixMensuel': 35000,
    'adresse': 'Dantokpa',
    'nombrePieces': 2,
    'nombreChambres': 0,
    'nombreSallesBain': 1,
    'meuble': false,
    'disponible': true,
    'description': 'Boutique spacieuse dans zone de grand marché.',
    'caracteristiques': ['Zone animée', 'Sécurité assurée'],
    'images': ['assets/Bout4.jpg'],
    'latitude': 6.3702, 
    'longitude': 2.3912,
  },
];

class Logement {
  final String? id;
  final String idProprietaire;
  final String adresse;
  final String titre;
  final String? description;
  final String typeLogement;
  final double superficie;
  final double prixMensuel;
  final int nombrePieces;
  final int nombreChambres;
  final int nombreSallesBain;
  final bool meuble;
  final bool disponible;
  final DateTime datePublication;
  final DateTime dateDisponibilite;
  final List<String>? caracteristiques;
  final List<String>? images;
  final double? latitude;
  final double? longitude;

  Logement({
    this.id,
    required this.idProprietaire,
    required this.adresse,
    required this.titre,
    this.description,
    required this.typeLogement,
    required this.superficie,
    required this.prixMensuel,
    required this.nombrePieces,
    required this.nombreChambres,
    required this.nombreSallesBain,
    this.meuble = false,
    this.disponible = true,
    required this.datePublication,
    required this.dateDisponibilite,
    this.caracteristiques,
    this.images,
    this.latitude,
    this.longitude,
  });

  // Conversion depuis Firestore
  factory Logement.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
     double latitude;
     double longitude;

     if (data['latitude'] != null) {
      // Conversion en double si nécessaire
      latitude = data['latitude'] is double ? data['latitude'] : double.tryParse(data['latitude'].toString());
    }
    
    if (data['longitude'] != null) {
      // Conversion en double si nécessaire
      longitude = data['longitude'] is double ? data['longitude'] : double.tryParse(data['longitude'].toString());
    }


    return Logement(
      id: doc.id,
      idProprietaire: data['idProprietaire'],
      adresse: data['adresse'],
      titre: data['titre'],
      description: data['description'],
      typeLogement: data['typeLogement'] ?? '',
      superficie: data['superficie'].toDouble(),
      prixMensuel: data['prixMensuel'].toDouble(),
      nombrePieces: data['nombrePieces'],
      nombreChambres: data['nombreChambres'],
      nombreSallesBain: data['nombreSallesBain'],
      meuble: data['meuble'],
      disponible: data['disponible'],
      datePublication: (data['datePublication'] as Timestamp).toDate(),
      dateDisponibilite: (data['dateDisponibilite'] as Timestamp).toDate(),
      caracteristiques: List<String>.from(data['caracteristiques'] ?? []),
      images: List<String>.from(data['images'] ?? []),
      latitude: data['latitude'],
      longitude: data['longitude'],
    );
  }

  // Conversion vers Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'idProprietaire': idProprietaire,
      'adresse': adresse,
      'titre': titre,
      'description': description,
      'typeLogement': typeLogement,
      'superficie': superficie,
      'prixMensuel': prixMensuel,
      'nombrePieces': nombrePieces,
      'nombreChambres': nombreChambres,
      'nombreSallesBain': nombreSallesBain,
      'meuble': meuble,
      'disponible': disponible,
      'datePublication': Timestamp.fromDate(datePublication),
      'dateDisponibilite': Timestamp.fromDate(dateDisponibilite),
      'caracteristiques': caracteristiques,
      'images': images,
       'latitude': latitude,
       'longitude': longitude
    };
  }
}

class LogementService {
  final CollectionReference logementsCollection = FirebaseFirestore.instance
      .collection('logements');

  // Ajouter un logement
  Future<void> addLogement(Logement logements) async {
    await logementsCollection.add(logements.toFirestore());
  }

  // Récupérer tous les logements
  Stream<List<Logement>> getLogements() {
    return logementsCollection.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => Logement.fromFirestore(doc)).toList(),
    );
  }

  // Mettre à jour un logement
  Future<void> updateLogement(Logement logement) async {
    await logementsCollection.doc(logement.id).update(logement.toFirestore());
  }

  // Supprimer un logement
  Future<void> deleteLogement(String id) async {
    await logementsCollection.doc(id).delete();
  }
}

class LogementScreenFirestore extends StatefulWidget {
  const LogementScreenFirestore({super.key});

  @override
  _LogementScreenFirestoreState createState() =>
      _LogementScreenFirestoreState();
}

class _LogementScreenFirestoreState extends State<LogementScreenFirestore> {
  final LogementService _logementService = LogementService();

  @override
  void initState() {
    super.initState();
    // Appeler la méthode pour ajouter les logements existants lors de l'initialisation
    _ajouterLogementsExistants();
  }

  // Méthode pour créer un exemple de logement avec l'ID du propriétaire connecté
  Logement _creerExempleLogement() {
    return Logement(
      idProprietaire:
          FirebaseAuth
              .instance
              .currentUser!
              .uid, // Utiliser l'ID du propriétaire connecté
      adresse: '123 Rue de Paris',
      titre: 'Appartement lumineux centre ville',
      typeLogement: 'Appartement',
      superficie: 75.0,
      prixMensuel: 1200.0,
      nombrePieces: 3,
      nombreChambres: 2,
      nombreSallesBain: 1,
      datePublication: DateTime.now(),
      dateDisponibilite: DateTime.now().add(Duration(days: 30)),
      meuble: true,
      description: 'Bel appartement récemment rénové au centre-ville',
      caracteristiques: ['Balcon', 'Cuisine équipée', 'Proche transports'],
      images: ['assets/Appart 1.jpg'],
    );
  }

 Future<void> _ajouterLogementsExistants() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  
  print('Débogage ajout logements:');
  print('Utilisateur connecté: ${currentUser != null}');
  
  if (currentUser == null) {
    print('ERREUR : Aucun utilisateur connecté lors de l\'ajout des logements');
    throw Exception('Aucun utilisateur connecté');
  }

  String idProprietaire = currentUser.uid;
  print('ID Propriétaire: $idProprietaire');

  // Parcourir la liste des logements et les ajouter à Firestore
  for (var logementData in logements) {
    Logement logement = Logement(
      idProprietaire: idProprietaire,
      adresse: logementData['adresse'],
      titre: logementData['titre'],
      typeLogement: logementData['typeLogement'],
      superficie: logementData['superficie'],
      prixMensuel: logementData['prixMensuel'].toDouble(),
      nombrePieces: logementData['nombrePieces'],
      nombreChambres: logementData['nombreChambres'],
      nombreSallesBain: logementData['nombreSallesBain'],
      meuble: logementData['meuble'],
      disponible: logementData['disponible'],
      description: logementData['description'],
      caracteristiques: List<String>.from(logementData['caracteristiques']),
      images: List<String>.from(logementData['images']),
      datePublication: DateTime.now(),
      dateDisponibilite: DateTime.now().add(Duration(days: 30)),
      latitude: logementData['latitude'],
      longitude: logementData['longitude'],
    );

    try {
      await _logementService.addLogement(logement);
      print('Logement ajouté avec succès : ${logement.titre}');
    } catch (e) {
      print('ERREUR lors de l\'ajout du logement : $e');
      throw e; // Relancer l'erreur pour la gestion côté appelant
    }
  }
}
   Future<void> ajouterCoordonnees(String logementId, double latitude, double longitude) async {
  await FirebaseFirestore.instance.collection('logements').doc(logementId).update({
    'latitude': latitude,
    'longitude': longitude,
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Logements'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Section pour ajouter un logement
         Padding(
  padding: const EdgeInsets.all(16.0),
  child: ElevatedButton(
    onPressed: () async {
      try {
        await _ajouterLogementsExistants();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logements ajoutés avec succès')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout des logements: $e')),
        );
      }
    },
    child: Text('Ajouter les Logements'),
  ),
),

          // Liste des logements
          Expanded(
            child: StreamBuilder<List<Logement>>(
              stream: _logementService.getLogements(),
              builder: (context, snapshot) {
                // Gestion des états de chargement
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                // Gestion des erreurs
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erreur de chargement: ${snapshot.error}'),
                  );
                }

                // Pas de logements
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucun logement trouvé'));
                }

                // Affichage de la liste des logements
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Logement logement = snapshot.data![index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(
                          logement.titre,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${logement.typeLogement} - ${logement.superficie}m²',
                            ),
                            Text('${logement.prixMensuel}FCFA/mois'),
                            Text('Adresse: ${logement.adresse}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Bouton de modification
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // Logique de modification du logement
                                _modifierLogement(logement);
                              },
                            ),
                            // Bouton de suppression
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Logique de suppression du logement
                                _supprimerLogement(logement.id!);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Méthode pour modifier un logement
  void _modifierLogement(Logement logement) async {
    try {
      // Créer une copie modifiée du logement
      Logement logementModifie = Logement(
        id: logement.id,
        idProprietaire: logement.idProprietaire,
        adresse: logement.adresse,
        titre: logement.titre + ' (Modifié)',
        typeLogement: logement.typeLogement,
        superficie: logement.superficie,
        prixMensuel: logement.prixMensuel,
        nombrePieces: logement.nombrePieces,
        nombreChambres: logement.nombreChambres,
        nombreSallesBain: logement.nombreSallesBain,
        datePublication: logement.datePublication,
        dateDisponibilite: logement.dateDisponibilite,
      );

      await _logementService.updateLogement(logementModifie);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logement modifié avec succès')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la modification: $e')),
      );
    }
  }

  // Méthode pour supprimer un logement
  void _supprimerLogement(String id) async {
    try {
      await _logementService.deleteLogement(id);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logement supprimé avec succès')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression: $e')),
      );
    }
  }
}
