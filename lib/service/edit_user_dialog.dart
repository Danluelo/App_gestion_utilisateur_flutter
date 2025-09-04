import 'package:flutter/material.dart';
import 'package:my_app/model/userModel.dart';   // ✅ Modèle User (id, name, age…)
import 'package:my_app/service/user_api.dart'; // ✅ API pour mettre à jour un utilisateur

/// Widget qui affiche une boîte de dialogue (popup)
/// permettant de modifier un utilisateur existant
class EditUserDialog extends StatefulWidget {
  final User user;              // ✅ L'utilisateur à modifier
  final VoidCallback onUpdated; // ✅ Callback pour rafraîchir la liste après modification

  const EditUserDialog({
    super.key, 
    required this.user, 
    required this.onUpdated,
  });

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  // ✅ Contrôleurs pour récupérer/modifier le texte dans les TextFields
  late TextEditingController nameController;
  late TextEditingController ageController;

  @override
  void initState() {
    super.initState();
    // ✅ Initialisation des champs avec les données actuelles de l’utilisateur
    nameController = TextEditingController(text: widget.user.name);
    ageController = TextEditingController(text: widget.user.age.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // ✅ coins arrondis pour un design moderne
      ),

      // ✅ Titre du popup
      title: Row(
        children: const [
          SizedBox(width: 10),
          Text(
            "Update Users",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green, // ✅ cohérent avec l’action de mise à jour
            ),
          ),
        ],
      ),

      // ✅ Corps du popup (les champs de formulaire)
      content: Column(
        mainAxisSize: MainAxisSize.min, // ajuste la taille au contenu
        children: [
          // Champ texte : Nom
          TextField(
            controller: nameController,
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
            controller: ageController,
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
        // 🔹 Bouton Annuler (style OutlinedButton)
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => Navigator.pop(context), // ferme la popup sans rien faire
          child: const Text(
            "Annuler",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),

        // 🔹 Bouton Enregistrer (style principal vert)
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () async {
            // ✅ Création d’un nouvel utilisateur avec les données modifiées
            final updatedUser = User(
              id: widget.user.id, // on garde le même ID
              name: nameController.text,
              age: int.tryParse(ageController.text) ?? widget.user.age, // si vide ou invalide → ancien âge
            );

            // ✅ Envoi des modifications vers Firestore via l’API
            await UserApi.updateUser(updatedUser);

            // ✅ On notifie le parent pour rafraîchir la liste
            widget.onUpdated();

            // ✅ On ferme la popup
            Navigator.pop(context);
          },
          child: const Text(
            "Enregistrer",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
