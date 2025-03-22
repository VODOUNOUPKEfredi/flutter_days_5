import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum UserRole {
  admin,
  locataire,
  proprietaire,
  user,
}

class AuthService {
  //instance de firebaseAuth pour gerer l'authentification
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //instance de FirebaseFirestore pour accéder a la base de donée
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  //collection firestore pour les utilisateur 
  final String _usersCollection = 'users';

  //methode pour obtenir l'utilisateur actuel
  User? get currentUser => _auth.currentUser;

  //stream pour écouter les changements d'etat d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // methode pour créer un compte avec email et mot de passe 
  // enregistrer egalement les informations utilisateurs dans firestore
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
    String? phone,
    String? address,
  }) async {
    try {
      // Creation du compte utilisateur 
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );     
      // Mise à jour du profil pour ajouter le nom d'affichage
      await credential.user?.updateDisplayName(displayName);
      
      // Si l'utilisateur est créé avec succès 
      if (credential.user != null) {
        //creation du document utilisateur dans firestore
        await _firestore.collection(_usersCollection).doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'email': email,
          'displayName': displayName,
          'role': role.toString().split('.').last, //convertit l'enum en string
          'phone': phone ?? '',
          'address': address ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });
        debugPrint('Utilisateur créé avec le role: ${role.toString().split('.').last}');

        // rafraichir les données utilisateur
        await credential.user?.reload();
        return credential.user;
      }                          
      return null;
    } on FirebaseAuthException catch(e) {
      // Gestion des erreurs spécifiques à firebase auth
      String errorMessage = _handleAuthError(e);
      debugPrint(errorMessage);
      return null;
    } catch (e) {
      // Autres erreurs
      debugPrint("erreur lors de l\'inscription: $e");
      return null;
    }
  }

  // Methode pour se connecter avec email et mot de passe 
  // Retoune l'utilisateur connecté ou null en cas d'erreur 
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {  
      // Tentative de connexion 
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      // mise à jour de la date de derniere connexion 
      if (credential.user != null) {
        await _firestore.collection(_usersCollection).doc(credential.user!.uid).update({ 
          'lastLogin': FieldValue.serverTimestamp()
        });
      }
      return credential.user;
    } on FirebaseAuthException catch (e) {
      // Gestion des erreurs spécifiques à firebase auth
      String errorMessage = _handleAuthError(e);
      debugPrint(errorMessage);
      return null;
    } catch (e) {
      // Autres erreurs
      debugPrint("erreur lors de la connexion: $e");
      return null;
    }
  }
