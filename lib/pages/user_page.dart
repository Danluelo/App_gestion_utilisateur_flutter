import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/pages/drawer.dart';
// import 'package:my_app/pages/screen/drawer.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

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
      body: const Center(
        child: Text(
          "Bienvenue Utilisateur 🙋",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
