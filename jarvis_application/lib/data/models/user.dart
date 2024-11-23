class User {
  final String id;
  final String email;
  final String username;
  final List<String> roles;
  final Map<String, dynamic> geo;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.roles,
    required this.geo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      roles: List<String>.from(json['roles']),
      geo: json['geo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'roles': roles,
      'geo': geo,
    };
  }
}
