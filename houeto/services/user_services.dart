import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houeto/models/user_models.dart';

class UserService {
  //instance de firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //référence à la collection users
  CollectionReference get _usersCollection => _firestore.collection('users');
  //methode pour récup"rer un user par son uid
  Future<UserModel?> getUserById(String uid) async {
    try {
      //récupérer le doccument utilisateur depuis Firestore
      DocumentSnapshot doc = await _usersCollection.doc(uid).get();
      //si le doccument existe , le convertir en objet UserModel
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, uid);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  //Methode pour mettre à jour les information d'un utilisateur
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    return await _usersCollection.doc(uid).update(data);
  }

  // Stream pour écouter les changements sur un document utilisateur
  Stream<UserModel?> userStream(String uid) {
    return _usersCollection.doc(uid).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, uid);
      }
      return null;
    });
  }
}
