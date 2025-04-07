import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:houeto/screens/logement.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LogementDetailsPage extends StatelessWidget {
  final Logement logement;

  const LogementDetailsPage({Key? key, required this.logement})
    : super(key: key);

  // Méthode pour construire une ligne de détail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

 void _showLocationMap(BuildContext context) {
  // Vérifier si les coordonnées existent
  if (logement.latitude == null || logement.longitude == null) {
    // Afficher un message d'erreur
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Coordonnées GPS non disponibles pour ce logement'),
        duration: Duration(seconds: 3),
      ),
    );
    return;
  }
   Future<void> ajouterCoordonnees(String logementId, double latitude, double longitude) async {
  await FirebaseFirestore.instance.collection('logements').doc(logementId).update({
    'latitude': latitude,
    'longitude': longitude,
  });
}
  // Utiliser les coordonnées du logement
  double latitude = logement.latitude!;
  double longitude = logement.longitude!;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emplacement du logement',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Lat: ${latitude.toStringAsFixed(6)}, Lng: ${longitude.toStringAsFixed(6)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
              Expanded(
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter:LatLng(6.3702, 2.3912), // center → initialCenter
                    initialZoom: 15.0, // zoom → initialZoom
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                     userAgentPackageName: 'com.houeto'
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 40.0,
                          height: 40.0,
                          point: LatLng(latitude, longitude),
                          child: Icon(
                            // builder → child
                            Icons.location_on,
                            color: Colors.red,
                            size: 40.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(logement.titre), backgroundColor: Colors.blue),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section images
            if (logement.images != null && logement.images!.isNotEmpty)
              SizedBox(
                height: 250,
                child: PageView.builder(
                  itemCount: logement.images!.length,
                  itemBuilder: (context, index) {
                    return Image.asset(
                      "assets/${logement.images![index]}",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        print("Erreur de chargement d'image: $error");
                        return Container(
                          color: Colors.grey[300],
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

            // Contenu des détails
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre et adresse
                  Text(
                    logement.titre,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: () => _showLocationMap(context),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            logement.adresse,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Détails principaux
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            'Type de logement',
                            logement.typeLogement,
                          ),
                          Divider(),
                          _buildDetailRow(
                            'Superficie',
                            '${logement.superficie} m²',
                          ),
                          Divider(),
                          _buildDetailRow(
                            'Loyer',
                            '${logement.prixMensuel} FCFA/mois',
                          ),
                          Divider(),
                          _buildDetailRow(
                            'Nombre de pièces',
                            '${logement.nombrePieces}',
                          ),
                          Divider(),
                          _buildDetailRow(
                            'Chambres',
                            '${logement.nombreChambres}',
                          ),
                          Divider(),
                          _buildDetailRow(
                            'Salles de bain',
                            '${logement.nombreSallesBain}',
                          ),
                          Divider(),
                          _buildDetailRow(
                            'Meublé',
                            logement.meuble ? 'Oui' : 'Non',
                          ),
                          Divider(),
                          _buildDetailRow(
                            'Disponibilité',
                            logement.disponible ? 'Disponible' : 'Loué',
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Description
                  if (logement.description != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          logement.description!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),

                  // Caractéristiques
                  if (logement.caracteristiques != null &&
                      logement.caracteristiques!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Caractéristiques',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              logement.caracteristiques!
                                  .map( 
                                    (c) => Chip(
                                      label: Text(c),
                                      backgroundColor: Colors.blue[50],
                                    ),
                                  )
                                  .toList(),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bouton de contact ou de réservation
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Logique de contact ou de réservation
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Contacter')));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            'Contacter',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
