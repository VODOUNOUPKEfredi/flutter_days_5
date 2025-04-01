
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// enum UserRole {
//   admin,
//   locataire,
//   proprietaire,
//   user,
// }

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String _usersCollection = 'users';
//    final GoogleSignIn _googleSignIn = GoogleSignIn(
//     clientId: '508280862192-odp1c720ajij2be1mtoqipe9jsaparsv.apps.googleusercontent.com',
//   );

//   User? get currentUser => _auth.currentUser;
//   Stream<User?> get authStateChanges => _auth.authStateChanges();

//   // Sign up with email and password
//   Future<User?> signUpWithEmailAndPassword({
//     required String email,
//     required String password,
//     required String displayName,
//     required UserRole role,
//     String? phone,
//     String? address,
//   }) async {
//     try {
//       UserCredential credential = await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       await credential.user?.updateDisplayName(displayName);
//       if (credential.user != null) {
//         await _firestore.collection(_usersCollection).doc(credential.user!.uid).set({
//           'uid': credential.user!.uid,
//           'email': email,
//           'displayName': displayName,
//           'role': role.toString().split('.').last,
//           'phone': phone ?? '',
//           'address': address ?? '',
//           'createdAt': FieldValue.serverTimestamp(),
//           'lastLogin': FieldValue.serverTimestamp(),
//         });
//         await credential.user?.reload();
//         return credential.user;
//       }
//       return null;
//     } catch (e) {
//       debugPrint("Erreur lors de l'inscription: $e");
//       return null;
//     }
//   }

// Future<Map<String, dynamic>?> getUserData(String uid) async {
//     try {
//       DocumentSnapshot doc = await _firestore.collection(_usersCollection).doc(uid).get();
//       return doc.exists ? doc.data() as Map<String, dynamic> : null;
//     } catch (e) {
//       debugPrint('Erreur lors de la récupération des données utilisateur: $e');
//       return null;
//     }
//   }
//   // Sign in with email and password
//   Future<User?> signInWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       UserCredential credential = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       if (credential.user != null) {
//         await _firestore.collection(_usersCollection).doc(credential.user!.uid).update({
//           'lastLogin': FieldValue.serverTimestamp()
//         });
//       }
//       return credential.user;
//     } catch (e) {
//       debugPrint("Erreur lors de la connexion: $e");
//       return null;
//     }
//   }

//   // Sign in with Google
//   Future<User?> signInWithGoogle() async {
//     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//     if (googleUser == null) return null;

//     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );

//     UserCredential result = await FirebaseAuth.instance.signInWithCredential(credential);

//     if (result.additionalUserInfo!.isNewUser) {
//       await _addGoogleUser(result.user!, googleUser);
//     }

//     return result.user;
//   }

//   // Add a new Google user to Firestore
//   Future<void> _addGoogleUser(User user, GoogleSignInAccount googleUser) async {
//     try {
//       await _firestore.collection(_usersCollection).doc(user.uid).set({
//         'uid': user.uid,
//         'email': user.email,
//         'displayName': user.displayName,
//         'role': UserRole.user.toString().split('.').last,
//         'phone': '',
//         'address': '',
//         'createdAt': FieldValue.serverTimestamp(),
//         'lastLogin': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       debugPrint("Erreur lors de l'ajout d'un utilisateur Google: $e");
//     }
//   }

//   // Sign out
//   Future<void> signOut() async {
//     try {
//       await _auth.signOut();
//       debugPrint('Utilisateur déconnecté');
//     } catch (e) {
//       debugPrint('Erreur lors de la déconnexion: $e');
//       rethrow;
//     }
//   }

//   // Reset password
//   Future<void> resetPassword(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//       debugPrint('Email de réinitialisation envoyé à: $email');
//     } catch (e) {
//       debugPrint('Erreur lors de la réinitialisation du mot de passe: $e');
//       rethrow;
//     }
//   }

//   // Get user role from Firestore
//   Future<UserRole> getUserRole(User user) async {
//     try {
//       DocumentSnapshot doc = await _firestore.collection(_usersCollection).doc(user.uid).get();
//       if (doc.exists && doc.data() != null) {
//         Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
//         String roleStr = userData['role'] ?? 'locataire';

//         switch (roleStr) {
//           case 'admin': return UserRole.admin;
//           case 'proprietaire': return UserRole.proprietaire;
//           case 'locataire': return UserRole.locataire;
//           case 'user': return UserRole.user;
//           default: return UserRole.locataire;
//         }
//       }
//       return UserRole.locataire;
//     } catch (e) {
//       debugPrint('Erreur lors de la récupération du rôle: $e');
//       return UserRole.locataire;
//     }
//   }

//   // Update user profile
//   Future<bool> updateUserProfile({
//     required String uid,
//     String? displayName,
//     String? phone,
//     String? address,
//     String? photoURL,
//   }) async {
//     try {
//       Map<String, dynamic> updates = {};

//       if (displayName != null) updates['displayName'] = displayName;
//       if (phone != null) updates['phone'] = phone;
//       if (address != null) updates['address'] = address;
//       if (photoURL != null) updates['photoURL'] = photoURL;

