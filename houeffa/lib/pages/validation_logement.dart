import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LogementValidationPage extends StatefulWidget {
  const LogementValidationPage({Key? key}) : super(key: key);

  @override
  _LogementValidationPageState createState() => _LogementValidationPageState();
}

class _LogementValidationPageState extends State<LogementValidationPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Contrôleurs pour les champs de texte
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _adresseLogementController = TextEditingController();
  
  // Variables pour les informations du logement
  bool _etatGeneral = false;
  bool _problemeElectricite = false;
  bool _problemePlomberie = false;
  bool _problemesChauffage = false;

  @override
  void dispose() {
    // Nettoyer les contrôleurs
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _adresseLogementController.dispose();
    super.dispose();
  }

  void _soumettreValidation() {
    if (_formKey.currentState!.validate()) {
      // Logique de soumission de validation
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Validation du Logement'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nom: ${_nomController.text}'),
                Text('Prénom: ${_prenomController.text}'),
                Text('Adresse du logement: ${_adresseLogementController.text}'),
                const SizedBox(height: 10),
                const Text('État du logement:', 
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('État général: ${_etatGeneral ? 'Bon' : 'À vérifier'}'),
                Text('Électricité: ${_problemeElectricite ? 'Problème détecté' : 'Bon état'}'),
                Text('Plomberie: ${_problemePlomberie ? 'Problème détecté' : 'Bon état'}'),
                Text('Chauffage: ${_problemesChauffage ? 'Problème détecté' : 'Bon état'}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Fermer'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validation de Logement'),
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Informations personnelles
              const Text(
                'Informations Personnelles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              
              // Champ Nom
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              
              // Champ Prénom
              TextFormField(
                controller: _prenomController,
                decoration: const InputDecoration(
                  labelText: 'Prénom',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre prénom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              
              // Champ Téléphone
              TextFormField(
                controller: _telephoneController,
                decoration: const InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre numéro de téléphone';
                  }
                  // Validation du format de téléphone (optionnel)
                  if (value.length < 10) {
                    return 'Numéro de téléphone invalide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              
              // Champ Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  }
                  // Validation simple de l'email
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Email invalide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Informations du Logement
              const Text(
                'Informations du Logement',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              
              // Champ Adresse du Logement
              TextFormField(
                controller: _adresseLogementController,
                decoration: const InputDecoration(
                  labelText: 'Adresse du Logement',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer l\'adresse du logement';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Sections de vérification de l'état du logement
              const Text(
                'État du Logement',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              // Cases à cocher pour les problèmes
              CheckboxListTile(
                title: const Text('État général du logement conforme'),
                value: _etatGeneral,
                onChanged: (bool? value) {
                  setState(() {
                    _etatGeneral = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Problèmes d\'électricité'),
                value: _problemeElectricite,
                onChanged: (bool? value) {
                  setState(() {
                    _problemeElectricite = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Problèmes de plomberie'),
                value: _problemePlomberie,
                onChanged: (bool? value) {
                  setState(() {
                    _problemePlomberie = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Problèmes de chauffage'),
                value: _problemesChauffage,
                onChanged: (bool? value) {
                  setState(() {
                    _problemesChauffage = value ?? false;
                  });
                },
              ),
              
              const SizedBox(height: 20),
              
              // Bouton de soumission
              ElevatedButton(
                onPressed: _soumettreValidation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Valider le Logement',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Exemple d'utilisation dans le main
void main() {
  runApp(MaterialApp(
    home: LogementValidationPage(),
  ));
}