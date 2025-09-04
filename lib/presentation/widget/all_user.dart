import 'package:flutter/material.dart';
import 'package:my_app/model/userModel.dart';             // modèle User (id, name, age…)
import 'package:my_app/service/delete_user_confirm.dart'; // service pour la confirmation de suppression
import 'package:my_app/service/edit_user_dialog.dart';    // service pour la modification d’un utilisateur
import 'package:my_app/service/user_api.dart';            // service API qui gère l’accès à Firestore (CRUD)

/// Widget qui affiche la liste de tous les utilisateurs
class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  // Future qui contient la liste des utilisateurs récupérés depuis Firestore
  late Future<List<User>> _futureUsers;

  @override
  void initState() {
    super.initState();
    _loadUsers(); // dès que le widget est créé → on charge les utilisateurs
  }

  /// Recharge les utilisateurs depuis Firestore (appel API)
  void _loadUsers() {
    setState(() {
      _futureUsers = UserApi.getUsers(); // récupère tous les utilisateurs
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: _futureUsers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // if (snapshot.hasError) {
        //   return Center(child: Text("Erreur : ${snapshot.error}"));
        // }

        if (snapshot.hasError) {
  String errorMessage = "Une erreur est survenue.";

  // On peut détecter si c’est un problème de connexion
  if (snapshot.error.toString().contains("network") || 
      snapshot.error.toString().contains("Failed host lookup")) {
    errorMessage = "Problème de connexion internet 🚫";
  }

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, color: Colors.red, size: 48),
            const SizedBox(height: 10),
            Text(
              errorMessage,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _futureUsers = UserApi.getUsers(); // 🔄 recharge la liste
                });
              },
              icon: const Icon(Icons.refresh, color: Colors.white,),
              label: const Text("Réessayer", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      );
      }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Aucun utilisateur trouvé"));
        }

        final users = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.green,
                  child: Text(
                    user.name.isNotEmpty
                        ? user.name.trim().split(" ").take(2).map((e) => e[0].toUpperCase()).join()
                        : "?",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                title: Text(
                  user.name,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                subtitle: Text(
                  "Âge : ${user.age}",
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Bouton Modifier
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.edit_note, color: Colors.green, size: 24),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => EditUserDialog(
                              user: user,
                              onUpdated: _loadUsers,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Bouton Supprimer
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        // borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete_forever_rounded, color: Colors.red, size: 24),
                        onPressed: () => confirmDeleteUser(
                          context,
                          user.id,
                          _loadUsers,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
