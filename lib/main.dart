import 'package:app_frontend/io/http.dart';
import 'package:app_frontend/screens/leaderboard.dart';
import 'package:app_frontend/screens/login.dart';
import 'package:app_frontend/screens/map.dart';
import 'package:app_frontend/screens/profile.dart';
import 'package:app_frontend/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
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
    LoginResult? session = ref.watch(sessionProvider);
    if (session == null) {
      return LoginPage();
    }
    return Scaffold(
        body: Column(
      children: [
        Expanded(
            child: TabBarView(controller: _controller, children: [
          const MapWidget(markers: []),
          Container(
            color: Colors.green,
          ),
          LeaderboardPage(users: backend.getUsers()),
          const ProfilePage(),
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