//       updates['updatedAt'] = FieldValue.serverTimestamp();

//       await _firestore.collection(_usersCollection).doc(uid).update(updates);

//       User? currentUser = _auth.currentUser;
//       if (photoURL != null && currentUser != null && currentUser.uid == uid) {
//         await currentUser.updatePhotoURL(photoURL);
//       }

//       return true;
//     } catch (e) {
//       debugPrint('Erreur lors de la mise à jour du profil: $e');
//       return false;
//     }
//   }

//   // Change user role (Admin only)
//   Future<bool> changeUserRole({
//     required String uid,
//     required UserRole newRole,
//   }) async {
//     try {
//       if (currentUser != null) {
//         UserRole currentUserRole = await getUserRole(currentUser!);
//         if (currentUserRole != UserRole.admin) {
//           debugPrint('Permission refusée: seuls les admins peuvent changer les rôles');
//           return false;
//         }
//         await _firestore.collection(_usersCollection).doc(uid).update({
//           'role': newRole.toString().split('.').last,
//           'updatedAt': FieldValue.serverTimestamp(),
//           'updateby': currentUser!.uid,
//         });
//         return true;
//       }
//       return false;
//     } catch (e) {
//       debugPrint('Erreur lors du changement de rôle: $e');
//       return false;
//     }
//   }

//   // Get all users (Admin only)
//   Future<List<Map<String, dynamic>>> getAllUsers() async {
//     try {
//       if (currentUser != null) {
//         UserRole currentUserRole = await getUserRole(currentUser!);
//         if (currentUserRole != UserRole.admin) {
//           debugPrint('Permission refusée: seuls les admins peuvent lister tous les utilisateurs');
//           return [];
//         }
//         QuerySnapshot querySnapshot = await _firestore.collection(_usersCollection).get();
//         return querySnapshot.docs.map((doc) {
//           Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//           data.remove('password');
//           return data;
//         }).toList();
//       }
//       return [];
//     } catch (e) {
//       debugPrint('Erreur lors de la récupération des utilisateurs: $e');
//       return [];
//     }
//   }

//   // Handle Firebase auth errors
//   String _handleAuthError(FirebaseAuthException e) {
//     switch (e.code) {
//       case 'email-already-in-use':
//         return 'Cet email est déjà utilisé par un autre compte.';
//       case 'invalid-email':
//         return 'L\'adresse email n\'est pas valide.';
//       case 'weak-password':
//         return 'Le mot de passe est trop faible.';
//       case 'user-not-found':
//         return 'Aucun utilisateur trouvé avec cet email.';
//       case 'wrong-password':
//         return 'Mot de passe incorrect.';
//       case 'too-many-requests':
//         return 'Trop de tentatives. Veuillez réessayer plus tard.';
//       default:
//         return 'Une erreur s\'est produite: ${e.message}';
//     }
//   }
// }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// enum UserRole {
//   admin,
//   locataire,
//   proprietaire,
//   user,
// }

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     clientId: '508280862192-odp1c720ajij2be1mtoqipe9jsaparsv.apps.googleusercontent.com',
//   );

//   final String _usersCollection = 'users';

//   User? get currentUser => _auth.currentUser;
//   Stream<User?> get authStateChanges => _auth.authStateChanges();

//   // Sign up with email and password
//   Future<User?> signUpWithEmailAndPassword({
//     required String email,
//     required String password,
//     required String displayName,
//     required UserRole role,
//     String? phone,
//     String? address,
//   }) async {
//     try {
//       UserCredential credential = await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       await credential.user?.updateDisplayName(displayName);
      
//       if (credential.user != null) {
//         await _firestore.collection(_usersCollection).doc(credential.user!.uid).set({
//           'uid': credential.user!.uid,
//           'email': email,
//           'displayName': displayName,
//           'role': role.toString().split('.').last,
//           'phone': phone ?? '',
//           'address': address ?? '',
//           'createdAt': FieldValue.serverTimestamp(),
//           'lastLogin': FieldValue.serverTimestamp(),
//         });
        
//         await credential.user?.reload();
//         return credential.user;
//       }
//       return null;
//     } catch (e) {
//       debugPrint("Erreur lors de l'inscription: $e");
//       return null;
//     }
//   }

//   // Sign in with email and password
//   Future<User?> signInWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       UserCredential credential = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
      
//       if (credential.user != null) {
//         await _firestore.collection(_usersCollection).doc(credential.user!.uid).update({
//           'lastLogin': FieldValue.serverTimestamp()
//         });
//       }
      
//       return credential.user;
//     } catch (e) {
//       debugPrint("Erreur lors de la connexion: $e");
//       return null;
//     }
//   }

//   // Google Sign-In
//   Future<User?> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) return null;

//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final UserCredential userCredential = 
//           await _auth.signInWithCredential(credential);
//       final User? user = userCredential.user;