//methode getUserData
Future<Map<String, dynamic>?> getUserData(String uid) async {
  try {
    // Récupération du document utilisateur depuis Firestore
    DocumentSnapshot doc = await _firestore.collection(_usersCollection).doc(uid).get();
    
    if (doc.exists && doc.data() != null) {
      return doc.data() as Map<String, dynamic>;
    }
    return null;
  } catch (e) {
    debugPrint('Erreur lors de la récupération des données utilisateur: $e');
    return null;
  }
}
  //methode pour déconnecter l'utilisateur actuel 
  Future<void> signOut() async {
    try {
      //déconnection de l'utilisateur 
      await _auth.signOut();
      debugPrint('utlisateur déconnecté');
    } catch(e) {
      debugPrint('Erreur lors de la deconnexion: $e');
      rethrow;
    }
  }
  
  //methode pour réinitialiser le mot de passe 
  Future<void> resetPassword(String email) async {
    try {
      //envoi d'un mail de réinitialisation
      await _auth.sendPasswordResetEmail(email: email);
      debugPrint('Email de réinitialisation envoyé à: $email');
    } on FirebaseAuthException catch(e) {
      String errorMessage = _handleAuthError(e);
      debugPrint(errorMessage);
      rethrow;
    } catch(e) {
      //autre erreur 
      debugPrint('Erreur lors de la réinitialisation du mot de passe: $e');
      rethrow;
    }
  }
  
  //methode pour récupérer le role de l'utilisateur depuis firestore
  Future<UserRole> getUserRole(User user) async {
    try {
      //recupération du document utilisateur depuis Firestore
      DocumentSnapshot doc = await _firestore.collection(_usersCollection).doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        String roleStr = userData['role'] ?? 'locataire'; //par defaut, locataire

        //conversion de la chaine en enum
        switch (roleStr) {
          case 'admin': return UserRole.admin;
          case 'proprietaire': return UserRole.proprietaire;
          case 'locataire': return UserRole.locataire;
          case 'user': return UserRole.user;
          default: return UserRole.locataire;
        }
      }
      // par defaut si l'utilisateur n'a pas encore de role defini
      return UserRole.locataire;
    } catch (e) {
      debugPrint('Erreur lors de la récupération du role: $e');
      return UserRole.locataire;
    }
  }
  
  //methode pour mettre à jour le profil utilisateur 
  Future<bool> updateUserProfile({
    required String uid,
    String? displayName,
    String? phone,
    String? address,
    String? photoURL,
  }) async {
    try {
      Map<String, dynamic> updates = {};
      
      // Ajout des champs à mettre à jour (uniquement ceux qui sont fournis)
      if (displayName != null) updates['displayName'] = displayName;
      if (phone != null) updates['phone'] = phone;
      if (address != null) updates['address'] = address;
      if (photoURL != null) updates['photoURL'] = photoURL;
      
      // Ajouter un timestamp de mise à jour
      updates['updatedAt'] = FieldValue.serverTimestamp();
      
      // Mise à jour dans Firestore
      await _firestore.collection(_usersCollection).doc(uid).update(updates);
      
      // Mise à jour de la photo de profil si fournie
      User? currentUser = _auth.currentUser;
      if (photoURL != null && currentUser != null && currentUser.uid == uid) {
        await currentUser.updatePhotoURL(photoURL);
      }
      
      // Si vous arrivez ici sans erreur, tout s'est bien passé
      return true; // Retourner true en cas de succès
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour du profil: $e');
      return false; // Retourner false en cas d'échec
    }
  }
  
  // methode pour changer le rôle d'un utilisateur (réservée aux admins)
  Future<bool> changeUserRole({
    required String uid,
    required UserRole newRole,
  }) async {
    try {
      //Verification que l'utilisateur est bien admin
      if (currentUser != null) {
        UserRole currentUserRole = await getUserRole(currentUser!);
        if (currentUserRole != UserRole.admin) {
          debugPrint('Permission refusée: seuls les admins peuvent changer les roles');
          return false;
        }
        //mise à jour du rôle dans firestore
        await _firestore.collection(_usersCollection).doc(uid).update({
          'role': newRole.toString().split('.').last,
          'updatedAt': FieldValue.serverTimestamp(),
          'updateby': currentUser!.uid,
        });
        return true;
      }
      return false;
    } catch(e) {
      debugPrint('erreur lors du changement de role: $e');
      return false;
    }
  }
  
  // methode pour récupérer tous les utilisateurs (réservée aux admin)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      //verification que l'utilisateur actuel est bien admin
      if (currentUser != null) {
        UserRole currentUserRole = await getUserRole(currentUser!);
        if (currentUserRole != UserRole.admin) {
          debugPrint('Permission refusée: seuls les admins peuvent lister tous les utilisateurs');
          return [];
        }
        //recuperation de tous les utilisateurs
        QuerySnapshot querySnapshot = await _firestore.collection(_usersCollection).get();
        return querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          // ne pas inclure les informations sensibles
          data.remove('password');
          return data;
        }).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Erreur lors de la récupération des utilisateurs: $e');
      return [];
    }
  }
  
  // methode privé pour gérer les erreurs d'authentification firebase
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé par un autre compte.';
      case 'invalid-email':
        return 'L\'adresse email n\'est pas valide.';
      case 'weak-password':
        return 'Le mot de passe est trop faible.';
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cet email.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'too-many-requests':
        return 'Trop de tentatives. Veuillez réessayer plus tard.';
      default:
        return 'Une erreur s\'est produite: ${e.message}';
    }
  }
}