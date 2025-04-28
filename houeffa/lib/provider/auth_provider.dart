import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:houeffa/models/user_model.dart';
import 'package:houeffa/services/auth.dart';

/// Provider pour gérer l'état d'authentification
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _currentUser;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _initAuthStateListener();
  }

  void _initAuthStateListener() {
    _authService.authStateChanges.listen((User? user) async {
      if (user != null) {
        try {
          final userData = await _authService.getUserData(user.uid);
          final userRole = await _authService.getUserRole(user);
          final userRoleString = userRole.toString().split('.').last;

          _currentUser = userData != null
              ? UserModel.fromMap(userData, user.uid)
              : UserModel(
                  uid: user.uid,
                  email: user.email ?? '',
                  role: userRoleString,
                  createdAt: DateTime.now(),
                );
        } catch (e) {
          _currentUser = null;
        }
      } else {
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
    UserRole role = UserRole.locataire,
    String? phone,
    String? address,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
        role: role,
        phone: phone,
        address: address,
      );

      _setLoading(false);
      return user != null;
    } catch (e) {
      _setError('Erreur: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _setLoading(false);
      return user != null;
    } catch (e) {
      _setError('Erreur: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _authService.signInWithGoogle();
      _setLoading(false);
      return user != null;
    } catch (e) {
      _setError("Erreur: ${e.toString()}");
      _setLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    _clearError();
    try {
      await _authService.signOut();
      _currentUser = null;
    } catch (e) {
      _setError('Erreur lors de la déconnexion: ${e.toString()}');
    }
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> resetPassword(String email) async {
  _setLoading(true);
  _clearError();
  
  try {
    // Envoyer un email de réinitialisation
    await _authService.resetPassword(email);
    _setLoading(false);
    return true;
  } catch (e) {
    _setError('Erreur lors de la réinitialisation: ${e.toString()}');
    _setLoading(false);
    return false;
  }
}

}
