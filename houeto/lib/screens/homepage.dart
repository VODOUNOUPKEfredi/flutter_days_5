import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houeto/screens/property.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference logementsCollection = FirebaseFirestore.instance
      .collection('logements');

  int totalLogements = 0;
  int logementsDisponibles = 0;
  int logementsOccupes = 0;

  // List of default property images
  final List<String> defaultPropertyImages = [
    'assets/Appart1.jpg',
    ' assets/Appart2.jpg',
    'assets/Appart3.jpg'
        'assets/Appart4.jpg',
    'assets/Bout1.jpg',
    'assets/Bout2.jpg',
    'assets/Bout3.jpg',
    'assets/Bout4.jpp',
    'assets/Villa1.jpg',
    'assets/Villa2.jpg',
    'assets/Villa3.jpg',
    'assets/Villa4.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot totalSnapshot =
            await logementsCollection
                .where('idProprietaire', isEqualTo: user.uid)
                .get();

        QuerySnapshot disponiblesSnapshot =
            await logementsCollection
                .where('idProprietaire', isEqualTo: user.uid)
                .where('disponible', isEqualTo: true)
                .get();

        setState(() {
          totalLogements = totalSnapshot.size;
          logementsDisponibles = disponiblesSnapshot.size;
          logementsOccupes = totalLogements - logementsDisponibles;
        });
      }
    } catch (e) {
      print('Erreur chargement données: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       drawer: _buildAppDrawer(context),
      appBar: AppBar(
        title: Text('HOUETO'),
        actions: [
          IconButton(icon: Icon(Icons.person_outline), onPressed: () {}),
        ],
        backgroundColor: const Color.fromARGB(255, 129, 194, 248),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPublishButton(context),
               _buildMesBiensButton(context), // Nouveau bouton ajouté
              SizedBox(height: 20),
              SizedBox(height: 20),
              _buildStatsSection(),
              SizedBox(height: 20),
              _buildRecentLogements(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddLogement(context),
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        tooltip: 'Publier une annonce',
      ),
    );
  }

    // Nouvelle méthode ajoutée pour le bouton "Mes biens"
  Widget _buildMesBiensButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToPropertyPage(context),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.apartment, color: Colors.white),
            SizedBox(width: 10),
            Text('Mes biens', 
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // Nouvelle méthode de navigation ajoutée
  void _navigateToPropertyPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PropertyPage()),
    );
  }

  // Méthode pour construire le drawer de l'application
  Widget _buildAppDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 129, 194, 248),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 30, child: Icon(Icons.person, size: 40)),
                SizedBox(height: 10),
                Text(
                  'Jean',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text('jean@gmail.com', style: TextStyle(color: Colors.white70)),
              ],
            ),
          )
              ]
      )
          );
           }

  Widget _buildPublishButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToAddLogement(context),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_home, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Publier une annonce',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatCard('Total', totalLogements, Icons.home),
        _buildStatCard('Disponibles', logementsDisponibles, Icons.check_circle),
        _buildStatCard('Occupés', logementsOccupes, Icons.block),
      ],
    );
  }

  Widget _buildStatCard(String title, int value, IconData icon) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            SizedBox(height: 8),
            Text('$value', style: TextStyle(fontSize: 20)),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentLogements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Derniers ajouts', style: TextStyle(fontSize: 18)),
        StreamBuilder<QuerySnapshot>(
          stream:
              logementsCollection
                  .where(
                    'idProprietaire',
                    isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                  )
                  .orderBy('datePublication', descending: true)
                  .limit(3)
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            if (snapshot.data!.docs.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Aucune annonce publiée pour le moment'),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var logement = snapshot.data!.docs[index];
                List<dynamic> images = logement['images'] ?? [];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading:
                        images.isNotEmpty
                            ? Image.asset(
                              images[0],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.home,
                                    color: Colors.grey[600],
                                  ),
                                );
                              },
                            )
                            : Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                              child: Icon(Icons.home, color: Colors.grey[600]),
                            ),
                    title: Text(logement['titre'] ?? 'Sans titre'),
                    subtitle: Text(
                      '${logement['prixMensuel']}€ - ${logement['superficie']}m²',
                    ),
                    trailing: Chip(
                      label: Text(
                        logement['disponible'] ? 'Disponible' : 'Occupé',
                      ),
                      backgroundColor:
                          logement['disponible'] ? Colors.green : Colors.red,
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  void _navigateToAddLogement(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AddLogementPage(defaultImages: defaultPropertyImages),
      ),
    ).then((_) => _loadDashboardData());
  }
}

