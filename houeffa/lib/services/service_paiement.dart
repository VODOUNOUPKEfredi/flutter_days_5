import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houeffa/models/paiement_model.dart';

// Service pour gérer les opérations Firestore
class PaiementService {
  final CollectionReference paiementsCollection = 
      FirebaseFirestore.instance.collection('paiements');

  // Récupérer tous les paiements
  Stream<List<Paiement>> getPaiementsStream() {
    return paiementsCollection
        .orderBy('datePaiement', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Paiement.fromDocumentSnapshot(doc))
            .toList());
  }

  // Récupérer les paiements d'un contrat spécifique
  Stream<List<Paiement>> getPaiementsContratStream(int idContrat) {
    return paiementsCollection
        .where('idContrat', isEqualTo: idContrat)
        .orderBy('datePaiement', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Paiement.fromDocumentSnapshot(doc))
            .toList());
  }

  // Récupérer une seule fois tous les paiements
  Future<List<Paiement>> getAllPaiements() async {
    final snapshot = await paiementsCollection
        .orderBy('datePaiement', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => Paiement.fromDocumentSnapshot(doc))
        .toList();
  }

  // Rechercher des paiements par référence ou contrat
  Future<List<Paiement>> rechercherPaiements(String requete) async {
    // Recherche par référence de transaction
    final snapshotRef = await paiementsCollection
        .where('referenceTransaction', isGreaterThanOrEqualTo: requete)
        .where('referenceTransaction', isLessThanOrEqualTo: requete + '\uf8ff')
        .get();
    
    // Conversion de la requête en nombre pour la recherche par ID de contrat
    int? idContratRecherche;
    try {
      idContratRecherche = int.parse(requete);
    } catch (e) {
      idContratRecherche = null;
    }
    
    // Si la requête est un nombre valide, rechercher par ID de contrat
    List<Paiement> resultats = snapshotRef.docs
        .map((doc) => Paiement.fromDocumentSnapshot(doc))
        .toList();
    
    if (idContratRecherche != null) {
      final snapshotContrat = await paiementsCollection
          .where('idContrat', isEqualTo: idContratRecherche)
          .get();
      
      // Ajouter les résultats par ID de contrat
      final paiementsContrat = snapshotContrat.docs
          .map((doc) => Paiement.fromDocumentSnapshot(doc))
          .toList();
      
      // Fusionner les résultats en évitant les doublons
      for (var paiement in paiementsContrat) {
        if (!resultats.any((p) => p.id == paiement.id)) {
          resultats.add(paiement);
        }
      }
      
      // Trier par date de paiement
      resultats.sort((a, b) => b.datePaiement.compareTo(a.datePaiement));
    }
    
    return resultats;
  }

  // Ajouter un nouveau paiement
  Future<String> ajouterPaiement(Paiement paiement) async {
    final docRef = await paiementsCollection.add(paiement.toMap());
    return docRef.id;
  }

  // Mettre à jour un paiement existant
  Future<void> updatePaiement(Paiement paiement) async {
    if (paiement.id != null) {
      await paiementsCollection.doc(paiement.id).update(paiement.toMap());
    }
  }

  // Supprimer un paiement
  Future<void> deletePaiement(String id) async {
    await paiementsCollection.doc(id).delete();
  }

  // Initialiser des données de test (à utiliser uniquement en développement)
  Future<void> initialiserDonneesTest() async {
    // Vérifier si la collection est vide
    final snapshot = await paiementsCollection.limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      return; // Des données existent déjà, ne pas initialiser
    }

    // Liste des paiements de test
    final paiementsTest = [
      Paiement(
        idContrat: 101,
        montant: 850.50,
        datePaiement: DateTime.now().subtract(const Duration(days: 5)),
        methodePaiement: MethodePaiement.virement,
        statut: StatutPaiement.confirme,
        referenceTransaction: 'VIR2023052501',
        dateDebutPeriode: DateTime(2023, 5, 1),
        dateFinPeriode: DateTime(2023, 5, 31),
      ),
      Paiement(
        idContrat: 101,
        montant: 850.50,
        datePaiement: DateTime.now().subtract(const Duration(days: 35)),
        methodePaiement: MethodePaiement.cheque,
        statut: StatutPaiement.confirme,
        referenceTransaction: 'CHQ2023042301',
        dateDebutPeriode: DateTime(2023, 4, 1),
        dateFinPeriode: DateTime(2023, 4, 30),
      ),
      Paiement(
        idContrat: 101,
        montant: 850.50,
        datePaiement: DateTime.now().subtract(const Duration(days: 65)),
        methodePaiement: MethodePaiement.carteBancaire,
        statut: StatutPaiement.enRetard,
        referenceTransaction: 'CB2023032501',
        dateDebutPeriode: DateTime(2023, 3, 1),
        dateFinPeriode: DateTime(2023, 3, 31),
      ),
    ];

    // Ajouter les paiements de test à Firestore
    for (var paiement in paiementsTest) {
      await ajouterPaiement(paiement);
    }
  }
}