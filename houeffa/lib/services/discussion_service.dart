
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:houeffa/models/discussion.dart';

// class ChatService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
//   // Méthode pour créer une nouvelle discussion ou récupérer une existante
//   Future<String> createOrGetChat({
//     required String currentUserId,
//     required String proprietaireId,
//     required String logementId,
//   }) async {
//     try {
//       // Vérifier si une discussion existe déjà entre ces utilisateurs pour ce logement
//       QuerySnapshot chatQuery = await _firestore.collection('chats')
//           .where('participants', arrayContains: currentUserId)
//           .where('logementId', isEqualTo: logementId)
//           .get();
      
//       // Filtrer les résultats pour trouver une discussion avec exactement ces deux participants
//       for (var doc in chatQuery.docs) {
//         List<String> participants = List<String>.from(doc['participants']);
//         if (participants.contains(proprietaireId) && participants.length == 2) {
//           return doc.id;
//         }
//       }
      
//       // Si aucune discussion n'existe, en créer une nouvelle
//       DocumentReference chatRef = await _firestore.collection('chats').add({
//         'participants': [currentUserId, proprietaireId],
//         'logementId': logementId,
//         'createdAt': FieldValue.serverTimestamp(),
//         'lastMessageAt': FieldValue.serverTimestamp(),
//         'lastMessage': null,
//       });
      
//       // Créer un message système pour démarrer la conversation
//       await _firestore.collection('messages').add({
//         'chatId': chatRef.id,
//         'senderId': 'system',
//         'text': 'Conversation démarrée à propos du logement.',
//         'timestamp': FieldValue.serverTimestamp(),
//         'read': false,
//       });
      
//       return chatRef.id;
//     } catch (e) {
//       print('Error creating/getting chat: $e');
//       throw e;
//     }
//   }
  
//   // Méthode pour envoyer un message
//   Future<void> sendMessage(String chatId, String senderId, String text) async {
//     try {
//       // Créer le message
//       await _firestore.collection('messages').add({
//         'chatId': chatId,
//         'senderId': senderId,
//         'text': text,
//         'timestamp': FieldValue.serverTimestamp(),
//         'read': false,
//       });
      
//       // Mettre à jour les informations de la discussion
//       await _firestore.collection('chats').doc(chatId).update({
//         'lastMessage': text,
//         'lastMessageAt': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print('Error sending message: $e');
//       throw e;
//     }
//   }
  
//   // Méthode pour marquer les messages comme lus - CORRIGÉE
//   Future<void> markMessagesAsRead({required String chatId, required String userId}) async {
//     try {
//       WriteBatch batch = _firestore.batch();
      
//       QuerySnapshot unreadMessages = await _firestore.collection('messages')
//           .where('chatId', isEqualTo: chatId)
//           .where('senderId', isNotEqualTo: userId)
//           .where('read', isEqualTo: false)
//           .get();
      
//       for (var doc in unreadMessages.docs) {
//         batch.update(doc.reference, {'read': true});
//       }
      
//       await batch.commit();
//     } catch (e) {
//       print('Error marking messages as read: $e');
//       throw e;
//     }
//   }
  
//   // Méthode pour obtenir les messages d'une discussion
//   Stream<List<Message>> getMessages(String chatId) {
//     return _firestore.collection('messages')
//         .where('chatId', isEqualTo: chatId)
//         .orderBy('timestamp', descending: true) // Modifié pour cohérence avec reverse: true
//         .snapshots()
//         .map((snapshot) {
//           return snapshot.docs.map((doc) {
//             return Message.fromFirestore(doc);
//           }).toList();
//         });
//   }
  
//   // Méthode pour obtenir les discussions d'un utilisateur
//   Stream<List<Chat>> getUserChats(String userId) {
//     return _firestore.collection('chats')
//         .where('participants', arrayContains: userId)
//         .orderBy('lastMessageAt', descending: true)
//         .snapshots()
//         .map((snapshot) {
//           return snapshot.docs.map((doc) {
//             return Chat.fromFirestore(doc);
//           }).toList();
//         });
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