class AddLogementPage extends StatefulWidget {
  final List<String> defaultImages;

  AddLogementPage({this.defaultImages = const []});

  @override
  _AddLogementPageState createState() => _AddLogementPageState();
}

class _AddLogementPageState extends State<AddLogementPage> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  String _typeLogement = 'Appartements';
  final List<String> _typesLogement = ['Appartements', 'Villas', 'Boutiques'];

  TextEditingController _titreController = TextEditingController();
  TextEditingController _prixController = TextEditingController();
  TextEditingController _superficieController = TextEditingController();
  TextEditingController _piecesController = TextEditingController();
  TextEditingController _chambresController = TextEditingController();
  TextEditingController _sdbController = TextEditingController();
  TextEditingController _adresseController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  bool _meuble = false;
  bool _disponible = true;
  DateTime _dateDisponibilite = DateTime.now();
  List<String> _caracteristiques = [];

  // Variables modifiées pour la sélection d'images
  List<String> _selectedAssetImages = []; // Pour les images des assets
  List<XFile> _galleryImages = []; // Pour les images de la galerie
  bool _showAssetsTab = true; // Pour gérer l'onglet actif

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Publier une annonce')),
      body:
          _isLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Publication en cours...'),
                  ],
                ),
              )
              : Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    DropdownButtonFormField(
                      value: _typeLogement,
                      items:
                          _typesLogement
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (value) =>
                              setState(() => _typeLogement = value.toString()),
                      decoration: InputDecoration(
                        labelText: 'Type de logement',
                      ),
                    ),

                    _buildImageSelector(),

                    TextFormField(
                      controller: _titreController,
                      decoration: InputDecoration(labelText: 'Titre'),
                      validator: _validateRequired,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _prixController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Prix mensuel (FCFA)',
                            ),
                            validator: _validateNumber,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _superficieController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Superficie (m²)',
                            ),
                            validator: _validateNumber,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _piecesController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Nombre de pièces',
                            ),
                            validator: _validateNumber,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _chambresController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Chambres'),
                            validator: _validateNumber,
                          ),
                        ),
                      ],
                    ),

                    TextFormField(
                      controller: _sdbController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Salles de bain'),
                      validator: _validateNumber,
                    ),

                    TextFormField(
                      controller: _adresseController,
                      decoration: InputDecoration(
                        labelText: 'Adresse complète',
                      ),
                      validator: _validateRequired,
                    ),

                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                    ),

                    SwitchListTile(
                      title: Text('Meublé'),
                      value: _meuble,
                      onChanged: (v) => setState(() => _meuble = v),
                    ),

                    SwitchListTile(
                      title: Text('Disponible'),
                      value: _disponible,
                      onChanged: (v) => setState(() => _disponible = v),
                    ),

                    _buildDatePicker(),
                    _buildCaracteristiques(),

                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Publier l\'annonce'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildImageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(
          'Photos du logement',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),

        // Toggle entre images des assets et images de la galerie
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(Icons.photo_library),
                label: Text('Images prédéfinies'),
                onPressed: () => setState(() => _showAssetsTab = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _showAssetsTab ? Colors.blue : Colors.grey,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(Icons.photo_camera),
                label: Text('Galerie'),
                onPressed: () => setState(() => _showAssetsTab = false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: !_showAssetsTab ? Colors.blue : Colors.grey,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 16),

        // Sélection d'images prédéfinies (assets)
        if (_showAssetsTab) ...[
          Text('Sélectionnez des images prédéfinies:'),
          SizedBox(height: 8),
          widget.defaultImages.isEmpty
              ? Text(
                'Aucune image prédéfinie disponible',
                style: TextStyle(color: Colors.grey),
              )
              : Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    widget.defaultImages.map((imagePath) {
                      bool isSelected = _selectedAssetImages.contains(
                        imagePath,
                      );
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedAssetImages.remove(imagePath);
                            } else {
                              _selectedAssetImages.add(imagePath);
                            }
                          });
                        },
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected ? Colors.blue : Colors.grey,
                                  width: isSelected ? 3 : 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.asset(
                                  imagePath,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.grey[600],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                right: 5,
                                top: 5,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
          SizedBox(height: 16),
        ],

        // Sélection d'images depuis la galerie
        if (!_showAssetsTab) ...[
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add_photo_alternate),
                  label: Text('Importer des photos'),
                  onPressed: () async {
                    final images = await _picker.pickMultiImage();
                    if (images != null && images.isNotEmpty) {
                      setState(() => _galleryImages.addAll(images));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () async {
                  final image = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (image != null) {
                    setState(() => _galleryImages.add(image));
                  }
                },
                tooltip: 'Prendre une photo',
              ),
            ],
          ),
          SizedBox(height: 12),
          _galleryImages.isEmpty
              ? Text(
                'Aucune photo sélectionnée',
                style: TextStyle(color: Colors.grey),
              )
              : Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    _galleryImages
                        .map(
                          (image) => Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(image.path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.grey[600],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: GestureDetector(
                                  onTap:
                                      () => setState(
                                        () => _galleryImages.remove(image),
                                      ),
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
              ),
        ],

        SizedBox(height: 16),
        Text(
          'Images sélectionnées: ${_selectedAssetImages.length + _galleryImages.length}',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDatePicker() {
    return ListTile(
      title: Text(
        'Date de disponibilité: ${_dateDisponibilite.day}/${_dateDisponibilite.month}/${_dateDisponibilite.year}',
      ),
      trailing: Icon(Icons.calendar_today),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(DateTime.now().year + 1),
        );
        if (date != null) setState(() => _dateDisponibilite = date);
      },
    );
  }

  Widget _buildCaracteristiques() {
    final options = ['Balcon', 'Parking', 'Ascenseur', 'Jardin', 'Piscine'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(
          'Caractéristiques:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 8,
          children:
              options
                  .map(
                    (option) => FilterChip(
                      label: Text(option),
                      selected: _caracteristiques.contains(option),
                      selectedColor: Colors.blue.withOpacity(0.2),
                      checkmarkColor: Colors.blue,
                      onSelected:
                          (selected) => setState(() {
                            if (selected) {
                              _caracteristiques.add(option);
                            } else {
                              _caracteristiques.remove(option);
                            }
                          }),
                    ),
                  )
                  .toList(),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  String? _validateRequired(String? value) {
    return value?.isEmpty ?? true ? 'Champ obligatoire' : null;
  }

  String? _validateNumber(String? value) {
    if (value?.isEmpty ?? true) return 'Champ obligatoire';
    if (double.tryParse(value!) == null) return 'Nombre invalide';
    return null;
  }

  Future<String> _saveImageLocally(XFile image) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final savedImage = await File(image.path).copy('${appDir.path}/$fileName');
    return savedImage.path;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedAssetImages.isEmpty && _galleryImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veuillez sélectionner au moins une image')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final user = _auth.currentUser!;
        // Utiliser les images des assets
        List<String> images = List.from(_selectedAssetImages);

        // Sauvegarder les images de la galerie
        for (XFile image in _galleryImages) {
          String localPath = await _saveImageLocally(image);
          images.add(localPath);
        }

        // Ajouter le document à Firestore
        await _firestore.collection('logements').add({
          'idProprietaire': user.uid,
          'titre': _titreController.text,
          'typeLogement': _typeLogement,
          'prixMensuel': double.parse(_prixController.text),
          'superficie': double.parse(_superficieController.text),
          'nombrePieces': int.parse(_piecesController.text),
          'nombreChambres': int.parse(_chambresController.text),
          'nombreSallesBain': int.parse(_sdbController.text),
          'adresse': _adresseController.text,
          'description': _descriptionController.text,
          'meuble': _meuble,
          'disponible': _disponible,
          'datePublication': Timestamp.now(),
          'dateDisponibilite': Timestamp.fromDate(_dateDisponibilite),
          'caracteristiques': _caracteristiques,
          'images': images,
          'latitude': 0.0, // À implémenter avec géocodage
          'longitude': 0.0,
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Annonce publiée avec succès!')));

        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    }
  }
}
