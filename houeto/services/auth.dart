import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    String password, 
    {String role = 'locataire'}
  ) async {
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
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      return userDoc.exists 
          ? userDoc.get('role') ?? 'locataire' 
          : 'locataire';
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
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .update({'role': newRole});
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