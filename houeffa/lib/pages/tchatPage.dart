import 'package:flutter/material.dart';
import 'package:houeffa/models/logement_modele.dart';
import 'package:houeffa/services/auth.dart';
import 'package:houeffa/services/discussion_service.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

class ChatPage extends StatefulWidget {
  final String chatId;
  final Logement logement;
  const ChatPage({
    Key? key,
    required this.chatId,
    required this.logement,
  }) : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  String? _currentUserId;
  String? _otherUserId;
  Map<String, dynamic>? _otherUserData;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _markMessagesAsRead();
  }
  
  Future<void> _getCurrentUser() async {
    // Ajustez cette partie selon votre système d'authentification réel
    // Exemple avec Firebase Auth:
    // final user = FirebaseAuth.instance.currentUser;
    // setState(() {
    //   _currentUserId = user?.uid;
    // });
    
    // OU si vous utilisez un autre service d'authentification personnalisé:
    final authService = Provider.of<AuthService>(context, listen: false);
    setState(() {
      _currentUserId = authService.currentUserId;
    });
    
    // Récupérer l'autre participant
    DocumentSnapshot chatDoc = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .get();
    
    if (chatDoc.exists) {
      List<String> participants = List<String>.from(chatDoc.get('participants'));
      String otherUserId = participants.firstWhere(
        (id) => id != _currentUserId, 
        orElse: () => ''
      );
      
      setState(() {
        _otherUserId = otherUserId;
      });
      
      if (otherUserId.isNotEmpty) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(otherUserId)
            .get();
        
        if (userDoc.exists) {
          setState(() {
            _otherUserData = userDoc.data() as Map<String, dynamic>?;
          });
        }
      }
    }
  }
  
  // Méthode corrigée pour marquer les messages comme lus
  Future<void> _markMessagesAsRead() async {
    if (_currentUserId != null) {
      await _chatService.markMessagesAsRead(
        chatId: widget.chatId,
        userId: _currentUserId!,
      );
    }
  }
  
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      await _chatService.sendMessage(
        widget.chatId,
        _currentUserId!,
        _messageController.text.trim(),
      );
      
      _messageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _otherUserData != null 
          ? Text(_otherUserData!['nom'] ?? 'Chat')
          : const Text('Chargement...'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Naviguer vers les détails du logement
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => LogementDetailPage(logement: widget.logement),
              //   ),
              // );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _chatService.getMessages(widget.chatId) as Stream<List<Message>>, // Cast explicite
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                }
                
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Aucun message'));
                }
                
                final messages = snapshot.data!;
                
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == _currentUserId;
                    
                    return MessageBubble(
                      message: message,
                      isMe: isMe,
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Écrire un message...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: _isLoading 
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send, color: Colors.blue),
                  onPressed: _isLoading ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  
  const MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm').format(message.timestamp.toDate());
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      color: isMe ? Colors.white70 : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            Column(
              children: [
                const SizedBox(height: 10),
                if (message.read)
                  const Icon(Icons.done_all, size: 16, color: Colors.blue)
                else
                  const Icon(Icons.done, size: 16, color: Colors.grey),
              ],
            ),
          ],
        ],
      ),
    );
  }
}