//       if (user != null) {
//         // Vérifier si c'est un nouvel utilisateur
//         if (userCredential.additionalUserInfo?.isNewUser ?? false) {
//           await _createUserInFirestore(user);
//         } else {
//           // Mettre à jour la dernière connexion pour un utilisateur existant
//           await _updateLastLogin(user);
//         }

//         return user;
//       }

//       return null;
//     } catch (e) {
//       debugPrint('Erreur de connexion Google : $e');
//       return null;
//     }
//   }

//   // Création d'un utilisateur dans Firestore après connexion Google
//   Future<void> _createUserInFirestore(User user) async {
//     try {
//       await _firestore.collection(_usersCollection).doc(user.uid).set({
//         'uid': user.uid,
//         'email': user.email,
//         'displayName': user.displayName ?? '',
//         'photoURL': user.photoURL ?? '',
//         'role': UserRole.user.toString().split('.').last,
//         'phone': '',
//         'address': '',
//         'createdAt': FieldValue.serverTimestamp(),
//         'lastLogin': FieldValue.serverTimestamp(),
//       }, SetOptions(merge: true));
//     } catch (e) {
//       debugPrint('Erreur lors de la création de l\'utilisateur : $e');
//     }
//   }

//   // Mise à jour de la dernière connexion
//   Future<void> _updateLastLogin(User user) async {
//     try {
//       await _firestore.collection(_usersCollection).doc(user.uid).update({
//         'lastLogin': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       debugPrint('Erreur lors de la mise à jour de la dernière connexion : $e');
//     }
//   }

//   // Récupérer les données utilisateur
//   Future<Map<String, dynamic>?> getUserData(String uid) async {
//     try {
//       DocumentSnapshot doc = await _firestore.collection(_usersCollection).doc(uid).get();
//       return doc.exists ? doc.data() as Map<String, dynamic> : null;
//     } catch (e) {
//       debugPrint('Erreur lors de la récupération des données utilisateur: $e');
//       return null;
//     }
//   }

//   // Déconnexion
//   Future<void> signOut() async {
//     try {
//       await _auth.signOut();
//       await _googleSignIn.signOut();
//       debugPrint('Utilisateur déconnecté');
//     } catch (e) {
//       debugPrint('Erreur lors de la déconnexion : $e');
//     }
//   }

//   // Réinitialisation du mot de passe
//   Future<void> resetPassword(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//       debugPrint('Email de réinitialisation envoyé à: $email');
//     } catch (e) {
//       debugPrint('Erreur lors de la réinitialisation du mot de passe: $e');
//       rethrow;
//     }
//   }

//   // Obtenir le rôle de l'utilisateur
//   Future<UserRole> getUserRole(User user) async {
//     try {
//       DocumentSnapshot doc = await _firestore.collection(_usersCollection).doc(user.uid).get();
//       if (doc.exists && doc.data() != null) {
//         Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
//         String roleStr = userData['role'] ?? 'locataire';

//         switch (roleStr) {
//           case 'admin': return UserRole.admin;
//           case 'proprietaire': return UserRole.proprietaire;
//           case 'locataire': return UserRole.locataire;
//           case 'user': return UserRole.user;
//           default: return UserRole.locataire;
//         }
//       }
//       return UserRole.locataire;
//     } catch (e) {
//       debugPrint('Erreur lors de la récupération du rôle: $e');
//       return UserRole.locataire;
//     }
//   }

//   // Mettre à jour le profil utilisateur
//   Future<bool> updateUserProfile({
//     required String uid,
//     String? displayName,
//     String? phone,
//     String? address,
//     String? photoURL,
//   }) async {
//     try {
//       Map<String, dynamic> updates = {};

//       if (displayName != null) updates['displayName'] = displayName;
//       if (phone != null) updates['phone'] = phone;
//       if (address != null) updates['address'] = address;
//       if (photoURL != null) updates['photoURL'] = photoURL;

//       updates['updatedAt'] = FieldValue.serverTimestamp();

//       await _firestore.collection(_usersCollection).doc(uid).update(updates);

//       User? currentUser = _auth.currentUser;
//       if (photoURL != null && currentUser != null && currentUser.uid == uid) {
//         await currentUser.updatePhotoURL(photoURL);
//       }

//       return true;
//     } catch (e) {
//       debugPrint('Erreur lors de la mise à jour du profil: $e');
//       return false;
//     }
//   }

//   // Changer le rôle d'un utilisateur (Admin only)
//   Future<bool> changeUserRole({
//     required String uid,
//     required UserRole newRole,
//   }) async {
//     try {
//       if (currentUser != null) {
//         UserRole currentUserRole = await getUserRole(currentUser!);
//         if (currentUserRole != UserRole.admin) {
//           debugPrint('Permission refusée: seuls les admins peuvent changer les rôles');
//           return false;
//         }
//         await _firestore.collection(_usersCollection).doc(uid).update({
//           'role': newRole.toString().split('.').last,
//           'updatedAt': FieldValue.serverTimestamp(),
//           'updateby': currentUser!.uid,
//         });
//         return true;
//       }
//       return false;
//     } catch (e) {
//       debugPrint('Erreur lors du changement de rôle: $e');
//       return false;
//     }
//   }

