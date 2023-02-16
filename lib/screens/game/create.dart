import 'dart:async';

import 'package:app_frontend/io/http.dart';
import 'package:app_frontend/widgets/buttons.dart';
import 'package:flutter/material.dart';

class CreateGame extends StatefulWidget {
  const CreateGame(this.basketId, {super.key});

  final int basketId;

  @override
  State<CreateGame> createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGame> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);
  int _team = 1;
  bool _ready = false;

  set ready(bool ready) {
    backend.setReadyStatus(widget.basketId, team, ready);
    setState(() {
      _ready = ready;
    });
  }

  bool get ready => _ready;

  set team(int team) {
    if (team != 1 && team != 2) return;
    _team = team;
    _controller
        .animateTo(
          team - 1,
          duration: const Duration(milliseconds: 500),
        )
        .then((value) => backend.addToTeam(widget.basketId, team));
  }

  int get team => _team;

  @override
  void initState() {
    super.initState();

    /*Timer.periodic(const Duration(seconds: 1), (timer) async {
      var status = await backend.getReadyStatus(widget.basketId);
      if (status == null) return;
      setState(() {
        _team = status.team;
        _ready = status.ready;
      });
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Game'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Choose Team',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        team = 1;
                      },
                      child: Container(
                        color: Colors.lightGreen,
                        child: Text(
                          "Team 1",
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        team = 2;
                      },
                      child: Container(
                        color: Colors.lightBlue,
                        child: Text(
                          "Team 2",
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 200.0,
                width: double.infinity,
                child: AnimatedBuilder(
                  animation: _controller,
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/logo.jpg'),
                    radius: 50.0,
                  ),
                  builder: (context, child) {
                    print("animated builder trigger");
                    return Align(
                      alignment: Alignment(_controller.value - 0.5, 0.0),
                      child: child,
                    );
                  },
                ),
              ),
              Text(
                "You're ${!ready ? 'Not ' : ''}Ready",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                    colorOverride: ready ? Colors.red : Colors.green,
                    onPressed: () => ready = !ready,
                    text: "I'm ${ready ? 'Not ' : ''}Ready"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
