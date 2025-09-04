// lib/service/edit_user_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/cubit/user_cubit.dart';
import 'package:my_app/model/userModel.dart';

class EditUserDialog extends StatefulWidget {
  final User user;

  const EditUserDialog({
    super.key,
    required this.user,
  });

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late TextEditingController nameController;
  late TextEditingController ageController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    ageController = TextEditingController(text: widget.user.age.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Update Users", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: "Nom", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Âge", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ],
      ),
      actions: [
        OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
          onPressed: () {
            final updatedUser = User(
              id: widget.user.id,
              name: nameController.text.trim(),
              age: int.tryParse(ageController.text) ?? widget.user.age,
            );
            context.read<UserCubit>().updateUser(updatedUser);
            Navigator.pop(context);
          },
          child: const Text("Enregistrer"),
        ),
      ],
    );
  }
}
