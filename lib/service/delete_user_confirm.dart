import 'package:flutter/material.dart';
import 'package:my_app/service/user_api.dart';

/// Fonction utilitaire qui affiche une boîte de dialogue de confirmation
/// avant de supprimer un utilisateur.
/// 
/// - [context] : le contexte Flutter pour afficher la boîte de dialogue
/// - [userId] : l'identifiant de l'utilisateur à supprimer
/// - [onDeleted] : callback à exécuter après suppression réussie (ex: recharger la liste)
Future<void> confirmDeleteUser(
  BuildContext context, 
  String userId, 
  VoidCallback onDeleted,
) async {
  // Affiche une boîte de dialogue demandant confirmation
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: const [
          // Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
        SizedBox(width: 10),
           
        ],
      ),
      content: const Text(
        "Êtes-vous sûr de vouloir supprimer cet utilisateur ?",
        style: TextStyle(fontSize: 18),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      actions: [
        // Bouton "Annuler"
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => Navigator.pop(context, false),
          child: const Text(
            "Annuler",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
          ),
        ),

        // Bouton "Supprimer"
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => Navigator.pop(context, true),
          // icon: const Icon(Icons.delete_forever, size: 18),
          label: const Text("Supprimer", style: TextStyle(fontSize: 18)),
        ),
      ],
    ),
  );

  // Si l’utilisateur a confirmé la suppression
  if (confirm == true) {
    await UserApi.deleteUser(userId);
    onDeleted();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Utilisateur supprimé avec succès"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}
