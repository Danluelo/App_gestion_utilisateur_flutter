 import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/pages/drawer.dart';
import 'package:my_app/presentation/widget/all_user.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AllUsers(
          canEdit: false,   // utilisateur ne peut pas modifier
          canDelete: false, // utilisateur ne peut pas supprimer
        ),
      ),
    );
  }
}
