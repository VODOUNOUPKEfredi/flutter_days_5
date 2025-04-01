
import 'package:flutter/material.dart';
import 'package:houeffa/models/logement_modele.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:houeffa/pages/tchatPage.dart';
import 'package:houeffa/provider/auth_provider.dart' show AuthProvider;
import 'package:houeffa/services/discussion_service.dart';
import 'package:houeffa/services/notification%20service.dart';
import 'package:provider/provider.dart';

class DetailLogementPage extends StatefulWidget {
  final Logement logement;

  const DetailLogementPage({Key? key, required this.logement}) : super(key: key);

  @override
  _DetailLogementPageState createState() => _DetailLogementPageState();
}

class _DetailLogementPageState extends State<DetailLogementPage> {
  int _currentImageIndex = 0;
  bool _isLoading = false;
  
  // Ajout des services
  late NotificationService _notificationService;
  late ChatService _chatService;

  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService();
    _chatService = ChatService();
  }

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
          onPressed: _isLoading ? null : _contactOwner,
          child: _isLoading 
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Text(
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

  // Méthode corrigée pour contacter le propriétaire
  Future<void> _contactOwner() async {
    // Récupérer l'utilisateur actuel
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;
    
    if (currentUser == null) {
      // L'utilisateur n'est pas connecté
      _showLoginDialog();
      return;
    }
    
    // Extraction de l'ID utilisateur à partir de l'objet UserModel
    final currentUserId = currentUser.uid; // ou currentUser.id selon votre modèle
    
    // Vérification de la présence des IDs nécessaires
    if (widget.logement.id == null || widget.logement.proprietaireId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Informations de logement incomplètes')),
      );
      return;
    }
    
    final logementId = widget.logement.id!;
    final proprietaireId = widget.logement.proprietaireId!;
    
    // Vérifier si l'utilisateur est le propriétaire du logement
    if (currentUserId == proprietaireId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vous êtes le propriétaire de ce logement')),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // 1. Créer ou récupérer une discussion existante
      final chatId = await _chatService.createOrGetChat(
        currentUserId: currentUserId,
        proprietaireId: proprietaireId,
        logementId: logementId,
      );
      
      // 2. Envoyer une notification push au propriétaire
      await _notificationService.sendPushNotification(
        userId: proprietaireId,
        title: 'Nouveau message',
        body: 'Quelqu\'un s\'intéresse à votre logement "${widget.logement.titre}"',
        data: {
          'type': 'chat',
          'chatId': chatId,
          'logementId': logementId,
        },
      );
      
      // 3. Naviguer vers la page de chat
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            chatId: chatId,
            logement: widget.logement,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: Impossible de contacter le propriétaire')),
      );
      print('Error contacting owner: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Connexion requise'),
        content: Text('Vous devez être connecté pour contacter un propriétaire.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Naviguer vers la page de connexion
              Navigator.pushNamed(context, '/login');
            },
            child: Text('Se connecter'),
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