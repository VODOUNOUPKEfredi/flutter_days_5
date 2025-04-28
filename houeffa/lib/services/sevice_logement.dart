
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
    int? salledebain,
  
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

    if (salledebain != null) {
      query = query.where('salledebain', isEqualTo: salledebain);
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
 // Récupérer les logements récents
Stream<List<Logement>> getLogementsRecents() {
  return _firestore
      .collection('logements')
      .orderBy('datePublication', descending: true)
      .limit(10) // Limite à 10 logements récents
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Logement.fromFirestore(doc))
          .toList());
}
// Récupérer la répartition des logements par type
Future<Map<String, int>> getRepartitionParType() async {
  QuerySnapshot snapshot = await _firestore.collection('logements').get();
  Map<String, int> repartition = {};

  for (var doc in snapshot.docs) {
    String typeLogement = doc['typeLogement'];
    if (repartition.containsKey(typeLogement)) {
      repartition[typeLogement] = repartition[typeLogement]! + 1;
    } else {
      repartition[typeLogement] = 1;
    }
  }

  return repartition;
}
// Récupérer les logements réservés
Stream<List<Logement>> getLogementsReserves() {
  return _firestore
      .collection('logements')
      .where('estDisponible', isEqualTo: false)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Logement.fromFirestore(doc))
          .toList());
}
// Récupérer les logements disponibles
Stream<List<Logement>> getLogementsDisponibles() {
  return _firestore
      .collection('logements')
      .where('estDisponible', isEqualTo: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Logement.fromFirestore(doc))
          .toList());
}
// Récupérer le nombre total de logements
Future<int> getTotalLogements() async {
  QuerySnapshot snapshot = await _firestore.collection('logements').get();
  return snapshot.docs.length;
}

}
