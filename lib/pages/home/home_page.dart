import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leage_simulator/components/game_card.dart';
import 'package:leage_simulator/components/league_table.dart';
import 'package:leage_simulator/entities/fixture/fixture.dart';
import 'package:leage_simulator/entities/league/league.dart';
import 'package:leage_simulator/entities/club/club.dart';
import 'package:leage_simulator/static/clubs/england.dart';

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

  late League pl;
  @override
  void initState() {
    super.initState();
    List<Club> premierLeagueClubs = englandClubsJson.where((club) => club['leagueTier'] == 1).map((json) => Club.fromJson(json)).toList();
    pl = League(clubs: premierLeagueClubs);
  }

  allReset() {
    pl.allReset();
    setState(() {});
  }

  void creatRound() {
    pl.startNewSeason();
    setState(() {});
    if (_autoPlay) {
      pl.playAllFixture();
    }
  }

  void nextRound() {
    setState(() {
      pl.nextRound();
    });
    if (_autoPlay) {
      pl.playAllFixture();
      playGame();
    }
  }

  playGame() async {
    setState(() {
      pl.playAllFixture();
    });

    if (_autoPlay) {
      await Future.delayed(_autoPlaySpeed);
      nextRound();
    }
  }

  Iterable<Fixture> getMainGames({required List<Fixture> games}) {
    if (!_showMainGame) return games;
    findIndex({required Club target}) => pl.clubs.indexWhere((club) => club.name == target.name);

    List<Fixture> mainGames = [...games.where((game) => findIndex(target: game.homeClub) < 5 || findIndex(target: game.awayClub) < 5)];

    mainGames.sort((a, b) {
      return max(a.homeClub.pts, a.awayClub.pts) > max(b.homeClub.pts, b.awayClub.pts) ? 0 : 1;
    });

    return mainGames;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, dynamic>> clubMap = pl.clubs.fold({}, (value, element) {
      value[element.name] = {'att': element.att, 'mid': element.mid, 'def': element.def, 'winner': 0};
      return value;
    });
    for (var season in pl.record) {
      int winner = clubMap[season[0].name]!['winner'];
      clubMap[season[0].name] = {
        ...clubMap[season[0].name]!,
        'winner': winner + 1,
      };
    }

    List clibList = clubMap.entries.map((e) => [e.key, e.value]).toList();
    clibList.sort(
      (a, b) {
        if (b[1]['winner'] == a[1]['winner']) {
          return b[0].compareTo(a[0]);
        } else {
          return b[1]['winner'] - a[1]['winner'];
        }
      },
    );

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
                      if (pl.season.isNotEmpty)
                        ...getMainGames(games: pl.season[pl.round])
                            .map(
                              (match) => Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: GameCard(
                                  fixture: match,
                                  isPlayed: pl.finishedRound,
                                  showDetail: _showDetail,
                                  clubs: pl.clubs,
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
            LeageTable(clubs: pl.clubs),
            SizedBox(
              height: 20,
            ),
            Column(
              children: clibList.map((e) {
                return e[1]['winner'] > 0 ? Text('${e[0]} ${e[1]['winner']}회 우승/ 현재 스텟 ${e[1]['att']} - ${e[1]['mid']} -${e[1]['def']} ') : Container();
              }).toList(),
            ),
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
            ),
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
