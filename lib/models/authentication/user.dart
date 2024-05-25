class User {
  final String username;
  final String firstName;
  final String lastName;
  final String? token;

  const User({
    required this.username,
    required this.firstName,
    required this.lastName,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    if (json['token'] != null) {
      return User(
        username: json['username'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        token: json['access'],
      );
    } else {
      return User(
        username: json['username'],
        firstName: json['first_name'],
        lastName: json['last_name'],
      );
    }
  }
}
