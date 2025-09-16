 // lib/pages/screen/controle_page.dart
import 'package:flutter/material.dart';
import 'package:my_app/presentation/widget/addUserDialog.dart';
import 'package:my_app/presentation/widget/all_user.dart';
import 'package:my_app/presentation/widget/scan_page.dart';

class ControlePage extends StatelessWidget {
  final String currentUserRole;

  const ControlePage({super.key, required this.currentUserRole});

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        // ❌ Ne pas utiliser const ici, rôle dynamique
        return AddUserDialog(
          currentUserRole: currentUserRole, // ✅ rôle transmis dynamiquement
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
              Tab(icon: Icon(Icons.add)),
              Tab(icon: Icon(Icons.list)),
              Tab(icon: Icon(Icons.qr_code)),
              Tab(icon: Icon(Icons.settings)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.green, width: 2),
                  ),
                ),
                onPressed: () => _showAddUserDialog(context),
                icon: const Icon(Icons.person_add, size: 22),
                label: const Text(
                  "Ajouter un utilisateur",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const AllUsers(),
            const ScanPage(),
            const Center(
              child: Text(
                "⚙️ Paramètres (en développement)",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
