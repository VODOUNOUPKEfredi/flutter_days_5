import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:houeto/screens/navigation.dart';
import 'package:houeto/screens/sign.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final User? user = Auth().currentUser;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _motdepassController = TextEditingController();
  final _motdepassConfirController = TextEditingController();
  bool _isLoading = false;
  bool _forLogin = true;

  String _selectedRole = 'locataire';

  final List<String> _roles = ['propriétaire', 'gestionnaire', 'locataire'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text(_forLogin ? widget.title : "S'inscrire"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "Veuillez entrer votre email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email est obligatoire';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _motdepassController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: "Veuillez entrer votre mot de pass",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'mot de pass est obligatoire';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 10),
              if (!_forLogin)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    labelText: "Sélectionnez votre rôle",
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedRole,
                  items:
                      _roles
                          .map(
                            (role) => DropdownMenuItem(
                              value: role,
                              child: Text(
                                role[0].toUpperCase() + role.substring(1),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                ),
              if (!_forLogin) SizedBox(height: 10),
              if (!_forLogin)
                TextFormField(
                  controller: _motdepassConfirController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Veuillez confirmer votre mot de pass",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirmation est obligatoire';
                    } else if (value != _motdepassController.text) {
                      return 'mot de pass incorrect';
                    } else {
                      return null;
                    }
                  },
                ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(top: 30),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              if (_forLogin) {
                                // Appel de la méthode de connexion
                                await Auth().loginWithEmailAndPassword(
                                  _emailController.text,
                                  _motdepassController.text,
                                );
                              } else {
                                // Inscription de l'utilisateur
                                await Auth().createUserWithEmailAndPassword(
                                  _emailController.text,
                                  _motdepassController.text,
                                  role: _selectedRole,
                                );
                              }
                              
                              // Navigation directe vers HomePage
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NavBarRoots(),
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                _isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("${e.message}"),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.deepOrangeAccent,
                                  showCloseIcon: true,
                                ),
                              );
                            }
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(_forLogin ? "Se connecter" : "S'inscrire"),
                ),
              ),
            SizedBox(
                child: TextButton(
                  onPressed: () {
                    // Navigate to RegistrationPage when user clicks on sign up
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationPage(title: "Inscription"),
                      ),
                    );
                  },
                  child: Text(
                    "Je n'ai pas un compte, s'inscrire",
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

// Extension method to capitalize first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

// The Auth class remains the same as in the original code
class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Getter for current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Stream of authentication state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Login method
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // User registration method with role
  Future<void> createUserWithEmailAndPassword(
    String email,
    String password, {
    String role = 'locataire',
  }) async {
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Store additional user info in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Method to get user role
  Future<String> getUserRole() async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) return 'anonymous';

    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      return userDoc.exists ? userDoc.get('role') ?? 'locataire' : 'locataire';
    } catch (e) {
      print('Error fetching user role: $e');
      return 'locataire';
    }
  }

  // Method to update user role (if needed)
  Future<void> updateUserRole(String newRole) async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception('No authenticated user');
    }

    try {
      await _firestore.collection('users').doc(currentUser.uid).update({
        'role': newRole,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Sign out method
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Password reset method
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}