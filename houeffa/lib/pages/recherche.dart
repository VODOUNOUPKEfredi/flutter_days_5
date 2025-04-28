// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:houeffa/models/logement_modele.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';


// class LogementSearchPage extends StatefulWidget {
//   @override
//   _LogementSearchPageState createState() => _LogementSearchPageState();
// }

// class _LogementSearchPageState extends State<LogementSearchPage> {
//   GoogleMapController? _mapController;
//   Position? _currentPosition;
//   List<Logement> _logements = [];
//   List<Marker> _markers = [];

//   final TextEditingController _searchController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//     _fetchLogements();
//   }

//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     _currentPosition = await Geolocator.getCurrentPosition();
//     setState(() {});
//   }

//   Future<void> _fetchLogements() async {
//     try {
//       QuerySnapshot querySnapshot = await _firestore.collection('logements').get();
      
//       setState(() {
//         _logements = querySnapshot.docs
//             .map((doc) => Logement.fromFirestore(doc))
//             .toList();
        
//         _markers = _logements.map((logement) {
//           // Vous devrez geocoder l'adresse pour obtenir les coordonnées
//           // Cet exemple utilise un géocodage fictif
//           return Marker(
//             markerId: MarkerId(logement.id ?? ''),
//             position: LatLng(
//               45.5017, // Latitude exemple, à remplacer par un géocodage réel
//               -73.5673, // Longitude exemple, à remplacer par un géocodage réel
//             ),
//             infoWindow: InfoWindow(
//               title: logement.titre,
//               snippet: '${logement.prixMensuel} €/mois',
//               onTap: () {
//                 _showLogementDetails(logement);
//               },
//             ),
//           );
//         }).toList();
//       });
//     } catch (e) {
//       print('Erreur lors de la récupération des logements: $e');
//     }
//   }

//   void _showLogementDetails(Logement logement) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 logement.titre,
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               Text('Adresse: ${logement.adresse}'),
//               Text('Type: ${logement.typeLogement}'),
//               Text('Prix: ${logement.prixMensuel} €/mois'),
//               Text('Superficie: ${logement.superficie} m²'),
//               Text('Nombre de pièces: ${logement.nombrePieces}'),
//               ElevatedButton(
//                 onPressed: () {
//                   // Ajouter la logique de réservation ou de contact
//                   Navigator.pop(context);
//                 },
//                 child: Text('Contacter'),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _filterLogements(String query) {
//     setState(() {
//       _markers = _logements
//           .where((logement) =>
//               logement.titre.toLowerCase().contains(query.toLowerCase()) ||
//               logement.adresse.toLowerCase().contains(query.toLowerCase()))
//           .map((logement) {
//         return Marker(
//           markerId: MarkerId(logement.id ?? ''),
//           position: LatLng(
//             45.5017, // Latitude exemple, à remplacer par un géocodage réel
//             -73.5673, // Longitude exemple, à remplacer par un géocodage réel
//           ),
//           infoWindow: InfoWindow(
//             title: logement.titre,
//             snippet: '${logement.prixMensuel} €/mois',
//             onTap: () {
//               _showLogementDetails(logement);
//             },
//           ),
//         );
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Recherche de Logements'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Rechercher un logement...',
//                 prefixIcon: Icon(Icons.search),
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.clear),
//                   onPressed: () {
//                     _searchController.clear();
//                     _filterLogements('');
//                   },
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onChanged: _filterLogements,
//             ),
//           ),
//           Expanded(
//             child: _currentPosition == null
//                 ? Center(child: CircularProgressIndicator())
//                 : GoogleMap(
//                     mapType: MapType.normal,
//                     initialCameraPosition: CameraPosition(
//                       target: LatLng(
//                         _currentPosition!.latitude,
//                         _currentPosition!.longitude,
//                       ),
//                       zoom: 12,
//                     ),
//                     markers: Set<Marker>.of(_markers),
//                     onMapCreated: (GoogleMapController controller) {
//                       _mapController = controller;
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:houeffa/models/logement_modele.dart';

// class LogementSearchPage extends StatefulWidget {
//   @override
//   _LogementSearchPageState createState() => _LogementSearchPageState();
// }

