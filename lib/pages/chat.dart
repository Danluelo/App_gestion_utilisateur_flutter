import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/data/message_api.dart';
import 'package:my_app/model/messagerieModel.dart';
import 'package:uuid/uuid.dart';

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

  late Future<List<Message>> _messagesFuture;

  @override
  void initState() {
    super.initState();
    _messagesFuture = MessageApi.getMessagesFor(user!.email!, widget.otherUserEmail);
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final message = Message(
      id: uuid.v4(),
      senderEmail: user!.email!,
      receiverEmail: widget.otherUserEmail,
      content: _controller.text.trim(),
      timestamp: DateTime.now(),
    );

    await MessageApi.sendMessage(message);

    _controller.clear();
    setState(() {
      _messagesFuture = MessageApi.getMessagesFor(user!.email!, widget.otherUserEmail);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat avec ${widget.otherUserEmail}")),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Message>>(
              future: _messagesFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: false,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderEmail == user!.email;
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.green : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(msg.content, style: TextStyle(color: isMe ? Colors.white : Colors.black)),
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
                    decoration: const InputDecoration(hintText: "Écrire un message"),
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