//   // Obtenir tous les utilisateurs (Admin only)
//   Future<List<Map<String, dynamic>>> getAllUsers() async {
//     try {
//       if (currentUser != null) {
//         UserRole currentUserRole = await getUserRole(currentUser!);
//         if (currentUserRole != UserRole.admin) {
//           debugPrint('Permission refusée: seuls les admins peuvent lister tous les utilisateurs');
//           return [];
//         }
//         QuerySnapshot querySnapshot = await _firestore.collection(_usersCollection).get();
//         return querySnapshot.docs.map((doc) {
//           Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//           data.remove('password');
//           return data;
//         }).toList();
//       }
//       return [];
//     } catch (e) {
//       debugPrint('Erreur lors de la récupération des utilisateurs: $e');
//       return [];
//     }
//   }

//   // Gestion des erreurs d'authentification
//   String _handleAuthError(FirebaseAuthException e) {
//     switch (e.code) {
//       case 'email-already-in-use':
//         return 'Cet email est déjà utilisé par un autre compte.';
//       case 'invalid-email':
//         return 'L\'adresse email n\'est pas valide.';
//       case 'weak-password':
//         return 'Le mot de passe est trop faible.';
//       case 'user-not-found':
//         return 'Aucun utilisateur trouvé avec cet email.';
//       case 'wrong-password':
//         return 'Mot de passe incorrect.';
//       case 'too-many-requests':
//         return 'Trop de tentatives. Veuillez réessayer plus tard.';
//       default:
//         return 'Une erreur s\'est produite: ${e.message}';
//     }
//   }
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// enum UserRole {
//   admin,
//   locataire,
//   proprietaire,
//   user,
// }

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     clientId: '508280862192-odp1c720ajij2be1mtoqipe9jsaparsv.apps.googleusercontent.com',
//   );

//   final String _usersCollection = 'users';

//   User? get currentUser => _auth.currentUser;
//   Stream<User?> get authStateChanges => _auth.authStateChanges();

//   // Vérifier si l'utilisateur est connecté
//   bool isUserLoggedIn() {
//     return _auth.currentUser != null;
//   }

//   // Récupérer l'utilisateur actuel
//   User? getCurrentUser() {
//     return _auth.currentUser;
//   }

//   // Connexion anonyme
//   Future<User?> signInAnonymously() async {
//     try {
//       UserCredential credential = await _auth.signInAnonymously();
//       return credential.user;
//     } catch (e) {
//       debugPrint("Erreur lors de la connexion anonyme: $e");
//       return null;
//     }
//   }

//   // Sign up with email and password
//   Future<User?> signUpWithEmailAndPassword({
//     required String email,
//     required String password,
//     required String displayName,
//     required UserRole role,
//     String? phone,
//     String? address,
//   }) async {
//     try {
//       UserCredential credential = await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       await credential.user?.updateDisplayName(displayName);
      
//       if (credential.user != null) {
//         await _firestore.collection(_usersCollection).doc(credential.user!.uid).set({
//           'uid': credential.user!.uid,
//           'email': email,
//           'displayName': displayName,
//           'role': role.toString().split('.').last,
//           'phone': phone ?? '',
//           'address': address ?? '',
//           'createdAt': FieldValue.serverTimestamp(),
//           'lastLogin': FieldValue.serverTimestamp(),
//         });
        
//         await credential.user?.reload();
//         return credential.user;
//       }
//       return null;
//     } catch (e) {
//       debugPrint("Erreur lors de l'inscription: $e");
//       return null;
//     }
//   }

//   // Sign in with email and password
//   Future<User?> signInWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       UserCredential credential = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
      
//       if (credential.user != null) {
//         await _firestore.collection(_usersCollection).doc(credential.user!.uid).update({
//           'lastLogin': FieldValue.serverTimestamp()
//         });
//       }
      
//       return credential.user;
//     } catch (e) {
//       debugPrint("Erreur lors de la connexion: $e");
//       return null;
//     }
//   }

//   // Google Sign-In
//   Future<User?> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) return null;

//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final UserCredential userCredential = 
//           await _auth.signInWithCredential(credential);
//       final User? user = userCredential.user;

//       if (user != null) {
//         // Vérifier si c'est un nouvel utilisateur
//         if (userCredential.additionalUserInfo?.isNewUser ?? false) {
//           await _createUserInFirestore(user);
//         } else {
//           // Mettre à jour la dernière connexion pour un utilisateur existant
//           await _updateLastLogin(user);
//         }

//         return user;
//       }

//       return null;
//     } catch (e) {
//       debugPrint('Erreur de connexion Google : $e');
//       return null;
//     }
//   }

