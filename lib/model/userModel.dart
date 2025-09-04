/// Classe représentant un utilisateur
class User {
  String id;   // ✅ Identifiant unique (généré par Firestore ou API)
  String name; // ✅ Nom de l'utilisateur
  int age;     // ✅ Âge de l'utilisateur

  /// Constructeur
  /// - [id] est facultatif (par défaut vide, car Firestore peut le générer)
  /// - [name] et [age] sont obligatoires
  User({this.id = '', required this.name, required this.age});

  /// Convertit un objet [User] en JSON (Map clé/valeur)
  /// Utile pour envoyer vers Firestore ou une API REST
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  /// Factory pour créer un objet [User] à partir d’un JSON (Map)
  /// - Si une clé n’existe pas, une valeur par défaut est utilisée
  /// - Permet de reconstruire l’objet depuis Firestore ou une API
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',      // ✅ si pas d’ID → chaîne vide
      name: json['name'] ?? '',  // ✅ si pas de nom → chaîne vide
      age: json['age'] ?? 0,     // ✅ si pas d’âge → 0
    );
  }
}
