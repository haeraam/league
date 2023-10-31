import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leage_simulator/entities/team/team.dart';
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
          return RecordDetailPage(teams: state.extra as List<Team>);
        }),
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