//   // Création d'un utilisateur dans Firestore après connexion Google
//   Future<void> _createUserInFirestore(User user) async {
//     try {
//       await _firestore.collection(_usersCollection).doc(user.uid).set({
//         'uid': user.uid,
//         'email': user.email,
//         'displayName': user.displayName ?? '',
//         'photoURL': user.photoURL ?? '',
//         'role': UserRole.user.toString().split('.').last,
//         'phone': '',
//         'address': '',
//         'createdAt': FieldValue.serverTimestamp(),
//         'lastLogin': FieldValue.serverTimestamp(),
//       }, SetOptions(merge: true));
//     } catch (e) {
//       debugPrint('Erreur lors de la création de l\'utilisateur : $e');
//     }
//   }

//   // Mise à jour de la dernière connexion
//   Future<void> _updateLastLogin(User user) async {
//     try {
//       await _firestore.collection(_usersCollection).doc(user.uid).update({
//         'lastLogin': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       debugPrint('Erreur lors de la mise à jour de la dernière connexion : $e');
//     }
//   }

//   // Récupérer les données utilisateur
//   Future<Map<String, dynamic>?> getUserData(String uid) async {
//     try {
//       DocumentSnapshot doc = await _firestore.collection(_usersCollection).doc(uid).get();
//       return doc.exists ? doc.data() as Map<String, dynamic> : null;
//     } catch (e) {
//       debugPrint('Erreur lors de la récupération des données utilisateur: $e');
//       return null;
//     }
//   }

//   // Déconnexion
//   Future<void> signOut() async {
//     try {
//       await _auth.signOut();
//       await _googleSignIn.signOut();
//       debugPrint('Utilisateur déconnecté');
//     } catch (e) {
//       debugPrint('Erreur lors de la déconnexion : $e');
//     }
//   }

//   // Réinitialisation du mot de passe
//   Future<void> resetPassword(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//       debugPrint('Email de réinitialisation envoyé à: $email');
//     } catch (e) {
//       debugPrint('Erreur lors de la réinitialisation du mot de passe: $e');
//       rethrow;
//     }
//   }

//   // Obtenir le rôle de l'utilisateur
//   Future<UserRole> getUserRole(User user) async {
//     try {
//       DocumentSnapshot doc = await _firestore.collection(_usersCollection).doc(user.uid).get();
//       if (doc.exists && doc.data() != null) {
//         Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
//         String roleStr = userData['role'] ?? 'locataire';

//         switch (roleStr) {
//           case 'admin': return UserRole.admin;
//           case 'proprietaire': return UserRole.proprietaire;
//           case 'locataire': return UserRole.locataire;
//           case 'user': return UserRole.user;
//           default: return UserRole.locataire;
//         }
//       }
//       return UserRole.locataire;
//     } catch (e) {
//       debugPrint('Erreur lors de la récupération du rôle: $e');
//       return UserRole.locataire;
//     }
//   }

//   // Mettre à jour le profil utilisateur
//   Future<bool> updateUserProfile({
//     required String uid,
//     String? displayName,
//     String? phone,
//     String? address,
//     String? photoURL,
//   }) async {
//     try {
//       Map<String, dynamic> updates = {};

//       if (displayName != null) updates['displayName'] = displayName;
//       if (phone != null) updates['phone'] = phone;
//       if (address != null) updates['address'] = address;
//       if (photoURL != null) updates['photoURL'] = photoURL;

//       updates['updatedAt'] = FieldValue.serverTimestamp();

//       await _firestore.collection(_usersCollection).doc(uid).update(updates);

//       User? currentUser = _auth.currentUser;
//       if (photoURL != null && currentUser != null && currentUser.uid == uid) {
//         await currentUser.updatePhotoURL(photoURL);
//       }

//       return true;
//     } catch (e) {
//       debugPrint('Erreur lors de la mise à jour du profil: $e');
//       return false;
//     }
//   }

//   // Changer le rôle d'un utilisateur (Admin only)
//   Future<bool> changeUserRole({
//     required String uid,
//     required UserRole newRole,
//   }) async {
//     try {
//       if (currentUser != null) {
//         UserRole currentUserRole = await getUserRole(currentUser!);
//         if (currentUserRole != UserRole.admin) {
//           debugPrint('Permission refusée: seuls les admins peuvent changer les rôles');
//           return false;
//         }
//         await _firestore.collection(_usersCollection).doc(uid).update({
//           'role': newRole.toString().split('.').last,
//           'updatedAt': FieldValue.serverTimestamp(),
//           'updateby': currentUser!.uid,
//         });
//         return true;
//       }
//       return false;
//     } catch (e) {
//       debugPrint('Erreur lors du changement de rôle: $e');
//       return false;
//     }
//   }

//   // Obtenir tous les utilisateurs (Admin only)
//   Future<List<Map<String, dynamic>>> getAllUsers() async {
//     try {
//       if (currentUser != null) {
//         UserRole currentUserRole = await getUserRole(currentUser!);
//         if (currentUserRole != UserRole.admin) {
//           debugPrint('Permission refusée: seuls les admins peuvent lister tous les utilisateurs');
//           return [];
//         }
//         QuerySnapshot querySnapshot = await _firestore.collection(_usersCollection).get();
//         return querySnapshot.docs.map((doc) {
//           Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//           data.remove('password');
//           return data;
//         }).toList();
//       }
//       return [];
//     } catch (e) {
//       debugPrint('Erreur lors de la récupération des utilisateurs: $e');
//       return [];
//     }
//   }

