import 'package:flutter/material.dart';
import 'package:leage_simulator/components/team_card.dart';
import 'package:leage_simulator/main.dart';

class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.isPlayed,
    required this.showDetail,
    required this.game,
    required this.teams,
  });
  final bool isPlayed;
  final bool showDetail;
  final Game game;
  final List<Team> teams;

  (Result, Result) getResult({required Game game}) {
    if (game.team1Score > game.team2Score) {
      return (Result.win, Result.lose);
    } else if (game.team1Score < game.team2Score) {
      return (Result.lose, Result.win);
    } else {
      return isPlayed ? (Result.draw, Result.draw) : (Result.none, Result.none);
    }
  }

  @override
  Widget build(BuildContext context) {
    var (team1Result, team2Result) = getResult(game: game);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TeamCard(
          team: game.team1,
          result: team1Result,
          showDetail: showDetail,
          rank: teams.indexWhere((element) => element.name == game.team1.name) + 1,
        ),
        SizedBox(
          width: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 4),
              // if (isPlayed)
              Text(
                '${game.team1Score}',
                style: TextStyle(
                  fontSize: (game.team1Score > game.team2Score) ? 16 : 13,
                  fontWeight: (game.team1Score > game.team2Score) ? FontWeight.bold : FontWeight.normal,
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
                '${game.team2Score}',
                style: TextStyle(
                  fontSize: (game.team2Score > game.team1Score) ? 16 : 13,
                  fontWeight: (game.team2Score > game.team1Score) ? FontWeight.bold : FontWeight.normal,
                  // color: (game.team2Score > game.team1Score) ? Colors.red : null,
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
        TeamCard(
          team: game.team2,
          result: team2Result,
          showDetail: showDetail,
          rank: teams.indexWhere((element) => element.name == game.team2.name) + 1,
        ),
      ],
    );
  }
}
