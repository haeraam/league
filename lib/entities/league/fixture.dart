import 'package:leage_simulator/entities/team/team.dart';

class Fixture {
  final Team team1;
  final Team team2;
  int team1Score;
  int team2Score;
  Fixture({
    required this.team1,
    required this.team2,
    this.team1Score = 0,
    this.team2Score = 0,
  });
  @override
  String toString() {
    return '$team1 , $team2';
  }
}
