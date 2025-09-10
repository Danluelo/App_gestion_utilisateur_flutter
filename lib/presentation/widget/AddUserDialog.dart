 import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/cubit/user_cubit.dart';
import 'package:my_app/model/userModel.dart';
import 'package:my_app/service/storage_service.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final ctrName = TextEditingController();
  final ctrAge = TextEditingController();
  String? photoUrl;
  bool isUploading = false;

  @override
  void dispose() {
    ctrName.dispose();
    ctrAge.dispose();
    super.dispose();
  }

  /// 📸 Sélectionner photo (caméra ou galerie)
  Future<void> pickPhoto() async {
    final picker = ImagePicker();

    final source = await showDialog<ImageSource>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Choisir une image"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Galerie"),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Caméra"),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picked = await picker.pickImage(source: source, imageQuality: 70);
    if (picked != null) {
      setState(() => isUploading = true);
      try {
        // 🔹 Upload vers Firebase Storage
        final url = await StorageService.uploadUserPhoto(picked);
        setState(() => photoUrl = url);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("⚠️ Erreur upload photo : $e")),
          );
        }
      } finally {
        if (mounted) setState(() => isUploading = false);
      }
    }
  }

  bool get isFormValid =>
      ctrName.text.trim().isNotEmpty && (int.tryParse(ctrAge.text) ?? 0) > 0;

  @override
  Widget build(BuildContext context) {
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
            InkWell(
              onTap: pickPhoto,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: (photoUrl != null && photoUrl!.isNotEmpty)
                    ? (photoUrl!.startsWith("http")
                        ? NetworkImage(photoUrl!) as ImageProvider
                        : FileImage(File(photoUrl!)))
                    : null,
                child: isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : (photoUrl == null || photoUrl!.isEmpty)
                        ? const Icon(Icons.person, size: 40)
                        : null,
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: pickPhoto,
              icon: const Icon(Icons.photo),
              label: const Text("Choisir une photo"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ctrName,
              decoration: InputDecoration(
                labelText: "Nom",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: ctrAge,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Âge",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            

            /// 👇 Avatar
            
          ],
        ),
      ),
      actionsPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
          onPressed: isFormValid
              ? () {
                  final name = ctrName.text.trim();
                  final age = int.tryParse(ctrAge.text) ?? 0;

                  final generatedCode = User.generateCode(name, age);

                  final user = User(
                    id: "", // Firestore va générer un ID
                    name: name,
                    age: age,
                    photoUrl: photoUrl ?? "",
                    code: generatedCode,
                  );

                  debugPrint("✅ Code généré : $generatedCode");

                  context.read<UserCubit>().addUser(user);
                  Navigator.pop(context);
                }
              : null,
          icon: const Icon(Icons.check),
          label: const Text("Ajouter"),
        ),
      ],
    );
  }
}
