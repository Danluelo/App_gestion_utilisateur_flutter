// lib/service/delete_user_confirm.dart
import 'package:flutter/material.dart';

Future<bool?> confirmDeleteUser(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Supprimer l'utilisateur ?", style: TextStyle(fontWeight: FontWeight.bold)),
      content: const Text("Êtes-vous sûr de vouloir supprimer cet utilisateur ?"),
      actions: [
        OutlinedButton(onPressed: () => Navigator.pop(context, false), child: const Text("Annuler")),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
          onPressed: () => Navigator.pop(context, true),
          child: const Text("Supprimer"),
        ),
      ],
    ),
  );
}
