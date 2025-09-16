 // lib/presentation/widget/addUserDialog.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/cubit/user_cubit.dart';
import 'package:my_app/model/userModel.dart';

class AddUserDialog extends StatefulWidget {
  final String currentUserRole; // rôle du user connecté

  const AddUserDialog({super.key, required this.currentUserRole});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final TextEditingController ctrName = TextEditingController();
  final TextEditingController ctrAge = TextEditingController();
  File? _pickedImage;
  String? photoUrl;

  late String selectedRole;

  @override
  void initState() {
    super.initState();
    // Rôle par défaut pour le nouveau user
    selectedRole = "user";
  }

  bool get isFormValid =>
      ctrName.text.trim().isNotEmpty && (int.tryParse(ctrAge.text) ?? 0) > 0;

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 150,
      maxHeight: 150,
    );

    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 150,
      maxHeight: 150,
    );

    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Liste des rôles possibles selon le rôle du user connecté
    final roleOptions = widget.currentUserRole == "superadmin"
        ? ["superadmin", "admin", "user"]
        : ["user"]; // admin ne peut créer que des user

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Ajouter un utilisateur",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Photo de profil
            if (widget.currentUserRole == "superadmin") ...[
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SafeArea(
                      child: Wrap(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text('Galerie'),
                            onTap: () {
                              Navigator.of(context).pop();
                              _pickImage();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text('Appareil photo'),
                            onTap: () {
                              Navigator.of(context).pop();
                              _takePhoto();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _pickedImage != null
                      ? FileImage(_pickedImage!)
                      : null,
                  child: _pickedImage == null
                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _pickedImage != null 
                  ? 'Photo sélectionnée' 
                  : 'Appuyez pour ajouter une photo',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 15),
            ],
            
            // Nom
            TextField(
              controller: ctrName,
              decoration: const InputDecoration(labelText: "Nom"),
            ),
            const SizedBox(height: 10),
            
            // Âge
            TextField(
              controller: ctrAge,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Âge"),
            ),
            const SizedBox(height: 10),
            
            // Dropdown rôle
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: const InputDecoration(labelText: "Rôle"),
              items: roleOptions
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role.toUpperCase()),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => selectedRole = value);
              },
            ),
          ],
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Annuler"),
        ),
        // Correction simple dans AddUserDialog.dart
ElevatedButton(
  onPressed: isFormValid
      ? () {
          final name = ctrName.text.trim();
          final age = int.tryParse(ctrAge.text) ?? 0;
          final generatedCode = User.generateCode(name, age);

          final user = User(
            id: "",
            name: name,
            age: age,
            photoUrl: _pickedImage != null ? _pickedImage!.path : "",
            code: generatedCode,
            role: selectedRole,
            email: "",
          );

          // ✅ Correction: supprimer le paramètre image
          context.read<UserCubit>().addUser(user);
          Navigator.pop(context);
        }
      : null,
  child: const Text("Ajouter"),
),
      ],
    );
  }
}