import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:my_app/cubit/user_cubit.dart';
import 'package:my_app/model/userModel.dart';

class EditUserDialog extends StatefulWidget {
  final User user;

  const EditUserDialog({super.key, required this.user});

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
    nameController = TextEditingController(text: widget.user.name);
    ageController = TextEditingController(text: widget.user.age.toString());
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
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Modifier un utilisateur",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
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
                  : (widget.user.photoUrl.isNotEmpty
                      ? FileImage(File(widget.user.photoUrl))
                      : null),
              child: (_newPhotoPath == null && widget.user.photoUrl.isEmpty)
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
            final updatedName = nameController.text.trim();
            final updatedAge = int.tryParse(ageController.text) ?? widget.user.age;

            // Recalcul du code
            final updatedCode = User.generateCode(updatedName, updatedAge);

            String finalPhotoPath = widget.user.photoUrl;

            if (_newPhotoPath != null) {
              // Supprimer l’ancienne photo si elle existe et est locale
              if (finalPhotoPath.isNotEmpty && await File(finalPhotoPath).exists()) {
                try {
                  await File(finalPhotoPath).delete();
                } catch (e) {
                  debugPrint("Erreur suppression ancienne photo: $e");
                }
              }
              finalPhotoPath = _newPhotoPath!;
            }

            final updatedUser = User(
              id: widget.user.id,
              name: updatedName,
              age: updatedAge,
              photoUrl: finalPhotoPath,
              code: updatedCode,
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
