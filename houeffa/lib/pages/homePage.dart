
import 'package:flutter/material.dart';
import 'package:houeffa/models/logement_modele.dart';
import 'package:houeffa/pages/details_logement.dart';
import 'package:houeffa/services/sevice_logement.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LogementService _logementService = LogementService();

  // Contrôleurs pour les filtres
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _prixMaxController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();
  
  // Variables de filtre
  String? _typeLogementSelectionne;
  int? _nombreChambresSelectionne;

  // Liste des types de logement pour le filtre
  final List<String> _typesLogement = [
    'Appartement', 'Maison', 'Villa', 'Studio', 'Duplex'
  ];

  // Liste des nombres de chambres pour le filtre
  final List<int> _nombresChambres = [1, 2, 3, 4, 5];

  // Méthode pour afficher les filtres avancés
  void _showAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Filtres Avancés',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  // Filtre Prix
                  _buildFilterTextField(
                    controller: _prixMaxController,
                    labelText: 'Prix maximum',
                    suffixText: '€',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 15),
                  // Filtre Ville
                  _buildFilterTextField(
                    controller: _villeController,
                    labelText: 'Ville',
                  ),
                  SizedBox(height: 15),
                  // Filtre Type de Logement
                  _buildDropdownFilter(
                    value: _typeLogementSelectionne,
                    items: _typesLogement,
                    labelText: 'Type de logement',
                    onChanged: (value) {
                      setModalState(() {
                        _typeLogementSelectionne = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  // Filtre Nombre de Chambres
                  _buildDropdownFilter(
                    value: _nombreChambresSelectionne,
                    items: _nombresChambres,
                    labelText: 'Nombre de chambres',
                    onChanged: (value) {
                      setModalState(() {
                        _nombreChambresSelectionne = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Bouton Réinitialiser
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          setModalState(() {
                            _prixMaxController.clear();
                            _villeController.clear();
                            _typeLogementSelectionne = null;
                            _nombreChambresSelectionne = null;
                          });
                        },
                        child: Text('Réinitialiser'),
                      ),
                      // Bouton Appliquer
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                        ),
                        onPressed: () {
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: Text('Appliquer',style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Widget de construction pour les champs de texte de filtre
  Widget _buildFilterTextField({
    required TextEditingController controller,
    required String labelText,
    String? suffixText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        suffixText: suffixText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        fillColor: Colors.grey[100],
        filled: true,
      ),
      keyboardType: keyboardType,
    );
  }

  // Widget de construction pour les dropdowns de filtre
  Widget _buildDropdownFilter<T>({
    T? value,
    required List<T> items,
    required String labelText,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        fillColor: Colors.grey[100],
        filled: true,
      ),
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trouvez votre logement',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.deepPurple),
            onPressed: _showAdvancedFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un logement...',
                prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
                suffixIcon: IconButton(
                  icon: Icon(Icons.filter_alt, color: Colors.deepPurple),
                  onPressed: _showAdvancedFilters,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {
                setState(() {
                  // Logique de recherche ici
                });
              },
            ),
          ),
          // Liste des logements
          Expanded(
            child: StreamBuilder<List<Logement>>(
              stream: _logementService.getLogementsFiltres(
                prixMax: _prixMaxController.text.isNotEmpty 
                    ? double.tryParse(_prixMaxController.text) 
                    : null,
                ville: _villeController.text.isNotEmpty ? _villeController.text : null,
                typeLogement: _typeLogementSelectionne,
                nombreChambres: _nombreChambresSelectionne,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erreur de chargement : ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.deepPurple,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.house_outlined,
                          size: 100,
                          color: Colors.grey[400],
                        ),
                        Text(
                          'Aucun logement trouvé',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Logement logement = snapshot.data![index];
                    return _construireCarteLogement(logement);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _construireCarteLogement(Logement logement) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image du logement
            logement.images.isNotEmpty
                ? Image.asset(
                    logement.images.first, 
                    height: 200, 
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.home,
                      size: 100,
                      color: Colors.grey[600],
                    ),
                  ),
            // Détails du logement
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    logement.titre,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey, size: 16),
                      SizedBox(width: 4),
                      Text(
                        logement.adresse,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${logement.prixMensuel.toStringAsFixed(0)} €/mois',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            '${logement.typeLogement} - ${logement.superficie} m²',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailLogementPage(logement: logement),
                            ),
                          );
                        },
                        child: Text('Détails',style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}