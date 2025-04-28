import 'package:cloud_firestore/cloud_firestore.dart';

// Énumération pour la méthode de paiement
enum MethodePaiement {
  virement,
  cheque,
  especes,
  carteBancaire,
  prelevement
}

// Énumération pour le statut du paiement
enum StatutPaiement {
  enAttente,
  confirme,
  enRetard,
  refuse,
  rembourse
}

// Classe de paiement avec méthodes pour conversion depuis/vers Firestore
class Paiement {
  // Identifiant unique du paiement
  final String? id;
  // Identifiant du contrat concerné
  final int idContrat;
  // Montant total du paiement
  final double montant;
  // Date à laquelle le paiement a été effectué
  final DateTime datePaiement;
  // Méthode utilisée pour le paiement
  final MethodePaiement methodePaiement;
  // Statut actuel du paiement
  final StatutPaiement statut;
  // Référence de la transaction bancaire
  final String? referenceTransaction;
  // Date de début de la période couverte (optionnelle)
  final DateTime? dateDebutPeriode;
  // Date de fin de la période couverte (optionnelle)
  final DateTime? dateFinPeriode;

  Paiement({
    this.id,
    required this.idContrat,
    required this.montant,
    required this.datePaiement,
    required this.methodePaiement,
    required this.statut,
    this.referenceTransaction,
    this.dateDebutPeriode,
    this.dateFinPeriode,
  });

  // Conversion d'un Paiement en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'idContrat': idContrat,
      'montant': montant,
      'datePaiement': Timestamp.fromDate(datePaiement),
      'methodePaiement': methodePaiement.index,
      'statut': statut.index,
      'referenceTransaction': referenceTransaction,
      'dateDebutPeriode': dateDebutPeriode != null ? Timestamp.fromDate(dateDebutPeriode!) : null,
      'dateFinPeriode': dateFinPeriode != null ? Timestamp.fromDate(dateFinPeriode!) : null,
    };
  }

  // Création d'un Paiement à partir d'un DocumentSnapshot Firestore
  factory Paiement.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Paiement(
      id: doc.id,
      idContrat: data['idContrat'] ?? 0,
      montant: (data['montant'] ?? 0).toDouble(),
      datePaiement: (data['datePaiement'] as Timestamp).toDate(),
      methodePaiement: MethodePaiement.values[data['methodePaiement'] ?? 0],
      statut: StatutPaiement.values[data['statut'] ?? 0],
      referenceTransaction: data['referenceTransaction'],
      dateDebutPeriode: data['dateDebutPeriode'] != null 
          ? (data['dateDebutPeriode'] as Timestamp).toDate() 
          : null,
      dateFinPeriode: data['dateFinPeriode'] != null 
          ? (data['dateFinPeriode'] as Timestamp).toDate() 
          : null,
    );
  }
}