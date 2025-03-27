// import 'package:cloud_firestore/cloud_firestore.dart';

// class Logement {
//   final String? id;
//   final String idProprietaire;
//   final String adresse;
//   final String titre;
//   final String description;
//   final String typeLogement;
//   final double superficie;
//   final double prixMensuel;
//   final int nombrePieces;
//   final int nombreChambres;
//   final int nombreSallesBain;
//   final bool meuble;
//   final bool disponible;
//   final DateTime datePublication;
//   final DateTime dateDisponibilite;
//   final List<String> caracteristiques;
//   final List<String> images;

//   Logement({
//     this.id,
//     required this.idProprietaire,
//     required this.adresse,
//     required this.titre,
//     required this.description,
//     required this.typeLogement,
//     required this.superficie,
//     required this.prixMensuel,
//     required this.nombrePieces,
//     required this.nombreChambres,
//     required this.nombreSallesBain,
//     required this.meuble,
//     required this.disponible,
//     required this.datePublication,
//     required this.dateDisponibilite,
//     required this.caracteristiques,
//     required this.images,
//   });

//   // Méthode pour convertir un document Firestore en objet Logement
//   factory Logement.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     return Logement(
//       id: doc.id,
//       idProprietaire: data['idProprietaire'] ?? '',
//       adresse: data['adresse'] ?? '',
//       titre: data['titre'] ?? '',
//       description: data['description'] ?? '',
//       typeLogement: data['typeLogement'] ?? '',
//       superficie: (data['superficie'] ?? 0.0).toDouble(),
//       prixMensuel: (data['prixMensuel'] ?? 0.0).toDouble(),
//       nombrePieces: data['nombrePieces'] ?? 0,
//       nombreChambres: data['nombreChambres'] ?? 0,
//       nombreSallesBain: data['nombreSallesBain'] ?? 0,
//       meuble: data['meuble'] ?? false,
//       disponible: data['disponible'] ?? false,
//       datePublication: (data['datePublication'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       dateDisponibilite: (data['dateDisponibilite'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       caracteristiques: List<String>.from(data['caracteristiques'] ?? []),
//       images: List<String>.from(data['images'] ?? []),
//     );
//   }

//   // Méthode pour convertir l'objet Logement en Map pour Firestore
//   Map<String, dynamic> toFirestore() {
//     return {
//       'idProprietaire': idProprietaire,
//       'adresse': adresse,
//       'titre': titre,
//       'description': description,
//       'typeLogement': typeLogement,
//       'superficie': superficie,
//       'prixMensuel': prixMensuel,
//       'nombrePieces': nombrePieces,
//       'nombreChambres': nombreChambres,
//       'nombreSallesBain': nombreSallesBain,
//       'meuble': meuble,
//       'disponible': disponible,
//       'datePublication': datePublication,
//       'dateDisponibilite': dateDisponibilite,
//       'caracteristiques': caracteristiques,
//       'images': images,
//     };
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class Logement {
  final String? id;
  final String idProprietaire;
  final String adresse;
  final String titre;
  final String description;
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
  final List<String> caracteristiques;
  final List<String> images;

  Logement({
    this.id,
    required this.idProprietaire,
    required this.adresse,
    required this.titre,
    required this.description,
    required this.typeLogement,
    required this.superficie,
    required this.prixMensuel,
    required this.nombrePieces,
    required this.nombreChambres,
    required this.nombreSallesBain,
    required this.meuble,
    required this.disponible,
    required this.datePublication,
    required this.dateDisponibilite,
    required this.caracteristiques,
    required this.images,
  });

  // Méthode pour convertir un document Firestore en objet Logement
  factory Logement.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Logement(
      id: doc.id,
      idProprietaire: data['idProprietaire'] ?? '',
      adresse: data['adresse'] ?? '',
      titre: data['titre'] ?? '',
      description: data['description'] ?? '',
      typeLogement: data['typeLogement'] ?? '',
      superficie: (data['superficie'] ?? 0.0).toDouble(),
      prixMensuel: (data['prixMensuel'] ?? 0.0).toDouble(),
      nombrePieces: data['nombrePieces'] ?? 0,
      nombreChambres: data['nombreChambres'] ?? 0,
      nombreSallesBain: data['nombreSallesBain'] ?? 0,
      meuble: data['meuble'] ?? false,
      disponible: data['disponible'] ?? false,
      datePublication: (data['datePublication'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dateDisponibilite: (data['dateDisponibilite'] as Timestamp?)?.toDate() ?? DateTime.now(),
      caracteristiques: List<String>.from(data['caracteristiques'] ?? []),
      images: List<String>.from(data['images'] ?? []),
    );
  }

  // Méthode pour convertir l'objet Logement en Map pour Firestore
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
      'datePublication': datePublication,
      'dateDisponibilite': dateDisponibilite,
      'caracteristiques': caracteristiques,
      'images': images,
    };
  }
}