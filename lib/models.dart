class User {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.surname,
    required this.score,
    required this.dateOfBirth,
  });

  factory User.fromJson(Map<String, dynamic> data) => User(
        id: data['id'] as int,
        email: data['email'] as String,
        name: data['name'] as String,
        surname: data['surname'] as String,
        score: data['score'] as int,
        dateOfBirth: DateTime.parse(data['date_of_birth'] as String),
      );

  final int id;
  final String email;
  final String name;
  final String surname;
  final int score;
  final DateTime dateOfBirth;
}

class Court {
  const Court({
    required this.id,
    this.address,
    required this.lat,
    required this.lon,
  });

  factory Court.fromJson(Map<String, dynamic> data) => Court(
        id: data['id'] as int,
        address: data['address'] as String?,
        lat: data['lat'] as double,
        lon: data['lon'] as double,
      );

  final int id;
  final String? address;
  final double lat;
  final double lon;
}
