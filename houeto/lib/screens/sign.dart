import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houeto/screens/navigation.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key, required this.title});
  final String title;

  @override
  State<RegistrationPage> createState() => _DetailedRegistrationPageState();
}

class _DetailedRegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _motdepassController = TextEditingController();
  final _motdepassConfirController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();

  bool _isLoading = false;
  String _selectedRole = 'propriétaire';

  final List<String> _roles = ['propriétaire', 'gestionnaire', 'locataire'];

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Numéro de téléphone est obligatoire';
    }
    final phoneRegex = RegExp(r'^[0-9]{8}$'); 
    if (!phoneRegex.hasMatch(value)) {
      return 'Numéro de téléphone invalide';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text("Inscrivez-vous"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Role dropdown remains at the top
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_circle),
                  labelText: "Rôle",
                  border: OutlineInputBorder(),
                ),
                value: _selectedRole,
                items: _roles
                    .map(
                      (role) => DropdownMenuItem(
                        value: role,
                        child: Text(role.capitalize()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
                validator: (value) {
                  if (value == null) return 'Veuillez sélectionner un rôle';
                  return null;
                },
              ),
              const SizedBox(height: 20), // Increased spacing
              Row(
                children: [
                  // Expanded to take full width and ensure visibility
                  Expanded(
                    child: TextFormField(
                      controller: _nomController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "Nom",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Nom est obligatoire'
                              : null,
                    ),
                  ),
                  const SizedBox(width: 10), // Space between fields
                  Expanded(
                    child: TextFormField(
                      controller: _prenomController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_outline),
                        labelText: "Prénom",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Prénom est obligatoire'
                              : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Increased spacing
              // Rest of the form remains the same
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Email est obligatoire';
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value)) return 'Email invalide';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _motdepassController,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: "Mot de passe",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Mot de passe est obligatoire';
                  if (value.length < 8) return 'Minimum 8 caractères';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _motdepassConfirController,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  labelText: "Confirmer le mot de passe",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Confirmation requise';
                  if (value != _motdepassController.text)
                    return 'Les mots de passe ne correspondent pas';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _telephoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  labelText: "Téléphone",
                  border: OutlineInputBorder(),
                ),
                validator: _validatePhone,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "S'inscrire",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    setState(() => _isLoading = true);
    try {
      final UserCredential userCredential = 
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _motdepassController.text,
      );

      // Vérification cruciale de l'UID
      if (userCredential.user?.uid == null) {
        throw FirebaseAuthException(
          code: 'user-creation-failed',
          message: 'Échec de la création du compte utilisateur',
        );
      }

      await _storeAdditionalUserDetails(userCredential.user!.uid);

      if (mounted) {
        Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => NavBarRoots()),
      (route) => false,
    );
      }

    } on FirebaseAuthException catch (e) {
      print('Erreur Auth: ${e.code} - ${e.message}');
      _showErrorSnackBar(_getAuthErrorMessage(e.code));
    } on FirebaseException catch (e) {
      print('Erreur Firestore: ${e.code} - ${e.message}');
      _showErrorSnackBar('Erreur base de données: ${e.message}');
    } catch (e, stackTrace) { 
      print('Erreur inattendue: $e');
      print('Stack trace complet: $stackTrace');
      _showErrorSnackBar('Erreur technique: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

Future<void> inscriptionProprietaire(String email, String password) async {
  try {
    // Créer l'utilisateur dans Firebase Authentication
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // Récupérer l'ID unique généré automatiquement
    String idProprietaire = userCredential.user!.uid;

    // Créer un document dans Firestore avec les informations du propriétaire
    await FirebaseFirestore.instance.collection('utilisateurs').doc(idProprietaire).set({
      'email': email,
      'role': 'proprietaire',
      'dateInscription': DateTime.now(),
      // Autres informations du propriétaire
    });

  } catch (e) {
    print('Erreur lors de l\'inscription : $e');
  }
}



Future<void> _storeAdditionalUserDetails(String uid) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'uid': uid,
      'nom': _nomController.text.trim(),
      'prenom': _prenomController.text.trim(),
      'telephone': _telephoneController.text.trim(),
      'role': _selectedRole,
      'email': _emailController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  } catch (e, stackTrace) {
    print('Erreur Firestore détaillée: $e');
    print('Stack trace: $stackTrace');
    throw Exception('Échec de l\'enregistrement des données utilisateur');
  }
}


String _getAuthErrorMessage(String code) {
  switch (code) {
    case 'email-already-in-use':
      return 'Cet email est déjà utilisé';
    case 'invalid-email':
      return 'Email invalide';
    case 'operation-not-allowed':
      return 'Opération non autorisée';
    case 'weak-password':
      return 'Mot de passe trop faible';
    default:
      return 'Erreur d\'authentification';
  }
}
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void checkFirebaseConfiguration() {
  try {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    print('Configuration Firebase OK');
    print('Auth instance: ${auth.app.name}');
    print('Firestore instance: ${firestore.app.name}');
  } catch (e) {
    print('ERREUR DE CONFIGURATION FIREBASE: $e');
  }
}

  @override
  void dispose() {
    _emailController.dispose();
    _motdepassController.dispose();
    _motdepassConfirController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
