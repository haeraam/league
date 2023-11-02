import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leage_simulator/entities/club/club.dart';
import 'package:leage_simulator/entities/fixture/fixture.dart';
import 'package:leage_simulator/page/game_page.dart';
import 'package:leage_simulator/page/home_page.dart';
import 'package:leage_simulator/page/record_detail.dart';

void main() {
  runApp(const MyApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/record_detail',
      builder: (context, state) {
        return RecordDetailPage(clubs: state.extra as List<Club>);
      },
    ),
    GoRoute(
      path: '/game',
      builder: (context, state) {
        return GamePage(fixture: state.extra as Fixture);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
