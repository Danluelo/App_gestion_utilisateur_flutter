 import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/pages/drawer.dart';
import 'package:my_app/presentation/widget/AddUserDialog.dart';
import 'package:my_app/presentation/widget/all_user.dart';
import 'package:my_app/presentation/widget/scan_page.dart'; // ta page ScanPage

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
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: AllUsers(canDelete: false), // Admin ne peut pas supprimer
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "addUser",
            onPressed: () {
              // ouvrir un dialog pour ajouter un utilisateur
              showDialog(context: context, builder: (_) => AddUserDialog());
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.add),
            tooltip: "Ajouter un utilisateur",
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "scanQr",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScanPage()),
              );
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.qr_code_scanner),
            tooltip: "Scanner un utilisateur",
          ),
        ],
      ),
    );
  }
}
