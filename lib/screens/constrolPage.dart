import 'package:flutter/material.dart';
import 'package:my_app/presentation/widget/add_user_dialog.dart'; 
import 'package:my_app/model/userModel.dart';
import 'package:my_app/presentation/widget/all_user.dart';

/// Page principale avec onglets (ajout, liste, paramètres)
class ControlePage extends StatelessWidget {
  const ControlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // ✅ Nombre d’onglets (3 : ajouter, liste, paramètres)
      child: Scaffold(
        // ✅ Barre du haut (AppBar)
        appBar: AppBar(
          backgroundColor: Colors.green, // couleur principale
          elevation: 4, // ombre sous l’AppBar
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)), // coins arrondis en bas
          ),
          title: const Text(
            'Gestion des utilisateurs',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          // ✅ Onglets (icônes en bas de l’AppBar)
          bottom: const TabBar(
            indicatorColor: Colors.white, // couleur de l’indicateur (soulignement)
            labelColor: Colors.white, // couleur texte actif
            unselectedLabelColor: Colors.white70, // couleur texte inactif
            labelStyle: TextStyle(fontWeight: FontWeight.bold), // texte onglet actif en gras
            tabs: [
              Tab(icon: Icon(Icons.add)), // Onglet ajout utilisateur
              Tab(icon: Icon(Icons.list)), // Onglet liste des utilisateurs
              Tab(icon: Icon(Icons.settings)), // Onglet paramètres
            ],
          ),
        ),

        // ✅ Contenu de chaque onglet
        body: TabBarView(
          children: [
            // 🔹 Onglet 1 : bouton pour ouvrir une popup d’ajout utilisateur
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  backgroundColor: Colors.white, // fond blanc
                  foregroundColor: Colors.green, // texte/icône verts
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.green, width: 2), // bordure verte
                  ),
                ),
                // Quand on clique → ouvrir la boîte de dialogue d’ajout
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddUserDialog(
                      // Callback quand un utilisateur est ajouté
                      onUserAdded: (User u) {
                        print("✅ Utilisateur ajouté : ${u.toJson()}");
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.person_add, size: 22), // icône "ajout utilisateur"
                label: const Text(
                  "Ajouter un utilisateur",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // 🔹 Onglet 2 : liste des utilisateurs
            AllUsers(),

            // 🔹 Onglet 3 : page paramètres (placeholder pour l’instant)
            const Center(
              child: Text(
                "⚙️ Paramètres (en développement)",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
