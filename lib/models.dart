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

class Basket {
  const Basket({
    required this.id,
    this.address,
    required this.lat,
    required this.lon,
    required this.occupation,
  });

  factory Basket.fromJson(Map<String, dynamic> data) => Basket(
        id: data['id'] as int,
        address: data['address'] as String?,
        occupation: data['occupation'] as double,
        lat: data['lat'] as double,
        lon: data['lon'] as double,
      );

  final int id;
  final String? address;
  final double lat;
  final double occupation;
  final double lon;
}

class Game {
  Game({
    required this.basket,
    required this.team1,
    required this.team2,
    required this.score1,
    required this.score2,
    required this.createdAt,
  });

  factory Game.fromJson(Map<String, dynamic> data) => Game(
        basket: data['basket'] as int,
        team1: (data['team1'] as List)
            .map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList(),
        team2: (data['team2'] as List)
            .map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList(),
        score1: data['score1'] as int,
        score2: data['score2'] as int,
        createdAt: DateTime.parse(data['created_at'] as String),
      );

  final int basket;
  final List<User> team1;
  final List<User> team2;
  final int score1;
  final int score2;
  DateTime createdAt;
}
