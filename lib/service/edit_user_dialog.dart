 import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:my_app/cubit/user_cubit.dart';
import 'package:my_app/model/userModel.dart';

class EditUserDialog extends StatefulWidget {
  final User? user; // nullable pour pouvoir ajouter un nouvel utilisateur

  const EditUserDialog({super.key, this.user});

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  String? _newPhotoPath;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user?.name ?? "");
    ageController =
        TextEditingController(text: widget.user?.age.toString() ?? "");
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final dir = await getApplicationDocumentsDirectory();
      final newPath =
          path.join(dir.path, "${DateTime.now().millisecondsSinceEpoch}.jpg");

      await File(picked.path).copy(newPath);

      setState(() {
        _newPhotoPath = newPath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.user != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        isEditing ? "Modifier un utilisateur" : "Ajouter un utilisateur",
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 40,
              backgroundImage: _newPhotoPath != null
                  ? FileImage(File(_newPhotoPath!))
                  : (widget.user?.photoUrl.isNotEmpty ?? false
                      ? FileImage(File(widget.user!.photoUrl))
                      : null),
              child: (_newPhotoPath == null &&
                      (widget.user?.photoUrl.isEmpty ?? true))
                  ? const Icon(Icons.camera_alt, size: 32, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Nom",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Âge",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Annuler"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            final name = nameController.text.trim();
            final age = int.tryParse(ageController.text) ?? 0;

            if (name.isEmpty || age <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Nom et âge valides requis")),
              );
              return;
            }

            final code = User.generateCode(name, age);
            String photoPath = _newPhotoPath ?? widget.user?.photoUrl ?? "";

            final userToSave = User(
              id: widget.user?.id ?? "", // id vide pour nouvel utilisateur
              name: name,
              age: age,
              photoUrl: photoPath,
              code: code,
              role: widget.user?.role ?? "user", // rôle par défaut si ajout
            );

            if (isEditing) {
              context.read<UserCubit>().updateUser(userToSave);
            } else {
              context.read<UserCubit>().addUser(userToSave);
            }

            Navigator.pop(context);
          },
          child: Text(isEditing ? "Enregistrer" : "Ajouter"),
        ),
      ],
    );
  }
}
