import 'package:go_router/go_router.dart';
import 'package:leage_simulator/entities/club/club.dart';
import 'package:leage_simulator/entities/fixture/fixture.dart';
import 'package:leage_simulator/pages/fixture_detail/fixture_detail.dart';
import 'package:leage_simulator/pages/game/game_page.dart';
import 'package:leage_simulator/pages/home/home_page.dart';
import 'package:leage_simulator/pages/record_detail/record_detail.dart';

final router = GoRouter(
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
      path: '/fixture_detail',
      builder: (context, state) {
        return const FixtureDetailPage(fixtures: []);
      },
    ),
    GoRoute(
      path: '/game',
      builder: (context, state) {
        return GamePage();
      },
    ),
  ],
);
