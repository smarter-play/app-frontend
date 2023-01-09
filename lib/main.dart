import 'package:app_frontend/leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smarter Play',
      theme: ThemeData.dark(useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _controller = TabController(length: 4, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Smarter Play"),
        ),
        body: Column(
          children: [
            Expanded(
                child: TabBarView(controller: _controller, children: [
              Container(
                color: Colors.red,
              ),
              Container(
                color: Colors.green,
              ),
              LeaderboardPage(users: Future.value([])),
              Container(
                color: Colors.yellow,
              )
            ])),
            TabBar(controller: _controller, tabs: const [
              Tab(
                icon: Icon(Icons.map),
              ),
              Tab(
                icon: Icon(Icons.camera_alt),
              ),
              Tab(
                icon: Icon(Icons.leaderboard),
              ),
              Tab(
                icon: Icon(Icons.person),
              )
            ])
          ],
        ));
  }
}
