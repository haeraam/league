import 'package:flutter/material.dart';
import 'package:leage_simulator/components/club_card.dart';
import 'package:leage_simulator/entities/fixture/fixture.dart';
import 'package:leage_simulator/entities/club/club.dart';

class GameCard extends StatefulWidget {
  const GameCard({
    super.key,
    required this.isPlayed,
    required this.showDetail,
    required this.fixture,
    required this.clubs,
  });
  final bool isPlayed;
  final bool showDetail;
  final Fixture fixture;
  final List<Club> clubs;

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  (Result, Result) getResult({required Fixture fixture}) {
    if (fixture.homeClubScore > fixture.awayClubScore) {
      return (Result.win, Result.lose);
    } else if (fixture.homeClubScore < fixture.awayClubScore) {
      return (Result.lose, Result.win);
    } else {
      return widget.isPlayed ? (Result.draw, Result.draw) : (Result.none, Result.none);
    }
  }

  @override
  Widget build(BuildContext context) {
    var (homeClubResult, awayClubResult) = getResult(fixture: widget.fixture);
    return Container(
      // color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ClubCard(
              club: widget.fixture.homeClub,
              result: homeClubResult,
              showDetail: widget.showDetail,
              rank: widget.clubs.indexWhere((element) => element.name == widget.fixture.homeClub.name) + 1,
            ),
          ),
          const SizedBox(width: 4),
          if (!widget.fixture.played)
            SizedBox(
              // width: 50,
              child: ElevatedButton(
                  onPressed: () {
                    widget.fixture.play();
                    setState(() {});
                  },
                  child: Text('play')),
            ),
          if (widget.fixture.played)
            SizedBox(
              width: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.fixture.homeClubScore}',
                    style: TextStyle(
                      fontSize: (widget.fixture.homeClubScore > widget.fixture.awayClubScore) ? 16 : 13,
                      fontWeight: (widget.fixture.homeClubScore > widget.fixture.awayClubScore) ? FontWeight.bold : FontWeight.normal,
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
                    '${widget.fixture.awayClubScore}',
                    style: TextStyle(
                      fontSize: (widget.fixture.awayClubScore > widget.fixture.homeClubScore) ? 16 : 13,
                      fontWeight: (widget.fixture.awayClubScore > widget.fixture.homeClubScore) ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(width: 4),
          Expanded(
            child: ClubCard(
              club: widget.fixture.awayClub,
              result: awayClubResult,
              showDetail: widget.showDetail,
              rank: widget.clubs.indexWhere((element) => element.name == widget.fixture.awayClub.name) + 1,
            ),
          ),
        ],
      ),
    );
  }
}
