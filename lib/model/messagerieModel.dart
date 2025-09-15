class Message {
  final String id;
  final String senderEmail;
  final String receiverEmail;
  final String content;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.senderEmail,
    required this.receiverEmail,
    required this.content,
    required this.timestamp,
  });

  // Conversion vers Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      "fields": {
        "id": {"stringValue": id},
        "senderEmail": {"stringValue": senderEmail},
        "receiverEmail": {"stringValue": receiverEmail},
        "content": {"stringValue": content},
        "timestamp": {
          "timestampValue": timestamp.toUtc().toIso8601String() // ✅ format correct
        },
      }
    };
  }

  // Conversion Firestore JSON → Message
  factory Message.fromJson(Map<String, dynamic> json) {
    final fields = json["fields"];
    return Message(
      id: fields["id"]["stringValue"] ?? "",
      senderEmail: fields["senderEmail"]["stringValue"] ?? "",
      receiverEmail: fields["receiverEmail"]["stringValue"] ?? "",
      content: fields["content"]["stringValue"] ?? "",
      timestamp: DateTime.parse(fields["timestamp"]["timestampValue"]),
    );
  }
}
