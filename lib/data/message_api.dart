import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/model/messagerieModel.dart';

class MessageApi {
  // 🔹 Remplace par ton vrai Project ID Firebase
  static const String projectId = "my-app-2025-desa00411";
  static const String baseUrl =
      "https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/messages";

  /// Envoyer un message
  static Future<void> sendMessage(Message message) async {
    // ⚡ Correction du timestamp pour Firestore
    final timestamp = message.timestamp.toUtc();
    final isoString = timestamp.toIso8601String();
    final safeIsoString = isoString.split('.').first + "Z"; // supprime les nano inutiles

    final body = jsonEncode({
      "fields": {
        "id": {"stringValue": message.id},
        "senderEmail": {"stringValue": message.senderEmail},
        "receiverEmail": {"stringValue": message.receiverEmail},
        "content": {"stringValue": message.content},
        "timestamp": {"timestampValue": safeIsoString},
      }
    });

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Erreur lors de l'envoi du message : ${response.body}");
    }
  }

  /// Récupérer tous les messages
  static Future<List<Message>> getMessages() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode != 200) {
      throw Exception("Erreur récupération messages : ${response.body}");
    }

    final data = jsonDecode(response.body);
    final documents = data["documents"] ?? [];
    return List<Message>.from(documents.map((doc) => Message.fromJson(doc)));
  }

  /// Récupérer les messages entre deux emails
  static Future<List<Message>> getMessagesFor(
      String userEmail1, String userEmail2) async {
    final allMessages = await getMessages();
    return allMessages
        .where((m) =>
            (m.senderEmail == userEmail1 && m.receiverEmail == userEmail2) ||
            (m.senderEmail == userEmail2 && m.receiverEmail == userEmail1))
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }
}
