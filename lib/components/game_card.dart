import 'package:flutter/material.dart';
import 'package:leage_simulator/components/team_card.dart';
import 'package:leage_simulator/entities/team/team.dart';
import 'package:leage_simulator/main.dart';

class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.isPlayed,
    required this.showDetail,
    required this.fixture,
    required this.teams,
  });
  final bool isPlayed;
  final bool showDetail;
  final Fixture fixture;
  final List<Team> teams;

  (Result, Result) getResult({required Fixture fixture}) {
    if (fixture.team1Score > fixture.team2Score) {
      return (Result.win, Result.lose);
    } else if (fixture.team1Score < fixture.team2Score) {
      return (Result.lose, Result.win);
    } else {
      return isPlayed ? (Result.draw, Result.draw) : (Result.none, Result.none);
    }
  }

  @override
  Widget build(BuildContext context) {
    var (team1Result, team2Result) = getResult(fixture: fixture);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TeamCard(
          team: fixture.team1,
          result: team1Result,
          showDetail: showDetail,
          rank: teams.indexWhere((element) => element.name == fixture.team1.name) + 1,
        ),
        SizedBox(
          width: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 4),
              // if (isPlayed)
              Text(
                '${fixture.team1Score}',
                style: TextStyle(
                  fontSize: (fixture.team1Score > fixture.team2Score) ? 16 : 13,
                  fontWeight: (fixture.team1Score > fixture.team2Score) ? FontWeight.bold : FontWeight.normal,
                  // color: (game.team1Score > game.team2Score) ? Colors.red : null,
                ),
              ),
              const SizedBox(width: 2),
              const Text(
                'vs',
                style: TextStyle(fontSize: 10),
              ),
              const SizedBox(width: 2),
              // if (isPlayed)
              Text(
                '${fixture.team2Score}',
                style: TextStyle(
                  fontSize: (fixture.team2Score > fixture.team1Score) ? 16 : 13,
                  fontWeight: (fixture.team2Score > fixture.team1Score) ? FontWeight.bold : FontWeight.normal,
                  // color: (game.team2Score > game.team1Score) ? Colors.red : null,
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
        TeamCard(
          team: fixture.team2,
          result: team2Result,
          showDetail: showDetail,
          rank: teams.indexWhere((element) => element.name == fixture.team2.name) + 1,
        ),
      ],
    );
  }
}
