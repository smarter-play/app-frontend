class User {
  const User({
    required this.email,
    required this.name,
    required this.surname,
    required this.password,
    required this.dateOfBirth,
  });

  factory User.fromJson(Map<String, dynamic> data) => User(
        email: data['email'] as String,
        name: data['name'] as String,
        surname: data['surname'] as String,
        password: data['password'] as String,
        dateOfBirth: DateTime.parse(data['date_of_birth'] as String),
      );

  final String email;
  final String name;
  final String surname;
  final String password;
  final DateTime dateOfBirth;
}
