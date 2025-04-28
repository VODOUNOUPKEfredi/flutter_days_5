import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String role;
  final DateTime? createdAt;

  //constructeur pour initialiser les propriétés
  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.createdAt,
  });
  //methode pour convertir un document Firestore en objet UserModel
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      role: map['role'] ?? 'user',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }
  //methode pour convertir l'objet UserModel en Map pour firestore
  Map<String,dynamic>toMap(){
    return {
      'email' :email,
      'role':role,
      'createdAt':createdAt,
    };
  }
}
