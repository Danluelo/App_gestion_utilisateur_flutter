import 'package:flutter/material.dart';
import 'package:my_app/presentation/widget/AddUserDialog.dart';
import 'package:my_app/presentation/widget/all_user.dart';

/// Page principale avec onglets (ajout, liste, paramètres)
class ControlePage extends StatelessWidget {
  const ControlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // ✅ Nombre d’onglets
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          title: const Text(
            'Gestion des utilisateurs',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(icon: Icon(Icons.add)), // Ajouter
              Tab(icon: Icon(Icons.list)), // Liste
              Tab(icon: Icon(Icons.qr_code)), // Liste
              Tab(icon: Icon(Icons.settings)), // Paramètres
            ],
          ),
        ),

        body: TabBarView(
          children: [
            // 🔹 Onglet 1 : bouton pour ouvrir une popup d’ajout utilisateur
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.green, width: 2),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AddUserDialog(), // ✅ plus besoin de onUserAdded
                  );
                },
                icon: const Icon(Icons.person_add, size: 22),
                label: const Text(
                  "Ajouter un utilisateur",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // 🔹 Onglet 2 : liste des utilisateurs
            const AllUsers(),

            const Center(
              child: Text(
                "Faites vos scan ici",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54),
              ),
            ),

            // 🔹 Onglet 3 : paramètres

            const Center(
              child: Text(
                "⚙️ Paramètres (en développement)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
