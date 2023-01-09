import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({Key? key, required this.users}) : super(key: key);

  final Future<List<User>> users;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: users,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              User user = users[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.score.toString()),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("${snapshot.error}"),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class User {
  const User({
    required this.name,
    required this.score,
  });

  final String name;
  final int score;
}
