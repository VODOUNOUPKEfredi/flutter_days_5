import 'package:flutter/material.dart';
import 'package:houeto/screens/logement.dart'; // Assurez-vous d'importer votre modèle Logement

class LogementDetailsPage extends StatelessWidget {
  final Logement logement;

  const LogementDetailsPage({Key? key, required this.logement}) : super(key: key);

  // Méthode pour construire une ligne de détail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(logement.titre),
        backgroundColor: Colors.blue,
      ),
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
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
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

                  SizedBox(height: 20),

                  // Détails principaux
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildDetailRow('Type de logement', logement.typeLogement),
                          Divider(),
                          _buildDetailRow('Superficie', '${logement.superficie} m²'),
                          Divider(),
                          _buildDetailRow('Loyer', '${logement.prixMensuel} FCFA/mois'),
                          Divider(),
                          _buildDetailRow('Nombre de pièces', '${logement.nombrePieces}'),
                          Divider(),
                          _buildDetailRow('Chambres', '${logement.nombreChambres}'),
                          Divider(),
                          _buildDetailRow('Salles de bain', '${logement.nombreSallesBain}'),
                          Divider(),
                          _buildDetailRow('Meublé', logement.meuble ? 'Oui' : 'Non'),
                          Divider(),
                          _buildDetailRow('Disponibilité', logement.disponible ? 'Disponible' : 'Loué'),
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
                  if (logement.caracteristiques != null && logement.caracteristiques!.isNotEmpty)
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
                          children: logement.caracteristiques!
                              .map((c) => Chip(
                                    label: Text(c),
                                    backgroundColor: Colors.blue[50],
                                  ))
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Contacter')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            'Contacter',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}