import 'dart:async';

import 'package:app_frontend/io/http.dart';
import 'package:app_frontend/models.dart';
import 'package:app_frontend/screens/profile.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage(this.game, {this.running = false, super.key});

  final Game game;
  final bool running;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Game game;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    game = widget.game;
    if (widget.running) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        var newGame = await backend.getGame(game.id);
        if (mounted) {
          setState(() {
            game = newGame;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.running) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game ${game.id}"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 110,
                height: 50,
                color: Colors.lightGreen,
                child: Center(
                  child: Text(
                    "Team 1",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                width: 80,
                height: 50,
                color: Colors.white,
                child: Center(
                  child: Text(
                    "${game.score1}-${game.score2}",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                width: 110,
                height: 50,
                color: Colors.lightBlue,
                child: Center(
                  child: Text(
                    "Team 2",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          color: Colors.lightGreen,
                          child: Text(
                            "Team 1",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: game.team1.length,
                            itemBuilder: (context, i) => ListTile(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          ProfilePage(game.team1[i]))),
                              title: Text(game.team1[i].name),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          color: Colors.lightBlue,
                          child: Text(
                            "Team 2",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: game.team2.length,
                            itemBuilder: (context, i) => ListTile(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          ProfilePage(game.team2[i]))),
                              title: Text(
                                game.team2[i].name,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