// Définir les classes Message et Chat dans ce fichier pour éviter les conflits
class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String text;
  final Timestamp timestamp;
  final bool read;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.read,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Message(
      id: doc.id,
      chatId: data['chatId'] ?? '',
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      read: data['read'] ?? false,
    );
  }
}

class Chat {
  final String id;
  final List<String> participants;
  final String logementId;
  final Timestamp createdAt;
  final Timestamp lastMessageAt;
  final String? lastMessage;

  Chat({
    required this.id,
    required this.participants,
    required this.logementId,
    required this.createdAt,
    required this.lastMessageAt,
    this.lastMessage,
  });

  factory Chat.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Chat(
      id: doc.id,
      participants: List<String>.from(data['participants'] ?? []),
      logementId: data['logementId'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      lastMessageAt: data['lastMessageAt'] ?? Timestamp.now(),
      lastMessage: data['lastMessage'],
    );
  }
}

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Méthode pour créer une nouvelle discussion ou récupérer une existante
  Future<String> createOrGetChat({
    required String currentUserId,
    required String proprietaireId,
    required String logementId,
  }) async {
    try {
      // Vérifier si une discussion existe déjà entre ces utilisateurs pour ce logement
      QuerySnapshot chatQuery = await _firestore.collection('chats')
          .where('participants', arrayContains: currentUserId)
          .where('logementId', isEqualTo: logementId)
          .get();
      
      // Filtrer les résultats pour trouver une discussion avec exactement ces deux participants
      for (var doc in chatQuery.docs) {
        List<String> participants = List<String>.from(doc['participants']);
        if (participants.contains(proprietaireId) && participants.length == 2) {
          return doc.id;
        }
      }
      
      // Si aucune discussion n'existe, en créer une nouvelle
      DocumentReference chatRef = await _firestore.collection('chats').add({
        'participants': [currentUserId, proprietaireId],
        'logementId': logementId,
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessageAt': FieldValue.serverTimestamp(),
        'lastMessage': null,
      });
      
      // Créer un message système pour démarrer la conversation
      await _firestore.collection('messages').add({
        'chatId': chatRef.id,
        'senderId': 'system',
        'text': 'Conversation démarrée à propos du logement.',
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
      });
      
      return chatRef.id;
    } catch (e) {
      print('Error creating/getting chat: $e');
      throw e;
    }
  }
  
  // Méthode pour envoyer un message
  Future<void> sendMessage(String chatId, String senderId, String text) async {
    try {
      // Créer le message
      await _firestore.collection('messages').add({
        'chatId': chatId,
        'senderId': senderId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
      });
      
      // Mettre à jour les informations de la discussion
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': text,
        'lastMessageAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error sending message: $e');
      throw e;
    }
  }
  
  // Méthode pour marquer les messages comme lus
  Future<void> markMessagesAsRead({required String chatId, required String userId}) async {
    try {
      WriteBatch batch = _firestore.batch();
      
      QuerySnapshot unreadMessages = await _firestore.collection('messages')
          .where('chatId', isEqualTo: chatId)
          .where('senderId', isNotEqualTo: userId)
          .where('read', isEqualTo: false)
          .get();
      
      for (var doc in unreadMessages.docs) {
        batch.update(doc.reference, {'read': true});
      }
      
      await batch.commit();
    } catch (e) {
      print('Error marking messages as read: $e');
      throw e;
    }
  }
  
  // Méthode pour obtenir les messages d'une discussion
  Stream<List<Message>> getMessages(String chatId) {
    return _firestore.collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Message.fromFirestore(doc);
          }).toList();
        });
  }
  
  // Méthode pour obtenir les discussions d'un utilisateur
  Stream<List<Chat>> getUserChats(String userId) {
    return _firestore.collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Chat.fromFirestore(doc);
          }).toList();
        });
  }
}