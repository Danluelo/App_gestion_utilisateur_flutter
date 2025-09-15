 // lib/model/userModel.dart
class User {
  final String id;
  final String name;
  final int age;
  final String photoUrl;
  final String code;
  final String role;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.age,
    required this.photoUrl,
    required this.code,
    required this.role,
    required this.email,
  });

  /// Méthode copyWith
  User copyWith({
    String? id,
    String? name,
    int? age,
    String? photoUrl,
    String? code,
    String? role,
    String? email,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      photoUrl: photoUrl ?? this.photoUrl,
      code: code ?? this.code,
      role: role ?? this.role,
      email: email ?? this.email,
    );
  }

  /// Générer un code unique à partir du nom et de l'âge
  static String generateCode(String name, int age) {
    return "${name.substring(0, 2).toLowerCase()}$age";
  }
}
