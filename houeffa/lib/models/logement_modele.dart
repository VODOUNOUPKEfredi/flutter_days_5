
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

  bool get disponible => true;

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