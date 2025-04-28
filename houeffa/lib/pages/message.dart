// Dans message.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houeffa/models/logement_modele.dart';
import 'package:houeffa/pages/tchatPage.dart';
import 'package:houeffa/services/auth.dart';
import 'package:provider/provider.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    setState(() {
      _currentUserId = authService.currentUserId;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: _currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Aucune discussion'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final chatDoc = snapshot.data!.docs[index];
              final chatData = chatDoc.data() as Map<String, dynamic>;
              
              // Récupérer l'ID de l'autre participant
              List<String> participants = List<String>.from(chatData['participants'] ?? []);
              String otherUserId = participants.firstWhere(
                (id) => id != _currentUserId,
                orElse: () => '',
              );

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(otherUserId)
                    .get(),
                builder: (context, userSnapshot) {
                  String userName = 'Utilisateur';
                  
                  if (userSnapshot.hasData && userSnapshot.data!.exists) {
                    Map<String, dynamic> userData = 
                        userSnapshot.data!.data() as Map<String, dynamic>;
                    userName = userData['nom'] ?? 'Utilisateur';
                  }

                  return FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('logements')
                        .where('proprietaireId', isEqualTo: otherUserId)
                        .limit(1)
                        .get(),
                    builder: (context, logementSnapshot) {
                      Logement? logement;
                      
                      if (logementSnapshot.hasData && 
                          logementSnapshot.data!.docs.isNotEmpty) {
                        // Convertir le document en objet Logement
                        // Ceci dépend de votre classe Logement
                        Map<String, dynamic> logementData = 
                            logementSnapshot.data!.docs[0].data() 
                            as Map<String, dynamic>;
                        
                        // Supposons que Logement a un constructeur fromMap
                       logement = Logement.fromFirestore(logementSnapshot.data!.docs[0]);

                      }

                      return ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(userName),
                        subtitle: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('messages')
                              .where('chatId', isEqualTo: chatDoc.id)
                              .orderBy('timestamp', descending: true)
                              .limit(1)
                              .snapshots(),
                          builder: (context, messageSnapshot) {
                            if (messageSnapshot.hasData && 
                                messageSnapshot.data!.docs.isNotEmpty) {
                              Map<String, dynamic> lastMessage = 
                                  messageSnapshot.data!.docs[0].data() 
                                  as Map<String, dynamic>;
                              return Text(
                                lastMessage['text'] ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            }
                            return const Text('Aucun message');
                          },
                        ),
                        onTap: () {
                          if (logement != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  chatId: chatDoc.id,
                                  logement: logement!,
                                ),
                              ),
                            );
                          } else {
                            // Gérer le cas où le logement n'est pas disponible
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Informations de logement non disponibles'),
                              ),
                            );
                          }
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}