//   // Gestion des erreurs d'authentification
//   String _handleAuthError(FirebaseAuthException e) {
//     switch (e.code) {
//       case 'email-already-in-use':
//         return 'Cet email est déjà utilisé par un autre compte.';
//       case 'invalid-email':
//         return 'L\'adresse email n\'est pas valide.';
//       case 'weak-password':
//         return 'Le mot de passe est trop faible.';
//       case 'user-not-found':
//         return 'Aucun utilisateur trouvé avec cet email.';
//       case 'wrong-password':
//         return 'Mot de passe incorrect.';
//       case 'too-many-requests':
//         return 'Trop de tentatives. Veuillez réessayer plus tard.';
//       default:
//         return 'Une erreur s\'est produite: ${e.message}';
//     }
//   }
// }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// enum UserRole {
//   admin,
//   locataire,
//   proprietaire,
//   user,
// }

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     clientId: '508280862192-odp1c720ajij2be1mtoqipe9jsaparsv.apps.googleusercontent.com',
//   );

//   final String _usersCollection = 'users';

//   User? get currentUser => _auth.currentUser;
//   Stream<User?> get authStateChanges => _auth.authStateChanges();

//   // Vérifier si l'utilisateur est connecté
//   bool isUserLoggedIn() {
//     return _auth.currentUser != null;
//   }

//   // Récupérer l'utilisateur actuel
//   User? getCurrentUser() {
//     return _auth.currentUser;
//   }

//   // Connexion anonyme
//   Future<User?> signInAnonymously() async {
//     try {
//       UserCredential credential = await _auth.signInAnonymously();
//       return credential.user;
//     } catch (e) {
//       debugPrint("Erreur lors de la connexion anonyme: $e");
//       return null;
//     }
//   }

//   // Sign up with email and password
//   Future<User?> signUpWithEmailAndPassword({
//     required String email,
//     required String password,
//     required String displayName,
//     required UserRole role,
//     String? phone,
//     String? address,
//   }) async {
//     try {
//       UserCredential credential = await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       await credential.user?.updateDisplayName(displayName);
      
//       if (credential.user != null) {
//         await _firestore.collection(_usersCollection).doc(credential.user!.uid).set({
//           'uid': credential.user!.uid,
//           'email': email,
//           'displayName': displayName,
//           'role': role.toString().split('.').last,
//           'phone': phone ?? '',
//           'address': address ?? '',
//           'createdAt': FieldValue.serverTimestamp(),
//           'lastLogin': FieldValue.serverTimestamp(),
//         });
        
//         await credential.user?.reload();
//         return credential.user;
//       }
//       return null;
//     } catch (e) {
//       debugPrint("Erreur lors de l'inscription: $e");
//       return null;
//     }
//   }

//   // Sign in with email and password
//   Future<User?> signInWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       UserCredential credential = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
      
//       if (credential.user != null) {
//         await _firestore.collection(_usersCollection).doc(credential.user!.uid).update({
//           'lastLogin': FieldValue.serverTimestamp()
//         });
//       }
      
//       return credential.user;
//     } catch (e) {
//       debugPrint("Erreur lors de la connexion: $e");
//       return null;
//     }
//   }

//   // Google Sign-In
//   Future<User?> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) return null;

//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final UserCredential userCredential = 
//           await _auth.signInWithCredential(credential);
//       final User? user = userCredential.user;

//       if (user != null) {
//         // Vérifier si c'est un nouvel utilisateur
//         if (userCredential.additionalUserInfo?.isNewUser ?? false) {
//           await _createUserInFirestore(user);
//         } else {
//           // Mettre à jour la dernière connexion pour un utilisateur existant
//           await _updateLastLogin(user);
//         }

//         return user;
//       }

//       return null;
//     } catch (e) {
//       debugPrint('Erreur de connexion Google : $e');
//       return null;
//     }
//   }

//   // Création d'un utilisateur dans Firestore après connexion Google
//   Future<void> _createUserInFirestore(User user) async {
//     try {
//       await _firestore.collection(_usersCollection).doc(user.uid).set({
//         'uid': user.uid,
//         'email': user.email,
//         'displayName': user.displayName ?? '',
//         'photoURL': user.photoURL ?? '',
//         'role': UserRole.user.toString().split('.').last,
//         'phone': '',
//         'address': '',
//         'createdAt': FieldValue.serverTimestamp(),
//         'lastLogin': FieldValue.serverTimestamp(),
//       }, SetOptions(merge: true));
//     } catch (e) {
//       debugPrint('Erreur lors de la création de l\'utilisateur : $e');
//     }
//   }

//   // Mise à jour de la dernière connexion
//   Future<void> _updateLastLogin(User user) async {
//     try {
//       await _firestore.collection(_usersCollection).doc(user.uid).update({
//         'lastLogin': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       debugPrint('Erreur lors de la mise à jour de la dernière connexion : $e');
//     }
//   }

