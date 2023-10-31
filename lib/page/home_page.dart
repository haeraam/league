import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leage_simulator/components/game_card.dart';
import 'package:leage_simulator/components/league_table.dart';
import 'package:leage_simulator/entities/league/fixture.dart';
import 'package:leage_simulator/entities/league/league.dart';
import 'package:leage_simulator/entities/team/team.dart';
import 'package:leage_simulator/static/teams/teams.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _autoPlay = false;
  bool _autoPlayFast = false;
  bool _showMainGame = false;
  bool _showDetail = true;
  Duration _autoPlaySpeed = const Duration(milliseconds: 300);

  League pl = League(teams: premierLeagueTeams);

  allReset() {
    pl.allReset();
    setState(() {});
  }

  void creatRound() {
    pl.startNewSeason();
    setState(() {});
    if (_autoPlay) {
      pl.playGame();
    }
  }

  void nextRound() {
    setState(() {
      pl.nextRound();
    });
    if (_autoPlay) {
      pl.playGame();
    }
  }

  playGame() async {
    setState(() {
      pl.playGame();
    });

    if (_autoPlay) {
      await Future.delayed(_autoPlaySpeed);
      nextRound();
    }
  }

  Iterable<Fixture> getMainGames({required List<Fixture> games}) {
    if (!_showMainGame) return games;
    findIndex({required Team target}) => pl.teams.indexWhere((team) => team.name == target.name);

    List<Fixture> mainGames = [...games.where((game) => findIndex(target: game.team1) < 5 || findIndex(target: game.team2) < 5)];

    mainGames.sort((a, b) {
      return max(a.team1.pts, a.team2.pts) > max(b.team1.pts, b.team2.pts) ? 0 : 1;
    });

    return mainGames;
  }

  @override
  Widget build(BuildContext context) {
    int ROUND = pl.round;
    List<List<Fixture>> season = pl.season;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Text(
              'Round : ${pl.round + 1}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                  ),
                  const Text('자동진행'),
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                        value: _autoPlay,
                        onChanged: (check) {
                          setState(() {
                            _autoPlay = check ?? false;
                          });
                        }),
                  ),
                  const Text('fast'),
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                        value: _autoPlayFast,
                        onChanged: (check) {
                          setState(() {
                            _autoPlayFast = check ?? false;
                            if (_autoPlayFast) {
                              _autoPlaySpeed = const Duration(milliseconds: 10);
                            } else {
                              _autoPlaySpeed = const Duration(milliseconds: 300);
                            }
                          });
                        }),
                  ),
                  const Text('주요 경기만 보기'),
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                        value: _showMainGame,
                        onChanged: (check) {
                          setState(() {
                            _showMainGame = check ?? false;
                          });
                        }),
                  ),
                  const Text('상세정보'),
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                        value: _showDetail,
                        onChanged: (check) {
                          setState(() {
                            _showDetail = check ?? false;
                          });
                        }),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
                height: _showDetail ? (_showMainGame ? 300 : 600) : (_showMainGame ? 195 : 390),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (season.isNotEmpty)
                        ...getMainGames(games: season[ROUND])
                            .map(
                              (match) => Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: GameCard(
                                  fixture: match,
                                  isPlayed: pl.finishedRound,
                                  showDetail: _showDetail,
                                  teams: pl.teams,
                                ),
                              ),
                            )
                            .toList(),
                      const Row(),
                    ],
                  ),
                ),
              ),
            ),
            LeageTable(teams: pl.teams),
            ...pl.record
                .map((record) => GestureDetector(
                      onTap: () {
                        context.push('/record_detail', extra: record);
                      },
                      child: Row(
                        children: [
                          Text('우승:${record[0].name}/${record[0].pts}'),
                          Text('준우승:${record[1].name}/${record[1].pts}'),
                          Text('3위:${record[2].name}/${record[2].pts}'),
                          Text('4위:${record[3].name}/${record[3].pts}'),
                        ],
                      ),
                    ))
                .toList(),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(boxShadow: [
          BoxShadow(
            blurRadius: 5,
            spreadRadius: 5,
            color: Color.fromARGB(33, 79, 79, 79),
            blurStyle: BlurStyle.normal,
          )
        ], color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 20).add(
          const EdgeInsets.only(bottom: 32, top: 8),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(onPressed: allReset, child: const Icon(Icons.refresh)),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: ElevatedButton(onPressed: playGame, child: const Text('라운드 진행')),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: ElevatedButton(onPressed: nextRound, child: const Text('다음 라운드')),
            ),
          ],
        ),
      ),
    );
  }
}
