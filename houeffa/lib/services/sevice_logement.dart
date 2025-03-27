// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:houeffa/models/logement_modele.dart';

// class LogementService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Récupérer tous les logements
//   Stream<List<Logement>> getLogements() {
//     return _firestore
//         .collection('logements')
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => Logement.fromFirestore(doc))
//             .toList());
//   }

//   // Récupérer les logements avec filtres
//   Stream<List<Logement>> getLogementsFiltres({
//     double? prixMax,
//     String? ville,
//     String? typeLogement,
//     int? nombreChambres,
//   }) {
//     Query query = _firestore.collection('logements');

//     // Filtres optionnels
//     if (prixMax != null) {
//       query = query.where('prixMensuel', isLessThanOrEqualTo: prixMax);
//     }

//     if (ville != null && ville.isNotEmpty) {
//       query = query.where('adresse', isGreaterThanOrEqualTo: ville)
//                    .where('adresse', isLessThan: ville + '\uf8ff');
//     }

//     if (typeLogement != null && typeLogement.isNotEmpty) {
//       query = query.where('typeLogement', isEqualTo: typeLogement);
//     }

//     if (nombreChambres != null) {
//       query = query.where('nombreChambres', isGreaterThanOrEqualTo: nombreChambres);
//     }

//     return query.snapshots().map((snapshot) => 
//         snapshot.docs.map((doc) => Logement.fromFirestore(doc)).toList());
//   }

//   // Ajouter un nouveau logement
//   Future<void> ajouterLogement(Logement logement) async {
//     await _firestore.collection('logements').add(logement.toFirestore());
//   }

//   // Mettre à jour un logement existant
//   Future<void> mettreAJourLogement(Logement logement) async {
//     if (logement.id == null) {
//       throw Exception('ID du logement requis pour la mise à jour');
//     }
//     await _firestore
//         .collection('logements')
//         .doc(logement.id)
//         .update(logement.toFirestore());
//   }

//   // Supprimer un logement
//   Future<void> supprimerLogement(String logementId) async {
//     await _firestore.collection('logements').doc(logementId).delete();
//   }

//   // Méthode pour ajouter des logements de démonstration
//   Future<void> ajouterLogementsDemo() async {
//     List<Map<String, dynamic>> logementsDemo = [
//       {
//         'idProprietaire': 'prop001',
//         'titre': 'Villa Luxueuse',
//         'typeLogement': 'Villa',
//         'superficie': 250.0,
//         'prixMensuel': 350000,
//         'adresse': 'Cadjèhoun',
//         'nombrePieces': 6,
//         'nombreChambres': 4,
//         'nombreSallesBain': 3,
//         'meuble': true,
//         'disponible': true,
//         'description': 'Belle villa moderne avec vue panoramique',
//         'caracteristiques': ['Piscine', 'Jardin', 'Terrasse', 'Garage'],
//         'images': [
//           'assets/Villa 1.jpg'
//         ],
//         'datePublication': DateTime.now(),
//         'dateDisponibilite': DateTime.now(),
//       },
//       // Vous pouvez ajouter d'autres logements de démonstration ici
//     ];

//     for (var logementData in logementsDemo) {
//       await _firestore.collection('logements').add(logementData);
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houeffa/models/logement_modele.dart';

class LogementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Récupérer tous les logements
  Stream<List<Logement>> getLogements() {
    return _firestore
        .collection('logements')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Logement.fromFirestore(doc))
            .toList());
  }

  // Récupérer les logements avec filtres
  Stream<List<Logement>> getLogementsFiltres({
    double? prixMax,
    String? ville,
    String? typeLogement,
    int? nombreChambres,
  }) {
    Query query = _firestore.collection('logements');

    // Filtres optionnels
    if (prixMax != null) {
      query = query.where('prixMensuel', isLessThanOrEqualTo: prixMax);
    }

    if (ville != null && ville.isNotEmpty) {
      // Modification du filtre ville pour correspondre exactement
      query = query.where('adresse', isEqualTo: ville);
    }

    if (typeLogement != null && typeLogement.isNotEmpty) {
      query = query.where('typeLogement', isEqualTo: typeLogement);
    }

    if (nombreChambres != null) {
      query = query.where('nombreChambres', isEqualTo: nombreChambres);
    }

    return query.snapshots().map((snapshot) => 
        snapshot.docs.map((doc) => Logement.fromFirestore(doc)).toList());
  }

  // Ajouter un nouveau logement
  Future<void> ajouterLogement(Logement logement) async {
    await _firestore.collection('logements').add(logement.toFirestore());
  }

  // Mettre à jour un logement existant
  Future<void> mettreAJourLogement(Logement logement) async {
    if (logement.id == null) {
      throw Exception('ID du logement requis pour la mise à jour');
    }
    await _firestore
        .collection('logements')
        .doc(logement.id)
        .update(logement.toFirestore());
  }

  // Supprimer un logement
  Future<void> supprimerLogement(String logementId) async {
    await _firestore.collection('logements').doc(logementId).delete();
  }

  // Méthode pour ajouter des logements de démonstration
  Future<void> ajouterLogementsDemo() async {
    List<Map<String, dynamic>> logementsDemo = [
      {
        'idProprietaire': 'prop001',
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
        'images': [
          'assets/Villa 1.jpg'
        ],
        'datePublication': DateTime.now(),
        'dateDisponibilite': DateTime.now(),
      },
      // Vous pouvez ajouter d'autres logements de démonstration ici
    ];

    for (var logementData in logementsDemo) {
      await _firestore.collection('logements').add(logementData);
    }
  }
}