//   // Récupérer les données utilisateur
//   Future<Map<String, dynamic>?> getUserData(String uid) async {
//     try {
//       DocumentSnapshot doc = await _firestore.collection(_usersCollection).doc(uid).get();
//       return doc.exists ? doc.data() as Map<String, dynamic> : null;
//     } catch (e) {
//       debugPrint('Erreur lors de la récupération des données utilisateur: $e');
//       return null;
//     }
//   }

//   // Déconnexion
//   Future<void> signOut() async {
//     try {
//       await _auth.signOut();
//       await _googleSignIn.signOut();
//       debugPrint('Utilisateur déconnecté');
//     } catch (e) {
//       debugPrint('Erreur lors de la déconnexion : $e');
//     }
//   }

//   // Réinitialisation du mot de passe
//   Future<void> resetPassword(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//       debugPrint('Email de réinitialisation envoyé à: $email');
//     } catch (e) {
//       debugPrint('Erreur lors de la réinitialisation du mot de passe: $e');
//       rethrow;
//     }
//   }

//   // Obtenir le rôle de l'utilisateur
//   Future<UserRole> getUserRole(User user) async {
//     try {
//       DocumentSnapshot doc = await _firestore.collection(_usersCollection).doc(user.uid).get();
//       if (doc.exists && doc.data() != null) {
//         Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
//         String roleStr = userData['role'] ?? 'locataire';

//         switch (roleStr) {
//           case 'admin': return UserRole.admin;
//           case 'proprietaire': return UserRole.proprietaire;
//           case 'locataire': return UserRole.locataire;
//           case 'user': return UserRole.user;
//           default: return UserRole.locataire;
//         }
//       }
//       return UserRole.locataire;
//     } catch (e) {
//       debugPrint('Erreur lors de la récupération du rôle: $e');
//       return UserRole.locataire;
//     }
//   }

//   // Mettre à jour le profil utilisateur
//   Future<bool> updateUserProfile({
//     required String uid,
//     String? displayName,
//     String? phone,
//     String? address,
//     String? photoURL,
//   }) async {
//     try {
//       Map<String, dynamic> updates = {};

//       if (displayName != null) updates['displayName'] = displayName;
//       if (phone != null) updates['phone'] = phone;
//       if (address != null) updates['address'] = address;
//       if (photoURL != null) updates['photoURL'] = photoURL;

//       updates['updatedAt'] = FieldValue.serverTimestamp();

//       await _firestore.collection(_usersCollection).doc(uid).update(updates);

//       User? currentUser = _auth.currentUser;
//       if (photoURL != null && currentUser != null && currentUser.uid == uid) {
//         await currentUser.updatePhotoURL(photoURL);
//       }

//       return true;
//     } catch (e) {
//       debugPrint('Erreur lors de la mise à jour du profil: $e');
//       return false;
//     }
//   }

//   // Changer le rôle d'un utilisateur (Admin only)
//   Future<bool> changeUserRole({
//     required String uid,
//     required UserRole newRole,
//   }) async {
//     try {
//       if (currentUser != null) {
//         UserRole currentUserRole = await getUserRole(currentUser!);
//         if (currentUserRole != UserRole.admin) {
//           debugPrint('Permission refusée: seuls les admins peuvent changer les rôles');
//           return false;
//         }
//         await _firestore.collection(_usersCollection).doc(uid).update({
//           'role': newRole.toString().split('.').last,
//           'updatedAt': FieldValue.serverTimestamp(),
//           'updateby': currentUser!.uid,
//         });
//         return true;
//       }
//       return false;
//     } catch (e) {
//       debugPrint('Erreur lors du changement de rôle: $e');
//       return false;
//     }
//   }

