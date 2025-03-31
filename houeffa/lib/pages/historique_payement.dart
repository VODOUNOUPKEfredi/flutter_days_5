import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:houeffa/models/paiement_model.dart';
import 'package:houeffa/services/auth.dart';
import 'package:houeffa/services/service_paiement.dart';
import 'package:intl/intl.dart';

// Page d'historique des paiements
class HistoriquePaiementsPage extends StatefulWidget {
  const HistoriquePaiementsPage({Key? key}) : super(key: key);

  @override
  _HistoriquePaiementsPageState createState() => _HistoriquePaiementsPageState();
}

class _HistoriquePaiementsPageState extends State<HistoriquePaiementsPage> {
  final PaiementService _paiementService = PaiementService();
  final AuthService _authService = AuthService();
  List<Paiement> _paiements = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String? _errorMessage;

  // Contrôleur de recherche
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  // Initialiser Firebase et charger les données
  Future<void> _initializeFirebase() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // S'assurer que Firebase est initialisé
      await Firebase.initializeApp();
      
      // S'assurer que l'utilisateur est authentifié
      if (!_authService.isUserLoggedIn()) {
        await _authService.signInAnonymously();
      }
      
      // Initialiser des données de test (en développement uniquement)
      await _paiementService.initialiserDonneesTest();
      
