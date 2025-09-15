// lib/pages/screen/drawer.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:my_app/pages/login.dart';
// import 'package:my_app/pages/login_page.dart';
// import 'package:my_app/pages/screen/login_page.dart'; // 👈 importe bien ta page Login

class CustomDrawer extends StatelessWidget {
  final String? email;
  final String? role;

  const CustomDrawer({super.key, this.email, this.role});

  Future<void> _logout(BuildContext context) async {
    await fbAuth.FirebaseAuth.instance.signOut();

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()), // 👈 retour direct vers Login
        (route) => false, // supprime toutes les pages précédentes
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(role ?? "Rôle inconnu"),
            accountEmail: Text(email ?? "Email inconnu"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blue),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Colors.grey),
            title: const Text("Historique"),
            onTap: () {
              Navigator.pushNamed(context, "/historique");
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.grey),
            title: const Text("Paramètres"),
            onTap: () {
              Navigator.pushNamed(context, "/parametres");
            },
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.grey),
            title: const Text("À propos"),
            onTap: () {
              Navigator.pushNamed(context, "/apropos");
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Se déconnecter"),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
