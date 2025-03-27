import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Exemple de liste de conversations
    final List<Map<String, dynamic>> conversations = [
      {
        'name': 'Propriétaire 1',
        'lastMessage': 'Bonjour, est-ce que le logement est toujours disponible?',
        'time': '10:30',
        'unread': 2,
        'avatar': 'P1',
      },
      {
        'name': 'Propriétaire 2',
        'lastMessage': 'D\'accord pour la visite demain à 15h',
        'time': 'Hier',
        'unread': 0,
        'avatar': 'P2',
      },
      {
        'name': 'Agent Immobilier',
        'lastMessage': 'Je vous envoie les photos supplémentaires',
        'time': 'Lun',
        'unread': 0,
        'avatar': 'AI',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Action de recherche
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Text(
                conversation['avatar'],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              conversation['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              conversation['lastMessage'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  conversation['time'],
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 5),
                if (conversation['unread'] > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      conversation['unread'].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
            onTap: () {
              // Navigation vers la conversation
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailPage(name: conversation['name']),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Créer une nouvelle conversation
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }
}

// Page de détail de conversation (exemple simplifié)
class ChatDetailPage extends StatelessWidget {
  final String name;
  
  const ChatDetailPage({Key? key, required this.name}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Contenu de la conversation ici'),
      ),
    );
  }
}