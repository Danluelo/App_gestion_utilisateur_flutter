import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class StorageService {
  static const String bucket = "my-app-2025-desa00411.appspot.com";

  /// 📤 Upload une photo sur Firebase Storage
  static Future<String> uploadUserPhoto(XFile file) async {
    try {
      final storage = FirebaseStorage.instanceFor(bucket: bucket);

      final extension = path.extension(file.path);
      final fileRef = storage.ref().child(
        "users/${DateTime.now().millisecondsSinceEpoch}$extension",
      );

      await fileRef.putFile(File(file.path));
      return await fileRef.getDownloadURL();
    } catch (e) {
      print("⚠️ Erreur Firebase Storage : $e");
      // 👉 fallback : sauvegarde locale si Firebase ne marche pas
      return await saveLocally(file);
    }
  }

  /// 📂 Sauvegarde locale dans la mémoire de l’app
  static Future<String> saveLocally(XFile file) async {
    final directory = await getApplicationDocumentsDirectory();
    final extension = path.extension(file.path);
    final localPath =
        "${directory.path}/${DateTime.now().millisecondsSinceEpoch}$extension";

    final savedFile = await File(file.path).copy(localPath);

    // on retourne juste le chemin local (utilisé comme "photoUrl")
    return savedFile.path;
  }
}
