 /// 🔹 Classe représentant un utilisateur
class User {
  final String id;       // Identifiant unique (Firestore ou API)
  final String name;     // Nom de l'utilisateur
  final int age;         // Âge
  final String photoUrl; // URL de la photo de profil
  final String code;     // Code généré (2 lettres du nom + âge)
  // final String email;    // Email de l'utilisateur (pour messagerie)
  final String role;     // Rôle de l'utilisateur (ex: admin, user)

  /// ✅ Constructeur
  User({
    required this.id,
    required this.name,
    required this.age,
    required this.photoUrl,
    required this.code,
    // required this.email,
    required this.role,
  });

  /// ✅ Génère un code unique basé sur le nom et l’âge
  /// Exemple : name="Papa", age=26 → "pa26"
  static String generateCode(String name, int age) {
    final prefix = name.isNotEmpty
        ? name.trim().substring(0, name.length >= 2 ? 2 : 1).toLowerCase()
        : "xx";
    return "$prefix$age";
  }

  /// ✅ Conversion Firestore → User
  factory User.fromJson(Map<String, dynamic> json, String id) {
    return User(
      id: id,
      name: json['name'] ?? "",
      age: json['age'] ?? 0,
      photoUrl: json['photoUrl'] ?? "",
      code: json['code'] ?? generateCode(json['name'] ?? "", json['age'] ?? 0),
      // email: json['email'] ?? "",
      role: json['role'] ?? "user", // rôle par défaut = "user"
    );
  }

  /// ✅ Conversion User → Firestore
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "age": age,
      "photoUrl": photoUrl,
      "code": code,
      // "email": email,
      "role": role,
    };
  }

  // Map<String, dynamic> toMap() {}

  // static fromMap(String id, Map<String, dynamic> data) {}
}
