import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/cubit/user_cubit.dart';
import 'package:my_app/model/userModel.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key}); // ✅ plus de onUserAdded

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final ctrName = TextEditingController();
  final ctrAge = TextEditingController();

  @override
  void dispose() {
    ctrName.dispose();
    ctrAge.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Ajouter un utilisateur",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: ctrName,
            decoration: InputDecoration(
              labelText: "Nom",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: ctrAge,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Âge",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Annuler"),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            final user = User(
              id: "",
              name: ctrName.text.trim(),
              age: int.tryParse(ctrAge.text) ?? 0,
            );

            if (user.name.isNotEmpty && user.age > 0) {
              context.read<UserCubit>().addUser(user); // ✅ Cubit
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Veuillez remplir correctement les champs")),
              );
            }
          },
          icon: const Icon(Icons.check),
          label: const Text("Ajouter"),
        ),
      ],
    );
  }
}
