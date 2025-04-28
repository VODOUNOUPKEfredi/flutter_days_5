import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LogementSearchPage extends StatefulWidget {
  @override
  _LogementSearchPageState createState() => _LogementSearchPageState();
}

class _LogementSearchPageState extends State<LogementSearchPage> {
  // Contrôleur pour la carte Google Maps
  GoogleMapController? _mapController;
  
  // Position initiale de la carte (exemple: Paris)
  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(48.8566, 2.3522),
    zoom: 12.0,
  );
  
  // État des filtres
  RangeValues _prixRange = RangeValues(0, 2000);
  double _chambresMin = 0;
  RangeValues _superficieRange = RangeValues(0, 200);
  String _typeBien = 'tous';
  String _quartier = 'tous';
  
  // Liste des marqueurs sur la carte
  Set<Marker> _markers = {};
  
  // Données d'exemple pour les logements
  final List<Map<String, dynamic>> _logements = [
    {
      'id': 1,
      'titre': 'Appartement lumineux',
      'prix': 850,
      'chambres': 2,
      'superficie': 65,
      'typeBien': 'appartement',
      'quartier': 'Centre',
      'position': LatLng(48.8578, 2.3485),
      'description': 'Bel appartement rénové avec vue dégagée',
      'image': 'https://example.com/appart1.jpg'
    },
    {
      'id': 2,
      'titre': 'Studio moderne',
      'prix': 650,
      'chambres': 1,
      'superficie': 35,
      'typeBien': 'studio',
      'quartier': 'Est',
      'position': LatLng(48.8698, 2.3774),
      'description': 'Studio bien équipé proche des transports',
      'image': 'https://example.com/studio1.jpg'
    },
    {
      'id': 3,
      'titre': 'Maison avec jardin',
      'prix': 1200,
      'chambres': 3,
      'superficie': 95,
      'typeBien': 'maison',
      'quartier': 'Ouest',
      'position': LatLng(48.8591, 2.2920),
      'description': 'Maison familiale avec jardin privatif',
      'image': 'https://example.com/maison1.jpg'
    },
    {
      'id': 4,
      'titre': 'Loft design',
      'prix': 1800,
      'chambres': 2,
      'superficie': 85,
      'typeBien': 'loft',
      'quartier': 'Nord',
      'position': LatLng(48.8978, 2.3452),
      'description': 'Loft industriel entièrement rénové',
      'image': 'https://example.com/loft1.jpg'
    },
  ];
  
  // Liste filtrée des logements
  List<Map<String, dynamic>> _logementsFiltres = [];
  
  // Visibilité du panneau de filtres (pour mobile)
  bool _filtrePanelVisible = false;
  
  @override
  void initState() {
    super.initState();
    _filtrerLogements();
  }
  
  // Filtrer les logements selon les critères
  void _filtrerLogements() {
    setState(() {
      _logementsFiltres = _logements.where((logement) {
        return logement['prix'] >= _prixRange.start &&
               logement['prix'] <= _prixRange.end &&
               logement['chambres'] >= _chambresMin &&
               logement['superficie'] >= _superficieRange.start &&
               logement['superficie'] <= _superficieRange.end &&
               (_typeBien == 'tous' || logement['typeBien'] == _typeBien) &&
               (_quartier == 'tous' || logement['quartier'] == _quartier);
      }).toList();
      
      // Mettre à jour les marqueurs sur la carte
      _updateMarkers();
    });
  }
  
  // Mettre à jour les marqueurs sur la carte
  void _updateMarkers() {
    _markers = {};
    for (var logement in _logementsFiltres) {
      _markers.add(
        Marker(
          markerId: MarkerId(logement['id'].toString()),
          position: logement['position'],
          infoWindow: InfoWindow(
            title: logement['titre'],
            snippet: '${logement['prix']}€ - ${logement['superficie']}m²',
          ),
          onTap: () {
            _showLogementDetails(logement);
          },
        ),
      );
    }
  }
  
  // Afficher les détails d'un logement
  void _showLogementDetails(Map<String, dynamic> logement) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              logement['titre'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text('${logement['prix']}€/mois', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blue)),
                Spacer(),
                Text('${logement['superficie']}m² - ${logement['chambres']} ch.', 
                  style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text('Image du logement')),
            ),
            SizedBox(height: 16),
            Text(logement['description'], style: TextStyle(fontSize: 16)),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Contacter le propriétaire', style: TextStyle(fontSize: 16)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recherche de logement'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                _filtrePanelVisible = !_filtrePanelVisible;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Carte Google Maps
          GoogleMap(
            initialCameraPosition: _initialPosition,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
          ),
          
          // Liste des résultats (en bas de l'écran)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150,
              child: _logementsFiltres.isEmpty
                ? Center(child: Text('Aucun résultat trouvé'))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _logementsFiltres.length,
                    itemBuilder: (context, index) {
                      final logement = _logementsFiltres[index];
                      return GestureDetector(
                        onTap: () {
                          _mapController?.animateCamera(
                            CameraUpdate.newLatLng(logement['position']),
                          );
                          _showLogementDetails(logement);
                        },
                        child: Container(
                          width: 200,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                ),
                                child: Center(child: Text('Photo')),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      logement['titre'],
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${logement['prix']}€ - ${logement['superficie']}m²',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ),
          
          // Panneau de filtres (caché par défaut sur mobile)
          if (_filtrePanelVisible)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Prix (€/mois)', style: TextStyle(fontWeight: FontWeight.bold)),
                    RangeSlider(
                      values: _prixRange,
                      min: 0,
                      max: 2000,
                      divisions: 20,
                      labels: RangeLabels(
                        _prixRange.start.round().toString(),
                        _prixRange.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _prixRange = values;
                        });
                      },
                      onChangeEnd: (RangeValues values) {
                        _filtrerLogements();
                      },
                    ),
                    
                    SizedBox(height: 8),
                    Text('Chambres (min)', style: TextStyle(fontWeight: FontWeight.bold)),
                    Slider(
                      value: _chambresMin,
                      min: 0,
                      max: 4,
                      divisions: 4,
                      label: _chambresMin.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _chambresMin = value;
                        });
                      },
                      onChangeEnd: (value) {
                        _filtrerLogements();
                      },
                    ),
                    
                    SizedBox(height: 8),
                    Text('Superficie (m²)', style: TextStyle(fontWeight: FontWeight.bold)),
                    RangeSlider(
                      values: _superficieRange,
                      min: 0,
                      max: 200,
                      divisions: 20,
                      labels: RangeLabels(
                        _superficieRange.start.round().toString(),
                        _superficieRange.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _superficieRange = values;
                        });
                      },
                      onChangeEnd: (RangeValues values) {
                        _filtrerLogements();
                      },
                    ),
                    
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Type de bien', style: TextStyle(fontWeight: FontWeight.bold)),
                              DropdownButton<String>(
                                value: _typeBien,
                                isExpanded: true,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _typeBien = newValue!;
                                    _filtrerLogements();
                                  });
                                },
                                items: <String>['tous', 'appartement', 'maison', 'studio', 'loft']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value.capitalize()),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Quartier', style: TextStyle(fontWeight: FontWeight.bold)),
                              DropdownButton<String>(
                                value: _quartier,
                                isExpanded: true,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _quartier = newValue!;
                                    _filtrerLogements();
                                  });
                                },
                                items: <String>['tous', 'Centre', 'Nord', 'Sud', 'Est', 'Ouest']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value == 'tous' ? 'Tous' : value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _filtrePanelVisible = false;
                        });
                      },
                      child: Text('Appliquer les filtres'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Extension pour capitaliser la première lettre
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}