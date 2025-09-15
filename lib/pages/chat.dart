 import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:my_app/utils/firestore_utils.dart'; // <-- import utilitaire

class ChatScreen extends StatefulWidget {
  final String otherUserEmail;

  const ChatScreen({super.key, required this.otherUserEmail});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  final uuid = const Uuid();
  final CollectionReference messagesRef =
      FirebaseFirestore.instance.collection('messages');

  @override
  void initState() {
    super.initState();
    updateMessagesWithParticipants(); // <-- mise à jour automatique
  }

  // Stream pour récupérer tous les messages où l'utilisateur actuel est participant
  Stream<QuerySnapshot> _messageStream() {
    return messagesRef
        .where('participants', arrayContains: user!.email!)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final message = {
      'id': uuid.v4(),
      'senderEmail': user!.email!,
      'receiverEmail': widget.otherUserEmail,
      'participants': [user!.email!, widget.otherUserEmail],
      'content': _controller.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await messagesRef.add(message);
      _controller.clear();
    } catch (e) {
      print("Erreur envoi message: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible d’envoyer le message")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat avec ${widget.otherUserEmail}")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messageStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Erreur: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Pas de messages pour l’instant"));
                }

                final docs = snapshot.data!.docs;

                // Filtrer uniquement les messages entre user et otherUserEmail
                final filteredMessages = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final participants = List<String>.from(data['participants'] ?? []);
                  return participants.contains(widget.otherUserEmail);
                }).toList();

                return ListView.builder(
                  reverse: true,
                  itemCount: filteredMessages.length,
                  itemBuilder: (context, index) {
                    final data =
                        filteredMessages[index].data() as Map<String, dynamic>;
                    final isMe = data['senderEmail'] == user!.email!;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.green : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          data['content'] ?? '',
                          style: TextStyle(
                              color: isMe ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(hintText: "Écrire un message"),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
