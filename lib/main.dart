import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leage_simulator/components/game_card.dart';
import 'package:leage_simulator/components/league_table.dart';
import 'package:leage_simulator/entities/team/team.dart';
import 'package:leage_simulator/page/record_detail.dart';
import 'package:leage_simulator/static/teams/teams.dart';

void main() {
  runApp(const MyApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

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

class League{

}

class _MyHomePageState extends State<MyHomePage> {
  int _round = 0;
  List<List<Fixture>> _matchs = [];
  bool _finishedRound = false;
  bool _autoPlay = false;
  bool _autoPlayFast = false;
  bool _showMainGame = false;
  bool _finishedLeague = true;
  bool _showDetail = true;
  Duration _autoPlaySpeed = const Duration(milliseconds: 300);

  List<Team> _teams = [];
  List<List<Team>> _record = [];

  allReset() {
    _teams = [];
    _record = [];
    _matchs = [];
    _finishedRound = false;
    _finishedLeague = true;

    creatRound();
    setState(() {});
  }

  @override
  void initState() {
    creatRound();
    super.initState();
  }

  void teamSetting() {
    if (_teams.isEmpty) {
      _teams = premierLeagueTeams;
      for (var team in _teams) {
        team.clear();
      }
    } else {
      int index = 0;
      List<Team> ratedByFundamental = ([..._teams]..sort(
          (a, b) => a.fundamental > b.fundamental ? 0 : 1,
        ));

      _teams = _teams.map((team) {
        double fundamental = team.fundamental;

        if (index == 0) {
          fundamental = fundamental + 1;
        } else if (index == 1) {
          fundamental = fundamental + 0.5;
        } else if (index < 4) {
          fundamental = fundamental + 0.25;
        } else if (index < 6) {
          fundamental = fundamental + 0.125;
        }

        double ranAtt = Random().nextDouble();
        double ranMid = Random().nextDouble();
        double ranDef = Random().nextDouble();

        getValue({required double randomNum, required double fundamental, required int rankBefore}) {
          int idx = ratedByFundamental.indexWhere((fTeam) => team.name == fTeam.name);
          double fundamentalBonus = switch (idx) {
            0 => 0.2,
            1 => 0.17,
            2 => 0.13,
            3 => 0.09,
            < 6 => 0.02,
            < 10 => -0.02,
            _ => -0.04,
          };
          double rankBonus = switch (rankBefore) {
            0 => -0.2,
            1 => -0.15,
            < 4 => -0.1,
            < 6 => -0.05,
            < 10 => 0,
            < 17 => 0.05,
            _ => 0.1,
          };

          return switch (randomNum + fundamentalBonus + rankBonus) {
            < 0.1 => -5,
            < 0.2 => -4,
            < 0.3 => -3,
            < 0.4 => -2,
            < 0.5 => -1,
            < 0.6 => 0,
            < 0.7 => 1,
            < 0.8 => 2,
            < 0.9 => 3,
            < 0.95 => 4,
            _ => 5,
          };
        }

        Team newTeam = Team(
          name: team.name,
          att: max(team.att + getValue(randomNum: ranAtt, fundamental: fundamental, rankBefore: index), 5),
          mid: max(team.mid + getValue(randomNum: ranMid, fundamental: fundamental, rankBefore: index), 5),
          def: max(team.def + getValue(randomNum: ranDef, fundamental: fundamental, rankBefore: index), 5),
          fundamental: fundamental,
          attPercent: team.attPercent,
          playStyle: team.playStyle,
        );

        index++;

        return newTeam;
      }).toList();
    }
  }

  void creatRound() {
    teamSetting();
    _finishedRound = false;
    _round = 0;
    _matchs = roundRobin(teams: _teams);
    setState(() {});
    _finishedLeague = false;

    if (_autoPlay) {
      playGame();
    }
  }

  void nextRound() {
    if (_finishedRound) {
      setState(() {
        if (_finishedLeague) {
          _record.add(_teams);
          creatRound();
        } else {
          if (_matchs.length - 1 > _round) {
            _finishedRound = false;
            _round++;
          }

          if (_matchs.length - 1 == _round) _finishedLeague = true;

          if (_autoPlay) {
            playGame();
          }
        }
      });
    }
  }

  List<List<Fixture>> roundRobin({required List teams}) {
    List<List<Fixture>> rounds = [];

    int n = teams.length;
    if (n % 2 != 0) {
      teams.add(0); // BYE는 경기가 없는 팀을 의미합니다.
      n++;
    }

    for (int round = 0; round < (n - 1) * 2; round++) {
      List<Fixture> games = [];

      bool firshHalfRound = round < (n - 1);

      for (int i = 0; i < n / 2; i++) {
        if (firshHalfRound) {
          games.add(Fixture(team1: teams[i], team2: teams[n - 1 - i]));
        } else {
          games.add(Fixture(team1: teams[n - 1 - i], team2: teams[i]));
        }
      }

      rounds.add(games);
      games = [];

      teams.insert(1, teams.removeLast());
    }
    List<List<Fixture>> firstHalfRounds = rounds.sublist(0, (rounds.length / 2).round());
    List<List<Fixture>> secondHalfRounds = rounds.sublist((rounds.length / 2).round());

    firstHalfRounds.shuffle();
    secondHalfRounds.shuffle();

    return [...firstHalfRounds, ...secondHalfRounds];
  }

  playGame() async {
    if (!_finishedRound) {
      List<Fixture> matchs = _matchs[_round];

      _matchs[_round] = matchs.map((match) => game(match: match)).toList();

      setState(() {
        _finishedRound = true;
      });

      if (_autoPlay) {
        await Future.delayed(_autoPlaySpeed);
        nextRound();
      }
    }
  }

  Fixture game({required Fixture match}) {
    Team team1 = match.team1;
    Team team2 = match.team2;
    double ranNum = Random().nextDouble();
    int team1Score = 0;
    int team2Score = 0;

    double getAttPoewr({required int att, required int mid}) => (att * 0.17 + mid * 0.3);
    double getDefPower({required int def, required int mid}) => (def * 1.45 + mid * 0.35);

    double team1Att = getAttPoewr(att: team1.att, mid: team1.mid);
    double team1Def = getDefPower(def: team1.def, mid: team1.mid);
    double team2Att = getAttPoewr(att: team2.att, mid: team2.mid);
    double team2Def = getDefPower(def: team2.def, mid: team2.mid);

    //10분이 지날수록 공격 시도 횟수 보정;
    double timerBonus = 0.1;

    List.generate(10, (index) {
      bool team1Goal = false;
      bool team2Goal = false;

      ranNum = Random().nextDouble();
      if (ranNum < team1.attPercent - (1 - team2.attPercent) + timerBonus) {
        ranNum = Random().nextDouble();
        team1Goal = team1Att / (team2Def) > ranNum + team1Score / 10;
      }

      ranNum = Random().nextDouble();
      if (ranNum < team2.attPercent - (1 - team1.attPercent) + timerBonus) {
        ranNum = Random().nextDouble();
        team2Goal = team2Att / team1Def > ranNum + team2Score / 10;
      }

      if (team1Goal) team1Score++;
      if (team2Goal) team2Score++;
      timerBonus += 0.1;
    });

    if (team1Score > team2Score) {
      match.team1.win();
      match.team2.lose();
    } else if (team1Score < team2Score) {
      match.team2.win();
      match.team1.lose();
    } else {
      match.team2.draw();
      match.team1.draw();
    }

    match.team1.gf += team1Score;
    match.team1.ga += team2Score;
    match.team1.gd += (team1Score - team2Score);

    match.team2.gf += team2Score;
    match.team2.ga += team1Score;
    match.team2.gd += (team2Score - team1Score);

    match.team1Score = team1Score;
    match.team2Score = team2Score;

    _teams.sort((a, b) {
      if (a.pts == b.pts) {
        return a.gd > b.gd ? 0 : 1;
      } else {
        return a.pts > b.pts ? 0 : 1;
      }
    });

    return match;
  }

  Iterable<Fixture> getMainGames({required List<Fixture> games}) {
    if (!_showMainGame) return games;
    findIndex({required Team target}) => _teams.indexWhere((team) => team.name == target.name);

    List<Fixture> mainGames = [...games.where((game) => findIndex(target: game.team1) < 5 || findIndex(target: game.team2) < 5)];

    mainGames.sort((a, b) {
      return max(a.team1.pts, a.team2.pts) > max(b.team1.pts, b.team2.pts) ? 0 : 1;
    });

    return mainGames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Text(
              'Round : ${_round + 1}',
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
                      if (_matchs.isNotEmpty)
                        ...getMainGames(games: _matchs[_round])
                            .map(
                              (match) => Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: GameCard(
                                  fixture: match,
                                  isPlayed: _finishedRound,
                                  showDetail: _showDetail,
                                  teams: _teams,
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
            LeageTable(teams: _teams),
            ..._record
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
