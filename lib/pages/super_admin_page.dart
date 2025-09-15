 import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/pages/drawer.dart';
import 'package:my_app/presentation/widget/AddUserDialog.dart';
import 'package:my_app/presentation/widget/all_user.dart';

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
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: AllUsers(), // Affiche tous les utilisateurs avec CRUD
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ici tu peux appeler ton dialog pour ajouter un nouvel utilisateur
          showDialog(context: context, builder: (context) => AddUserDialog());
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        tooltip: "Ajouter un utilisateur",
      ),
    );
  }
}