// class _LogementSearchPageState extends State<LogementSearchPage> {
//   GoogleMapController? _mapController;
//   Position? _currentPosition;
//   List<Logement> _logements = [];
//   List<Marker> _markers = [];

//   final TextEditingController _searchController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//     _fetchLogements();
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         throw ('Les services de localisation sont désactivés.');
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           throw ('Les permissions de localisation sont refusées');
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         throw ('Les permissions de localisation sont définitivement refusées.');
//       }

//       Position position = await Geolocator.getCurrentPosition();
//       setState(() {
//         _currentPosition = position;
//       });
//     } catch (e) {
//       print('Erreur de localisation: $e');
//     }
//   }

//   Future<void> _fetchLogements() async {
//     try {
//       QuerySnapshot querySnapshot = await _firestore.collection('logements').get();

//       List<Logement> logements = querySnapshot.docs
//           .map((doc) => Logement.fromFirestore(doc))
//           .toList();

//       setState(() {
//         _logements = logements;
//         _updateMarkers();
//       });
//     } catch (e) {
//       print('Erreur lors de la récupération des logements: $e');
//     }
//   }

//   void _updateMarkers() {
//     _markers = _logements.map((logement) {
//       return Marker(
//         markerId: MarkerId(logement.id ?? ''),
//         position: LatLng(45.5017, -73.5673), // À remplacer par des coordonnées réelles
//         infoWindow: InfoWindow(
//           title: logement.titre,
//           snippet: '${logement.prixMensuel} €/mois',
//           onTap: () => _showLogementDetails(logement),
//         ),
//       );
//     }).toList();
//   }

//   void _showLogementDetails(Logement logement) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(logement.titre, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//               SizedBox(height: 10),
//               Text('Adresse: ${logement.adresse}'),
//               Text('Type: ${logement.typeLogement}'),
//               Text('Prix: ${logement.prixMensuel} €/mois'),
//               Text('Superficie: ${logement.superficie} m²'),
//               Text('Nombre de pièces: ${logement.nombrePieces}'),
//               ElevatedButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text('Contacter'),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _filterLogements(String query) {
//     setState(() {
//       _markers = _logements
//           .where((logement) =>
//               logement.titre.toLowerCase().contains(query.toLowerCase()) ||
//               logement.adresse.toLowerCase().contains(query.toLowerCase()))
//           .map((logement) {
//         return Marker(
//           markerId: MarkerId(logement.id ?? ''),
//           position: LatLng(45.5017, -73.5673),
//           infoWindow: InfoWindow(
//             title: logement.titre,
//             snippet: '${logement.prixMensuel} €/mois',
//             onTap: () => _showLogementDetails(logement),
//           ),
//         );
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Recherche de Logements')),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Rechercher un logement...',
//                 prefixIcon: Icon(Icons.search),
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.clear),
//                   onPressed: () {
//                     _searchController.clear();
//                     _filterLogements('');
//                   },
//                 ),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               onChanged: _filterLogements,
//             ),
//           ),
//           Expanded(
//             child: _currentPosition == null
//                 ? Center(child: CircularProgressIndicator())
//                 : GoogleMap(
//                     mapType: MapType.normal,
//                     initialCameraPosition: CameraPosition(
//                       target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
//                       zoom: 12,
//                     ),
//                     markers: Set<Marker>.of(_markers),
//                     onMapCreated: (GoogleMapController controller) {
//                       _mapController = controller;
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houeffa/models/logement_modele.dart';

class LogementSearchPage extends StatefulWidget {
  @override
  _LogementSearchPageState createState() => _LogementSearchPageState();
}

