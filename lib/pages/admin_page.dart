 // lib/pages/screen/admin_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:my_app/pages/drawer.dart';
import 'package:my_app/presentation/widget/addUserDialog.dart';
import 'package:my_app/presentation/widget/all_user.dart';
import 'package:my_app/presentation/widget/scan_page.dart';
import 'package:my_app/repository/userRepo.dart';
import 'package:my_app/pages/chat.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String? email;
  String? role;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final fbUser = fbAuth.FirebaseAuth.instance.currentUser;
    if (fbUser != null && fbUser.email != null) {
      try {
        final fetchedRole =
            await UserRepository().getRoleByEmail(fbUser.email!);
        setState(() {
          email = fbUser.email;
          role = (fetchedRole ?? "user").toLowerCase();
        });
      } catch (e) {
        debugPrint("Erreur récupération rôle : $e");
        setState(() {
          email = fbUser.email;
          role = "user";
        });
      }
    } else {
      setState(() {
        email = null;
        role = "user";
      });
    }
    setState(() => isLoading = false);
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (_) => const AddUserDialog(),
    );
  }

  void _openScanPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const ScanPage()));
  }

  void _openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          otherUserEmail:
              "user@example.com", // ⚠️ à remplacer par l’email du user choisi
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Connecté : $email | Rôle : $role",
              style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
            ),
          ),
        ),
      ),
      drawer: CustomDrawer(email: email, role: role),
      body: Column(
        children: [
          // 🔹 Bouton message uniquement si rôle admin
          if (!isLoading && role == "admin")
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.message),
                  label: const Text("Envoyer un message"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _openChat,
                ),
              ),
            ),

          // 🔹 Liste des utilisateurs en temps réel (comme SuperAdmin)
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: AllUsers(
                canEdit: true,
                canDelete: false,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "scanUser",
            onPressed: _openScanPage,
            child: const Icon(Icons.qr_code_scanner),
            tooltip: "Scanner un utilisateur",
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "addUser",
            onPressed: _showAddUserDialog,
            child: const Icon(Icons.add),
            tooltip: "Ajouter un utilisateur",
          ),
        ],
      ),
    );
  }
}
