import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/pages/drawer.dart';
// import 'package:my_app/pages/screen/drawer.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"),
      ),
      drawer: CustomDrawer(
        email: user?.email,
        role: "Admin",
      ),
      body: const Center(
        child: Text(
          "Bienvenue Admin ⚡",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