class _LogementSearchPageState extends State<LogementSearchPage> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  List<Logement> _logements = [];
  Set<Marker> _markers = {}; // Changé de List à Set
  bool _isMapReady = false; // Variable pour suivre l'état de la carte

  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Coordonnées par défaut (à utiliser si la localisation actuelle n'est pas disponible)
  final LatLng _defaultLocation = LatLng(6.3702, 2.3912); // Cotonou, Bénin

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchLogements();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Les services de localisation sont désactivés.');
        setState(() {
          _currentPosition = Position(
            latitude: _defaultLocation.latitude,
            longitude: _defaultLocation.longitude,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0,
          );
          _isMapReady = true;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Les permissions de localisation sont refusées');
          setState(() {
            _currentPosition = Position(
              latitude: _defaultLocation.latitude,
              longitude: _defaultLocation.longitude,
              timestamp: DateTime.now(),
              accuracy: 0,
              altitude: 0,
              heading: 0,
              speed: 0,
              speedAccuracy: 0, altitudeAccuracy: 0, headingAccuracy: 0,
            );
            _isMapReady = true;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Les permissions de localisation sont définitivement refusées.');
        setState(() {
          _currentPosition = Position(
            latitude: _defaultLocation.latitude,
            longitude: _defaultLocation.longitude,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0, 
            altitudeAccuracy: 0, 
            headingAccuracy: 0,
          );
          _isMapReady = true;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
        _isMapReady = true;
      });
    } catch (e) {
      print('Erreur de localisation: $e');
      setState(() {
        _currentPosition = Position(
          latitude: _defaultLocation.latitude,
          longitude: _defaultLocation.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
           altitudeAccuracy: 0,
           headingAccuracy: 0,
        );
        _isMapReady = true;
      });
    }
  }

  Future<void> _fetchLogements() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('logements').get();

      List<Logement> logements = querySnapshot.docs
          .map((doc) => Logement.fromFirestore(doc))
          .toList();

      setState(() {
        _logements = logements;
        _updateMarkers();
      });
    } catch (e) {
      print('Erreur lors de la récupération des logements: $e');
    }
  }

  void _updateMarkers() {
    Set<Marker> markers = {};
    
    for (var logement in _logements) {
      // Utiliser des coordonnées réelles si disponibles, sinon utiliser une position aléatoire autour de la position par défaut
      double lat = logement.latitude ?? (_defaultLocation.latitude + (hashCode % 10) * 0.01);
      double lng = logement.longitude ?? (_defaultLocation.longitude + (hashCode % 10) * 0.01);
      
      markers.add(
        Marker(
          markerId: MarkerId(logement.id ?? ''),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: logement.titre,
            snippet: '${logement.prixMensuel} €/mois',
            onTap: () => _showLogementDetails(logement),
          ),
        ),
      );
    }
    
    setState(() {
      _markers = markers;
    });
  }

  void _showLogementDetails(Logement logement) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(logement.titre, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Adresse: ${logement.adresse}'),
              Text('Type: ${logement.typeLogement}'),
              Text('Prix: ${logement.prixMensuel} €/mois'),
              Text('Superficie: ${logement.superficie} m²'),
              Text('Nombre de pièces: ${logement.nombrePieces}'),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Action pour contacter le propriétaire
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.phone),
                    label: Text('Contacter'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Action pour voir plus de détails
                      Navigator.pop(context);
                      // Naviguer vers la page de détails ici
                    },
                    icon: Icon(Icons.info_outline),
                    label: Text('Plus de détails'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _filterLogements(String query) {
    Set<Marker> filteredMarkers = {};
    
    for (var logement in _logements.where((logement) =>
        logement.titre.toLowerCase().contains(query.toLowerCase()) ||
        logement.adresse.toLowerCase().contains(query.toLowerCase()))) {
          
      double lat = logement.latitude ?? (_defaultLocation.latitude + (hashCode % 10) * 0.01);
      double lng = logement.longitude ?? (_defaultLocation.longitude + (hashCode % 10) * 0.01);
      
      filteredMarkers.add(
        Marker(
          markerId: MarkerId(logement.id ?? ''),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: logement.titre,
            snippet: '${logement.prixMensuel} €/mois',
            onTap: () => _showLogementDetails(logement),
          ),
        ),
      );
    }
    
    setState(() {
      _markers = filteredMarkers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recherche de Logements')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un logement...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterLogements('');
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: _filterLogements,
            ),
          ),
          Expanded(
            child: !_isMapReady
                ? Center(child: CircularProgressIndicator())
                : GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      zoom: 12,
                    ),
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                  ),
          ),
        ],
      ),
    );
  }
}