//   // Obtenir tous les utilisateurs (Admin only)
//   Future<List<Map<String, dynamic>>> getAllUsers() async {
//     try {
//       if (currentUser != null) {
//         UserRole currentUserRole = await getUserRole(currentUser!);
//         if (currentUserRole != UserRole.admin) {
//           debugPrint('Permission refusée: seuls les admins peuvent voir tous les utilisateurs');
//           return [];
//         }
//         QuerySnapshot snapshot = await _firestore.collection(_usersCollection).get();
//         return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
//       }
//       return [];
//     } catch (e) {
//       debugPrint('Erreur lors de la récupération des utilisateurs: $e');
//       return [];
//     }
//   }
// }
import 'package:firebase_auth/firebase_auth.dart'; // Importer firebase_auth pour utiliser User
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum UserRole {
  admin,
  locataire,
  proprietaire,
  user,
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '508280862192-odp1c720ajij2be1mtoqipe9jsaparsv.apps.googleusercontent.com',
  );

  final String _usersCollection = 'users';

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  String? get currentUserId => null;

  // Vérifier si l'utilisateur est connecté
  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  // Récupérer l'utilisateur actuel
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Connexion anonyme
  Future<User?> signInAnonymously() async {
    try {
      UserCredential credential = await _auth.signInAnonymously();
      return credential.user;
    } catch (e) {
      debugPrint("Erreur lors de la connexion anonyme: $e");
      return null;
    }
  }

  // Sign up with email and password
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
    String? phone,
    String? address,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await credential.user?.updateDisplayName(displayName);
      
      if (credential.user != null) {
        await _firestore.collection(_usersCollection).doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'email': email,
          'displayName': displayName,
          'role': role.toString().split('.').last,
          'phone': phone ?? '',
          'address': address ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });
        
        await credential.user?.reload();
        return credential.user;
      }
      return null;
    } catch (e) {
      debugPrint("Erreur lors de l'inscription: $e");
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      
      if (credential.user != null) {
        await _firestore.collection(_usersCollection).doc(credential.user!.uid).update({
          'lastLogin': FieldValue.serverTimestamp()
        });
      }
      
      return credential.user;
    } catch (e) {
      debugPrint("Erreur lors de la connexion: $e");
      return null;
    }
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = 
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Vérifier si c'est un nouvel utilisateur
        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          await _createUserInFirestore(user);
        } else {
          // Mettre à jour la dernière connexion pour un utilisateur existant
          await _updateLastLogin(user);
        }

        return user;
      }

      return null;
    } catch (e) {
      debugPrint('Erreur de connexion Google : $e');
      return null;
    }
  }

  // Création d'un utilisateur dans Firestore après connexion Google
  Future<void> _createUserInFirestore(User user) async {
    try {
      await _firestore.collection(_usersCollection).doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName ?? '',
        'photoURL': user.photoURL ?? '',
        'role': UserRole.user.toString().split('.').last,
        'phone': '',
        'address': '',
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Erreur lors de la création de l\'utilisateur : $e');
    }
  }

  // Mise à jour de la dernière connexion
  Future<void> _updateLastLogin(User user) async {
    try {
      await _firestore.collection(_usersCollection).doc(user.uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour de la dernière connexion : $e');
    }
  }

  // Récupérer les données utilisateur
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_usersCollection).doc(uid).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      debugPrint('Erreur lors de la récupération des données utilisateur: $e');
      return null;
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      debugPrint('Utilisateur déconnecté');
    } catch (e) {
      debugPrint('Erreur lors de la déconnexion : $e');
    }
  }

  // Réinitialisation du mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      debugPrint('Email de réinitialisation envoyé à: $email');
    } catch (e) {
      debugPrint('Erreur lors de la réinitialisation du mot de passe: $e');
      rethrow;
    }
  }

  // Obtenir le rôle de l'utilisateur
  Future<UserRole> getUserRole(User user) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_usersCollection).doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        String roleStr = userData['role'] ?? 'locataire';

        switch (roleStr) {
          case 'admin': return UserRole.admin;
          case 'proprietaire': return UserRole.proprietaire;
          case 'locataire': return UserRole.locataire;
          case 'user': return UserRole.user;
          default: return UserRole.locataire;
        }
      }
      return UserRole.locataire;
    } catch (e) {
      debugPrint('Erreur lors de la récupération du rôle: $e');
      return UserRole.locataire;
    }
  }

  // Mettre à jour le profil utilisateur
  Future<bool> updateUserProfile({
    required String uid,
    String? displayName,
    String? phone,
    String? address,
    String? photoURL,
  }) async {
    try {
      Map<String, dynamic> updates = {};

      if (displayName != null) updates['displayName'] = displayName;
      if (phone != null) updates['phone'] = phone;
      if (address != null) updates['address'] = address;
      if (photoURL != null) updates['photoURL'] = photoURL;

      updates['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore.collection(_usersCollection).doc(uid).update(updates);

      User? currentUser = _auth.currentUser;
      if (photoURL != null && currentUser != null && currentUser.uid == uid) {
        await currentUser.updatePhotoURL(photoURL);
      }

      return true;
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour du profil: $e');
      return false;
    }
  }

  // Changer le rôle d'un utilisateur (Admin only)
  Future<bool> changeUserRole({
    required String uid,
    required UserRole newRole,
  }) async {
    try {
      if (currentUser != null) {
        UserRole currentUserRole = await getUserRole(currentUser!);
        if (currentUserRole != UserRole.admin) {
          debugPrint('Permission refusée: seuls les admins peuvent changer les rôles');
          return false;
        }
        await _firestore.collection(_usersCollection).doc(uid).update({
          'role': newRole.toString().split('.').last,
          'updatedAt': FieldValue.serverTimestamp(),
          'updateby': currentUser!.uid,
        });
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Erreur lors du changement de rôle: $e');
      return false;
    }
  }

  // Obtenir tous les utilisateurs (Admin only)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      if (currentUser != null) {
        UserRole currentUserRole = await getUserRole(currentUser!);
        if (currentUserRole != UserRole.admin) {
          debugPrint('Permission refusée: seuls les admins peuvent voir tous les utilisateurs');
          return [];
        }
        QuerySnapshot snapshot = await _firestore.collection(_usersCollection).get();
        return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Erreur lors de la récupération des utilisateurs: $e');
      return [];
    }
  }
}
