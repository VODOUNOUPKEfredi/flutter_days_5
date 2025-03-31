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
  final String titre;
  final String adresse;
  final String typeLogement;
  final double prixMensuel;
  final double superficie;
  final int nombrePieces;
  final String? description;
  final List<String>? photos;
  final String? proprietaireId;
  final DateTime? dateDisponibilite;
  final bool estDisponible;
  final Map<String, dynamic>? commodites;

  Logement({
    this.id,
    required this.titre,
    required this.adresse,
    required this.typeLogement,
    required this.prixMensuel,
    required this.superficie,
    required this.nombrePieces,
    this.description,
    this.photos,
    this.proprietaireId,
    this.dateDisponibilite,
    this.estDisponible = true,
    this.commodites,
  });

  factory Logement.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return Logement(
      id: doc.id,
      titre: data['titre'] ?? '',
      adresse: data['adresse'] ?? '',
      typeLogement: data['typeLogement'] ?? '',
      prixMensuel: (data['prixMensuel'] ?? 0).toDouble(),
      superficie: (data['superficie'] ?? 0).toDouble(),
      nombrePieces: data['nombrePieces'] ?? 0,
      description: data['description'],
      photos: data['photos'] != null ? List<String>.from(data['photos']) : null,
      proprietaireId: data['proprietaireId'],
      dateDisponibilite: data['dateDisponibilite'] != null 
          ? (data['dateDisponibilite'] as Timestamp).toDate() 
          : null,
      estDisponible: data['estDisponible'] ?? true,
      commodites: data['commodites'],
    );
  }

  get images => null;

  get nombreChambres => null;

  get nombreSallesBain => null;

  bool get meuble => false;

  get caracteristiques => null;

  get latitude => null;

  get longitude => null;

  Map<String, dynamic> toFirestore() {
    return {
      'titre': titre,
      'adresse': adresse,
      'typeLogement': typeLogement,
      'prixMensuel': prixMensuel,
      'superficie': superficie,
      'nombrePieces': nombrePieces,
      'description': description,
      'photos': photos,
      'proprietaireId': proprietaireId,
      'dateDisponibilite': dateDisponibilite != null ? Timestamp.fromDate(dateDisponibilite!) : null,
      'estDisponible': estDisponible,
      'commodites': commodites,
    };
  }

  
}