      // Charger les paiements
      await _chargerPaiements();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Erreur d'initialisation: ${e.toString()}";
        print("Erreur détaillée: $e");
      });
    }
  }

  // Méthode pour charger les paiements depuis Firestore
  Future<void> _chargerPaiements() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final paiements = await _paiementService.getAllPaiements();
      setState(() {
        _paiements = paiements;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Erreur lors du chargement des paiements: ${e.toString()}";
      });
    }
  }

  // Méthode pour filtrer les paiements
  Future<void> _filtrerPaiements(String requete) async {
    if (requete.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      await _chargerPaiements();
      return;
    }

    setState(() {
      _isLoading = true;
      _isSearching = true;
      _errorMessage = null;
    });

    try {
      final resultats = await _paiementService.rechercherPaiements(requete);
      setState(() {
        _paiements = resultats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Erreur lors de la recherche: ${e.toString()}";
      });
    }
  }

  // Méthode pour obtenir la couleur du statut
  Color _getCouleurStatut(StatutPaiement statut) {
    switch (statut) {
      case StatutPaiement.confirme:
        return Colors.green;
      case StatutPaiement.enAttente:
        return Colors.orange;
      case StatutPaiement.enRetard:
        return Colors.red;
      case StatutPaiement.refuse:
        return Colors.grey;
      case StatutPaiement.rembourse:
        return Colors.blue;
    }
  }

  // Méthode pour obtenir le libellé de la méthode de paiement
  String _getLibelleMethodePaiement(MethodePaiement methode) {
    switch (methode) {
      case MethodePaiement.virement:
        return 'Virement';
      case MethodePaiement.cheque:
        return 'Chèque';
      case MethodePaiement.especes:
        return 'Espèces';
      case MethodePaiement.carteBancaire:
        return 'Carte Bancaire';
      case MethodePaiement.prelevement:
        return 'Prélèvement';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des Paiements de Loyer'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _chargerPaiements,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher par référence ou contrat',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filtrerPaiements('');
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                // Debounce la recherche
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (value == _searchController.text) {
                    _filtrerPaiements(value);
                  }
                });
              },
            ),
          ),

          // Contenu principal
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _initializeFirebase,
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      )
                    : _construireListePaiements(),
          ),
        ],
      ),
      // Bouton pour ajouter un nouveau paiement
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implémenter l'ajout d'un nouveau paiement
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fonctionnalité à implémenter: Ajouter un paiement')),
          );
        },
        tooltip: 'Ajouter un paiement',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _construireListePaiements() {
    if (_paiements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.payment_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _isSearching
                  ? 'Aucun paiement ne correspond à votre recherche'
                  : 'Aucun paiement trouvé',
              style: const TextStyle(fontSize: 16),
            ),
            if (!_isSearching)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Implémenter l'ajout d'un nouveau paiement
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fonctionnalité à implémenter: Ajouter un paiement'),
                      ),
                    );
                  },
                  child: const Text('Ajouter un paiement'),
                ),
              ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _chargerPaiements,
      child: ListView.builder(
        itemCount: _paiements.length,
        itemBuilder: (context, index) {
          final paiement = _paiements[index];
          return Dismissible(
            key: Key(paiement.id ?? '${paiement.hashCode}'),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Confirmer la suppression"),
                    content: const Text(
                      "Êtes-vous sûr de vouloir supprimer ce paiement ? Cette action est irréversible.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Annuler"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Supprimer"),
                      ),
                    ],
                  );
                },
              );
            },
            onDismissed: (direction) async {
              try {
                if (paiement.id != null) {
                  await _paiementService.deletePaiement(paiement.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Paiement supprimé avec succès')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur lors de la suppression: $e')),
                );
                await _chargerPaiements(); // Recharger la liste en cas d'erreur
              }
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              elevation: 3,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getCouleurStatut(paiement.statut),
                  child: const Icon(
                    Icons.payment,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  'Contrat #${paiement.idContrat}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Montant: ${paiement.montant.toStringAsFixed(2)} €',
                      style: const TextStyle(color: Colors.black87),
                    ),
                    Text(
                      'Date: ${DateFormat('dd/MM/yyyy').format(paiement.datePaiement)}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    Text(
                      'Méthode: ${_getLibelleMethodePaiement(paiement.methodePaiement)}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _getStatutLibelle(paiement.statut),
                      style: TextStyle(
                        color: _getCouleurStatut(paiement.statut),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                  ],
                ),
                onTap: () {
                  _afficherDetailsPaiement(paiement);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // Méthode pour obtenir le libellé du statut
  String _getStatutLibelle(StatutPaiement statut) {
    switch (statut) {
      case StatutPaiement.enAttente:
        return 'En Attente';
      case StatutPaiement.confirme:
        return 'Confirmé';
      case StatutPaiement.enRetard:
        return 'En Retard';
      case StatutPaiement.refuse:
        return 'Refusé';
      case StatutPaiement.rembourse:
        return 'Remboursé';
    }
  }

  // Méthode pour afficher les détails d'un paiement
  void _afficherDetailsPaiement(Paiement paiement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Détails du Paiement #${paiement.id?.substring(0, 6) ?? "N/A"}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Contrat', '#${paiement.idContrat}'),
                _buildDetailRow('Montant', '${paiement.montant.toStringAsFixed(2)} €'),
                _buildDetailRow('Date de Paiement', DateFormat('dd/MM/yyyy').format(paiement.datePaiement)),
                _buildDetailRow('Méthode', _getLibelleMethodePaiement(paiement.methodePaiement)),
                _buildDetailRow('Statut', _getStatutLibelle(paiement.statut)),
                if (paiement.referenceTransaction != null)
                  _buildDetailRow('Réf. Transaction', paiement.referenceTransaction!),
                if (paiement.dateDebutPeriode != null && paiement.dateFinPeriode != null)
                  _buildDetailRow('Période', '${DateFormat('dd/MM/yyyy').format(paiement.dateDebutPeriode!)} - ${DateFormat('dd/MM/yyyy').format(paiement.dateFinPeriode!)}'),
                const Divider(),
                _buildDetailRow('ID Firestore', paiement.id ?? 'N/A'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Fermer'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Modifier'),
              onPressed: () {
                Navigator.of(context).pop();
                // Implémenter la modification d'un paiement
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fonctionnalité à implémenter: Modifier le paiement')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Méthode utilitaire pour construire les lignes de détails
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}