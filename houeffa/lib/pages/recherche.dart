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
  List<Marker> _markers = [];

  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        throw ('Les services de localisation sont désactivés.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw ('Les permissions de localisation sont refusées');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw ('Les permissions de localisation sont définitivement refusées.');
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print('Erreur de localisation: $e');
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
    _markers = _logements.map((logement) {
      return Marker(
        markerId: MarkerId(logement.id ?? ''),
        position: LatLng(45.5017, -73.5673), // À remplacer par des coordonnées réelles
        infoWindow: InfoWindow(
          title: logement.titre,
          snippet: '${logement.prixMensuel} €/mois',
          onTap: () => _showLogementDetails(logement),
        ),
      );
    }).toList();
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
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Contacter'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _filterLogements(String query) {
    setState(() {
      _markers = _logements
          .where((logement) =>
              logement.titre.toLowerCase().contains(query.toLowerCase()) ||
              logement.adresse.toLowerCase().contains(query.toLowerCase()))
          .map((logement) {
        return Marker(
          markerId: MarkerId(logement.id ?? ''),
          position: LatLng(45.5017, -73.5673),
          infoWindow: InfoWindow(
            title: logement.titre,
            snippet: '${logement.prixMensuel} €/mois',
            onTap: () => _showLogementDetails(logement),
          ),
        );
      }).toList();
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
            child: _currentPosition == null
                ? Center(child: CircularProgressIndicator())
                : GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                      zoom: 12,
                    ),
                    markers: Set<Marker>.of(_markers),
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
