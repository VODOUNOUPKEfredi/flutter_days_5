
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:houeffa/models/user_model.dart';
import 'package:houeffa/services/auth.dart';

/// Provider pour gérer l'état d'authentification dans toute l'application
class AuthProvider extends ChangeNotifier {
  // Service d'authentification Firebase
  final AuthService _authService = AuthService();
  
  // État de chargement
  bool _isLoading = false;
  
  // Message d'erreur
  String? _errorMessage;
  
  // Utilisateur actuel de l'application
  UserModel? _currentUser;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  // Constructeur qui initialise l'écouteur d'état d'authentification
  AuthProvider() {
    _initAuthStateListener();
  }

  /// Méthode privée pour initialiser l'écouteur d'état d'authentification
  void _initAuthStateListener() {
    _authService.authStateChanges.listen((User? user) async {
      if (user != null) {
        try {
          // Récupérer les données utilisateur depuis Firestore
          final userData = await _authService.getUserData(user.uid);
          
          if (userData != null) {
            // Récupérer son rôle
            final userRole = await _authService.getUserRole(user);
            
            // Si votre UserModel.fromMap s'attend à un rôle sous forme de chaîne
            final userRoleString = userRole.toString().split('.').last;
            
            // Créer un UserModel à partir des données Firestore
            _currentUser = UserModel.fromMap(userData, user.uid);
          } else {
            // Si l'utilisateur existe dans Auth mais pas dans Firestore
            final defaultRole = UserRole.locataire; // Rôle par défaut
            final userRoleString = defaultRole.toString().split('.').last;
            
            _currentUser = UserModel(
              uid: user.uid,
              email: user.email ?? '',
              role: userRoleString,
              createdAt: DateTime.now(),
            );
          }
        } catch (e) {
          print('Erreur lors de l\'initialisation de l\'utilisateur: $e');
          _currentUser = null;
        }
      } else {
        // Si aucun utilisateur n'est connecté
        _currentUser = null;
      }
      
      // Notifier les widgets écoutant ce provider
      notifyListeners();
    });
  }

  /// Méthode pour gérer l'inscription
  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
    UserRole role = UserRole.locataire, // Utiliser l'énumération
    String? phone,
    String? address,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      // Tenter de créer un compte
      final user = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
        role: role, // Passer l'enum UserRole directement
        phone: phone,
        address: address,
      );
      
      // Vérifier si l'inscription a réussi
      if (user != null) {
        // Les données utilisateur seront chargées via l'écouteur d'état
        _setLoading(false);
        return true;
      }
      
      _setError('Échec de l\'inscription. Veuillez réessayer.');
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Erreur: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Méthode pour gérer la connexion
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      // Tenter de se connecter
      final user = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Vérifier si la connexion a réussi
      if (user != null) {
        // Les données utilisateur seront chargées via l'écouteur d'état
        _setLoading(false);
        return true;
      }
      
      _setError('Échec de la connexion. Vérifiez vos identifiants.');
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Erreur: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Méthode pour gérer la déconnexion
  Future<void> signOut() async {
    _setLoading(true);
    _clearError();
    
    try {
      // Tenter de se déconnecter
      await _authService.signOut();
      _currentUser = null;
      _setLoading(false);
    } catch (e) {
      _setError('Erreur lors de la déconnexion: ${e.toString()}');
      _setLoading(false);
    }
  }

  /// Méthode pour réinitialiser le mot de passe
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

  // Méthodes privées pour gérer l'état
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
}