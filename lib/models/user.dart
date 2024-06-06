// models/user.dart
class User {
  final String id;
  final String name;
  final String email;
  final List<String> preferredGenres;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.preferredGenres,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      preferredGenres: List<String>.from(json['preferredGenres']),
    );
  }
}
