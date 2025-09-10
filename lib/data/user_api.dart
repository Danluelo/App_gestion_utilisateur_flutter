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
      // String responseBody = await response.stream.bytesToString();
      final data = json.decode(response.body);
      final documents = data['documents'] as List<dynamic>? ?? [];

      return documents.map((doc) {
        final fields = doc['fields'];
        final id = doc['name'].toString().split('/').last;

        final name = fields['name']?['stringValue'] ?? "";
        final age = int.tryParse(fields['age']?['integerValue'] ?? "0") ?? 0;
        final photoUrl = fields['photoUrl']?['stringValue'] ?? "";
        final code = fields['code']?['stringValue'] ?? User.generateCode(name, age);

        return User(
          id: id,
          name: name,
          age: age,
          photoUrl: photoUrl,
          code: code,
        );
      }).toList();
    } else {
      throw Exception("Erreur lors du chargement des utilisateurs : ${response.body}");
    }
  }

  /// 🔹 POST - Ajouter un utilisateur
  static Future<void> addUser(User user) async {
    final body = json.encode({
      "fields": {
        "name": {"stringValue": user.name},
        "age": {"integerValue": user.age.toString()},
        "photoUrl": {"stringValue": user.photoUrl},
        "code": {"stringValue": user.code}, // ✅ Ajout code
      }
    });

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de l'ajout de l'utilisateur : ${response.body}");
    }
  }

  /// 🔹 PATCH - Modifier un utilisateur
  static Future<void> updateUser(User user) async {
    final url = "$baseUrl/${user.id}";
    final body = json.encode({
      "fields": {
        "name": {"stringValue": user.name},
        "age": {"integerValue": user.age.toString()},
        "photoUrl": {"stringValue": user.photoUrl},
        "code": {"stringValue": user.code}, // ✅ Ajout code
      }
    });

    final response = await http.patch(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la mise à jour de l'utilisateur : ${response.body}");
    }
  }

  /// 🔹 DELETE - Supprimer un utilisateur
  static Future<void> deleteUser(String id) async {
    final url = "$baseUrl/$id";

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la suppression de l'utilisateur : ${response.body}");
    }
  }

  /// 🔹 GET - Rechercher un utilisateur par son code (pour le QR)
  static Future<User> getUserByCode(String code) async {
    final url =
        "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents:runQuery";

    final body = json.encode({
      "structuredQuery": {
        "from": [{"collectionId": "users"}],
        "where": {
          "fieldFilter": {
            "field": {"fieldPath": "code"},
            "op": "EQUAL",
            "value": {"stringValue": code}
          }
        },
        "limit": 1
      }
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      if (data.isEmpty || data.first["document"] == null) {
        throw Exception("Aucun utilisateur trouvé pour le code $code");
      }

      final doc = data.first["document"];
      final fields = doc["fields"];
      final id = doc['name'].toString().split('/').last;

      return User(
        id: id,
        name: fields['name']?['stringValue'] ?? "",
        age: int.tryParse(fields['age']?['integerValue'] ?? "0") ?? 0,
        photoUrl: fields['photoUrl']?['stringValue'] ?? "",
        code: fields['code']?['stringValue'] ?? "",
      );
    } else {
      throw Exception("Erreur lors de la recherche par code : ${response.body}");
    }
  }
}
