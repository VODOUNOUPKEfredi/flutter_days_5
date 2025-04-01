// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:houeffa/models/logement_modele.dart';
// // import 'package:houeffa/pages/details_logement.dart' as detailsPage;

// class DetailLogementPage extends StatelessWidget {
//   final Logement logement;

//   const DetailLogementPage({Key? key, required this.logement}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(logement.titre),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Carousel d'images
//             _construireCarouselImages(),

//             // Informations principales
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     logement.titre,
//                     style: Theme.of(context).textTheme.headlineSmall,
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     '${logement.prixMensuel.toStringAsFixed(0)} € / mois',
//                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           color: Colors.green,
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     logement.adresse,
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                 ],
//               ),
//             ),

//             // Détails du logement
//             _construireSectionDetails(),

//             // Description
//             _construireSectionDescription(),

//             // Caractéristiques
//             _construireSectionCaracteristiques(),
//           ],
//         ),
//       ),
//       // Bouton de contact ou de réservation
//       bottomNavigationBar: _construireBoutonContact(context),
//     );
//   }

//   Widget _construireCarouselImages() {
//     // Si pas d'images, afficher une image par défaut
//     if (logement.images.isEmpty) {
//       return Container(
//         height: 250,
//         color: Colors.grey[300],
//         child: Center(
//           child: Icon(
//             Icons.image_not_supported,
//             size: 100,
//             color: Colors.grey[600],
//           ),
//         ),
//       );
//     }

//     return CarouselSlider(
//       options: CarouselOptions(
//         height: 250.0,
//         viewportFraction: 1.0,
//         enlargeCenterPage: false,
//         autoPlay: true,
//       ),
//       items: logement.images.map((image) {
//         return Builder(
//           builder: (BuildContext context) {
//             return Image.asset(
//               image,
//               fit: BoxFit.cover,
//               width: double.infinity,
//             );
//           },
//         );
//       }).toList(),
//     );
//   }

