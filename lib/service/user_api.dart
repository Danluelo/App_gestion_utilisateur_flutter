import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/model/userModel.dart';

class UserApi {
  // ⚠️ Remplace par ton vrai PROJECT_ID
  static const String projectId = "my-app-2025-desa00411";
  static const String baseUrl =
      "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users";

  /// 🔹 GET - Récupérer tous les utilisateurs
  static Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final documents = data['documents'] as List<dynamic>? ?? [];

      return documents.map((doc) {
        final fields = doc['fields'];
        return User(
          id: doc['name'].toString().split('/').last, // récupère l'ID Firestore
          name: fields['name']['stringValue'],
          age: int.parse(fields['age']['integerValue']),
        );
      }).toList();
    } else {
      throw Exception("Erreur lors du chargement des utilisateurs");
    }
  }

  /// 🔹 POST - Ajouter un utilisateur
  static Future<void> addUser(User user) async {
    final body = json.encode({
      "fields": {
        "name": {"stringValue": user.name},
        "age": {"integerValue": user.age.toString()},
      }
    });

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de l'ajout de l'utilisateur");
    }
  }

  /// 🔹 PATCH - Modifier un utilisateur
  static Future<void> updateUser(User user) async {
    final url = "$baseUrl/${user.id}";
    final body = json.encode({
      "fields": {
        "name": {"stringValue": user.name},
        "age": {"integerValue": user.age.toString()},
      }
    });

    final response = await http.patch(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la mise à jour de l'utilisateur");
    }
  }

  /// 🔹 DELETE - Supprimer un utilisateur
  static Future<void> deleteUser(String id) async {
    final url = "$baseUrl/$id";

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la suppression de l'utilisateur");
    }
  }
}
