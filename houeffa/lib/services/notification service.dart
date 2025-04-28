import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  
  // URL de votre Cloud Function pour envoyer des notifications
  // (Vous devrez créer cette fonction dans Firebase Functions)
  final String _fcmApiUrl = 'https://us-central1-votre-projet.cloudfunctions.net/sendNotification';
  
  // Méthode pour demander les permissions de notifications
  Future<void> requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    
    print('User notification permission status: ${settings.authorizationStatus}');
  }
  
  // Méthode pour sauvegarder le token FCM dans Firestore
  Future<void> saveTokenToDatabase(String userId) async {
    // Obtenir le FCM token actuel
    String? token = await _messaging.getToken();
    
    if (token != null) {
      // Sauvegarder le token dans la collection users
      await _firestore.collection('users').doc(userId).update({
        'fcmTokens': FieldValue.arrayUnion([token]),
        'lastTokenUpdate': FieldValue.serverTimestamp(),
      });
    }
  }
  
  // Méthode pour envoyer une notification push à un utilisateur
  Future<void> sendPushNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Récupérer le document de l'utilisateur
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      
      if (!userDoc.exists) {
        print('User not found');
        return;
      }
      
      // Récupérer les tokens FCM de l'utilisateur
      List<String> tokens = List<String>.from(userDoc.get('fcmTokens') ?? []);
      
      if (tokens.isEmpty) {
        print('No FCM tokens found for user');
        return;
      }
      
      // Créer une notification dans Firestore pour le suivi
      DocumentReference notificationRef = await _firestore.collection('notifications').add({
        'userId': userId,
        'title': title,
        'body': body,
        'data': data,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      // Inclure l'ID de la notification dans les données
      Map<String, dynamic> notificationData = data ?? {};
      notificationData['notificationId'] = notificationRef.id;
      
      // Appeler la Cloud Function pour envoyer la notification
      await http.post(
        Uri.parse(_fcmApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'tokens': tokens,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': notificationData,
        }),
      );
      
      print('Push notification sent successfully');
    } catch (e) {
      print('Error sending push notification: $e');
      throw e;
    }
  }
  
  // Configurer les listeners de notifications en premier plan et en arrière-plan
  void setupNotificationListeners() {
    // Gérer les notifications reçues en premier plan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        // Vous pouvez afficher une notification locale ici si nécessaire
      }
    });
    
    // Gérer les notifications cliquées lorsque l'application est en arrière-plan
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A notification was clicked when the app was in the background!');
      // Gérer la navigation en fonction des données de la notification
      _handleNotificationNavigation(message.data);
    });
  }
  
  // Méthode pour gérer la navigation basée sur les données de la notification
  void _handleNotificationNavigation(Map<String, dynamic> data) {
    if (data['type'] == 'chat' && data['chatId'] != null) {
      // Vous pouvez utiliser un service de navigation global ici
      // ou stocker ces informations pour la prochaine fois que l'application est ouverte
      print('Should navigate to chat: ${data['chatId']}');
    }
  }
}