//   Widget _construireSectionDetails() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               _construireLigneDetail(
//                 Icons.home_outlined,
//                 'Type de logement',
//                 logement.typeLogement,
//               ),
//               Divider(),
//               _construireLigneDetail(
//                 Icons.aspect_ratio,
//                 'Superficie',
//                 '${logement.superficie} m²',
//               ),
//               Divider(),
//               _construireLigneDetail(
//                 Icons.bed_outlined,
//                 'Chambres',
//                 '${logement.nombreChambres}',
//               ),
//               Divider(),
//               _construireLigneDetail(
//                 Icons.bathroom_outlined,
//                 'Salles de bain',
//                 '${logement.nombreSallesBain}',
//               ),
//               Divider(),
//               _construireLigneDetail(
//                 Icons.chair_outlined,
//                 'Meublé',
//                 logement.meuble ? 'Oui' : 'Non',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _construireLigneDetail(IconData icone, String titre, String valeur) {
//     return Row(
//       children: [
//         Icon(icone, color: Colors.blue),
//         SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 titre,
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Text(valeur),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _construireSectionDescription() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Description',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             logement.description??'Aucune description ',
//             style: TextStyle(fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _construireSectionCaracteristiques() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Caractéristiques',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 8),
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: logement.caracteristiques.map((caracteristique) {
//               return Chip(
//                 label: Text(caracteristique),
//                 backgroundColor: Colors.blue.shade50,
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _construireBoutonContact(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: ElevatedButton(
//         onPressed: () {
//           // TODO: Implémenter la logique de contact ou de réservation
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Contactez le propriétaire')),
//           );
//         },
//         style: ElevatedButton.styleFrom(
//           minimumSize: Size(double.infinity, 50),
//         ),
//         child: Text('Contacter le propriétaire'),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:houeffa/models/logement_modele.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailLogementPage extends StatefulWidget {
  final Logement logement;

  const DetailLogementPage({Key? key, required this.logement}) : super(key: key);

  @override
  _DetailLogementPageState createState() => _DetailLogementPageState();
}

class _DetailLogementPageState extends State<DetailLogementPage> {
  int _currentImageIndex = 0;
  
  // Supprimez la ligne problématique du contrôleur
  // final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(widget.logement.titre),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageCarousel(),
            _buildPropertyHeader(),
            _buildPropertySpecs(),
            _buildPropertyDescription(),
            _buildAmenities(),
            if (widget.logement.latitude != null && widget.logement.longitude != null)
              _buildLocationMap(),
            _buildContactButton(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    final List<String> images = widget.logement.photos ?? [];
    
    if (images.isEmpty) {
      return Container(
        height: 250,
        color: Colors.grey[300],
        child: Center(
          child: Icon(Icons.home, size: 100, color: Colors.grey[600]),
        ),
      );
    }

    return Stack(
      children: [
        CarouselSlider(
          // Supprimez la référence au contrôleur
          // carouselController: _carouselController,
          options: CarouselOptions(
            height: 250,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentImageIndex = index;
              });
            },
          ),
          items: images.map((imageUrl) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(Icons.broken_image, size: 50, color: Colors.grey[600]),
                      );
                    },
                  ),
                );
              },
            );
          }).toList(),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images.asMap().entries.map((entry) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentImageIndex == entry.key
                      ? Colors.blue
                      : Colors.white.withOpacity(0.5),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.logement.titre,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.grey, size: 16),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.logement.adresse,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            '${widget.logement.prixMensuel.toStringAsFixed(0)} FCFA/mois',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertySpecs() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
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
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSpecItem('Type de logement', widget.logement.typeLogement),
              _buildSpecItem('Superficie', '${widget.logement.superficie} m²'),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSpecItem('Nombre de pièces', '${widget.logement.nombrePieces}'),
              _buildSpecItem('Chambres', '${widget.logement.nombreChambres ?? "N/A"}'),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSpecItem('Salles de bain', '${widget.logement.nombreSallesBain ?? "N/A"}'),
              _buildSpecItem('Meublé', widget.logement.meuble ? 'Oui' : 'Non'),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Disponible ${widget.logement.dateDisponibilite != null ? "à partir du ${_formatDate(widget.logement.dateDisponibilite!)}" : "immédiatement"}',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyDescription() {
    if (widget.logement.description == null || widget.logement.description!.isEmpty) {
      return SizedBox.shrink();
    }

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
            widget.logement.description!,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenities() {
    final Map<String, dynamic> commodites = widget.logement.commodites ?? {};
    final List<dynamic> caracteristiques = widget.logement.caracteristiques ?? [];
    
    if (commodites.isEmpty && caracteristiques.isEmpty) {
      return SizedBox.shrink();
    }

    List<Widget> amenityWidgets = [];
    
    // Add commodites
    commodites.forEach((key, value) {
      if (value == true) {
        amenityWidgets.add(_buildAmenityItem(key));
      }
    });
    
    // Add caracteristiques
    for (var item in caracteristiques) {
      amenityWidgets.add(_buildAmenityItem(item.toString()));
    }
    
    if (amenityWidgets.isEmpty) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Commodités',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: amenityWidgets,
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityItem(String name) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _capitalizeFirstLetter(name),
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLocationMap() {
    return Container(
      height: 200,
      margin: EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              widget.logement.latitude!,
              widget.logement.longitude!,
            ),
            zoom: 15,
          ),
          markers: {
            Marker(
              markerId: MarkerId('property'),
              position: LatLng(
                widget.logement.latitude!,
                widget.logement.longitude!,
              ),
            ),
          },
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          myLocationButtonEnabled: false,
        ),
      ),
    );
  }

  Widget _buildContactButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            _contactOwner();
          },
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

  void _contactOwner() {
    // Implement contact functionality here
    // This could open a chat screen, launch a phone call, etc.
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contacter le propriétaire'),
        content: Text('Cette fonctionnalité sera bientôt disponible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}