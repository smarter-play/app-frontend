import 'package:app_frontend/io/http.dart';
import 'package:app_frontend/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:app_frontend/models.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leaderboard")),
      body: FutureBuilder<List<User>>(
        future: backend.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                User user = users[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(user)));
                  },
                  title: Text(user.name),
                  subtitle: Text("${user.score}"),
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
      ),
    );
  }
}
