 import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/pages/drawer.dart';
import 'package:my_app/presentation/widget/all_user.dart';
import 'package:my_app/pages/chat.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  void _openChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ChatScreen(
          otherUserEmail: "admin@example.com", // ⚠️ remplace par l’email réel de ton admin
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Utilisateur"),
      ),
      drawer: CustomDrawer(
        email: user?.email,
        role: "Utilisateur",
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: AllUsers(
          canEdit: false,
          canDelete: false,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openChat(context),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        tooltip: "Contacter l’Admin",
        child: const Icon(Icons.message),
      ),
    );
  }
}
