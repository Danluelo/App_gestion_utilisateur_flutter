import 'package:flutter/material.dart';
import 'package:my_app/model/userModel.dart'; // ✅ Modèle User (id, name, age…)
import 'package:my_app/repository/userRepo.dart' as UserApi; // ✅ API qui gère les appels Firestore (ajout d’utilisateur)

/// Widget qui affiche une boîte de dialogue (popup)
/// permettant d’ajouter un nouvel utilisateur
class AddUserDialog extends StatefulWidget {
  final Function(User) onUserAdded; // ✅ Callback qui sera exécuté après ajout

  const AddUserDialog({super.key, required this.onUserAdded});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  // ✅ Contrôleurs de texte pour récupérer les valeurs saisies
  final ctrName = TextEditingController();
  final ctrAge = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // ✅ coins arrondis pour design moderne
      ),

      // ✅ Titre du popup
      title: Row(
        children: const [
          SizedBox(width: 10),
          Text(
            "Add Users",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),

      // ✅ Contenu : formulaire avec deux champs (Nom & Âge)
      content: Column(
        mainAxisSize: MainAxisSize.min, // ajuste la taille au contenu
        children: [
          // Champ texte : Nom
          TextField(
            controller: ctrName,
            decoration: InputDecoration(
              labelText: "Nom",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Champ texte : Âge
          TextField(
            controller: ctrAge,
            keyboardType: TextInputType.number, // clavier numérique
            decoration: InputDecoration(
              labelText: "Âge",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),

      // ✅ Boutons en bas du popup
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      actions: [
        // 🔹 Bouton Annuler (ferme la popup sans rien faire)
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Annuler",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),

        // 🔹 Bouton Ajouter (valide et enregistre)
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () async {
            final name = ctrName.text.trim();   // ✅ supprime les espaces
            final ageText = ctrAge.text.trim(); // ✅ supprime les espaces

            // Vérifie si les champs sont vides
            if (name.isEmpty || ageText.isEmpty) {
              // ✅ Affiche un message d’erreur
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Veuillez remplir tous les champs."),
                  backgroundColor: Colors.red,
                ),
              );
              return; // ✅ stoppe l’ajout
            }

            // ✅ Crée un nouvel utilisateur avec les données saisies
            final newUser = User(
              id: "", // Firestore va générer un ID automatiquement
              name: name,
              age: int.tryParse(ageText) ?? 0, // convertit en int (0 si invalide)
            );

            // ✅ Envoie vers Firestore via l’API
            await UserApi.addUser(newUser);

            // ✅ Appelle le callback pour mettre à jour la liste côté parent
            widget.onUserAdded(newUser);

            // ✅ Ferme la popup
            Navigator.pop(context);
          },
          child: const Text(
            "Ajouter",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
