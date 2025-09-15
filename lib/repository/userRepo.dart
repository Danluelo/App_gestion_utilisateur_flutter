 // lib/repository/userRepo.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/model/userModel.dart';

class UserRepository {
  static const String projectId = "my-app-2025-desa00411";
  static const String baseUrl =
      "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users";
  static const String usersRolesUrl =
      "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents:runQuery";

  /// 🔹 Récupérer tous les utilisateurs
  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final documents = data['documents'] as List<dynamic>? ?? [];

      return documents.map((doc) {
        final fields = doc['fields'];
        final id = doc['name'].toString().split('/').last;
        final name = fields['name']?['stringValue'] ?? "";
        final age = int.tryParse(fields['age']?['integerValue'] ?? "0") ?? 0;
        final photoUrl = fields['photoUrl']?['stringValue'] ?? "";
        final code = fields['code']?['stringValue'] ?? User.generateCode(name, age);
        final role = fields['role']?['stringValue'] ?? "user";

        return User(
          id: id,
          name: name,
          age: age,
          photoUrl: photoUrl,
          code: code,
          role: role,
          email: fields['email']?['stringValue'] ?? "",
        );
      }).toList();
    } else {
      throw Exception("Erreur lors du chargement : ${response.body}");
    }
  }

  /// 🔹 Ajouter un utilisateur et retourner avec ID généré
  Future<User> addUser(User user) async {
    final body = json.encode({
      "fields": {
        "name": {"stringValue": user.name},
        "age": {"integerValue": user.age.toString()},
        "photoUrl": {"stringValue": user.photoUrl},
        "code": {"stringValue": user.code},
        "role": {"stringValue": user.role},
      }
    });

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final id = data['name'].toString().split('/').last;
      return user.copyWith(id: id);
    } else {
      throw Exception("Erreur lors de l'ajout : ${response.body}");
    }
  }

  /// 🔹 Modifier un utilisateur
  Future<User> updateUser(User user) async {
    final url = "$baseUrl/${user.id}";
    final body = json.encode({
      "fields": {
        "name": {"stringValue": user.name},
        "age": {"integerValue": user.age.toString()},
        "photoUrl": {"stringValue": user.photoUrl},
        "code": {"stringValue": user.code},
        "role": {"stringValue": user.role},
      }
    });

    final response = await http.patch(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      return user;
    } else {
      throw Exception("Erreur lors de la mise à jour : ${response.body}");
    }
  }

  /// 🔹 Supprimer un utilisateur
  Future<void> deleteUser(String id) async {
    final url = "$baseUrl/$id";
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la suppression : ${response.body}");
    }
  }

  /// 🔹 Récupérer le rôle d’un utilisateur via son email
  Future<String?> getRoleByEmail(String email) async {
    final body = json.encode({
      "structuredQuery": {
        "from": [{"collectionId": "users"}],
        "where": {
          "fieldFilter": {
            "field": {"fieldPath": "email"},
            "op": "EQUAL",
            "value": {"stringValue": email}
          }
        },
        "limit": 1
      }
    });

    final response = await http.post(
      Uri.parse(usersRolesUrl),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      if (data.isEmpty || data.first["document"] == null) return null;

      final fields = data.first["document"]["fields"];
      return fields["role"]?["stringValue"];
    } else {
      throw Exception("Erreur récupération rôle : ${response.body}");
    }
  }
}
