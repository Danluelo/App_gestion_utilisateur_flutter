import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/pages/drawer.dart';
// import 'package:my_app/pages/screen/drawer.dart';

class SuperAdminPage extends StatelessWidget {
  const SuperAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Super Admin"),
      ),
      drawer: CustomDrawer(
        email: user?.email,
        role: "Super Admin",
      ),
      body: const Center(
        child: Text(
          "Bienvenue Super Admin 👑",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
