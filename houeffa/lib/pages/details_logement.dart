import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:houeffa/models/logement_modele.dart';
// import 'package:houeffa/pages/details_logement.dart' as detailsPage;

class DetailLogementPage extends StatelessWidget {
  final Logement logement;

  const DetailLogementPage({Key? key, required this.logement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(logement.titre),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel d'images
            _construireCarouselImages(),

            // Informations principales
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    logement.titre,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${logement.prixMensuel.toStringAsFixed(0)} € / mois',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    logement.adresse,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),

            // Détails du logement
            _construireSectionDetails(),

            // Description
            _construireSectionDescription(),

            // Caractéristiques
            _construireSectionCaracteristiques(),
          ],
        ),
      ),
      // Bouton de contact ou de réservation
      bottomNavigationBar: _construireBoutonContact(context),
    );
  }

  Widget _construireCarouselImages() {
    // Si pas d'images, afficher une image par défaut
    if (logement.images.isEmpty) {
      return Container(
        height: 250,
        color: Colors.grey[300],
        child: Center(
          child: Icon(
            Icons.image_not_supported,
            size: 100,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 250.0,
        viewportFraction: 1.0,
        enlargeCenterPage: false,
        autoPlay: true,
      ),
      items: logement.images.map((image) {
        return Builder(
          builder: (BuildContext context) {
            return Image.asset(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
            );
          },
        );
      }).toList(),
    );
  }

  Widget _construireSectionDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _construireLigneDetail(
                Icons.home_outlined,
                'Type de logement',
                logement.typeLogement,
              ),
              Divider(),
              _construireLigneDetail(
                Icons.aspect_ratio,
                'Superficie',
                '${logement.superficie} m²',
              ),
              Divider(),
              _construireLigneDetail(
                Icons.bed_outlined,
                'Chambres',
                '${logement.nombreChambres}',
              ),
              Divider(),
              _construireLigneDetail(
                Icons.bathroom_outlined,
                'Salles de bain',
                '${logement.nombreSallesBain}',
              ),
              Divider(),
              _construireLigneDetail(
                Icons.chair_outlined,
                'Meublé',
                logement.meuble ? 'Oui' : 'Non',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construireLigneDetail(IconData icone, String titre, String valeur) {
    return Row(
      children: [
        Icon(icone, color: Colors.blue),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titre,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(valeur),
            ],
          ),
        ),
      ],
    );
  }

  Widget _construireSectionDescription() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            logement.description??'Aucune description ',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _construireSectionCaracteristiques() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Caractéristiques',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: logement.caracteristiques.map((caracteristique) {
              return Chip(
                label: Text(caracteristique),
                backgroundColor: Colors.blue.shade50,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _construireBoutonContact(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implémenter la logique de contact ou de réservation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Contactez le propriétaire')),
          );
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
        ),
        child: Text('Contacter le propriétaire'),
      ),
    );
  }
}