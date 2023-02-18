import 'package:app_frontend/models.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage(this.game, {super.key});

  final Game game;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
