import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leage_simulator/components/game_card.dart';
import 'package:leage_simulator/components/league_table.dart';
import 'package:leage_simulator/page/record_detail.dart';

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

enum PlayStyle {
  pass,
  press,
  counter,
  none,
}

class Team {
  Team({
    required this.name,
    this.pts = 0,
    this.won = 0,
    this.drawn = 0,
    this.lost = 0,
    this.gf = 0,
    this.ga = 0,
    this.gd = 0,
    this.winStack = 0,
    this.noLoseStack = 0,
    this.loseStack = 0,
    this.noWinStack = 0,
    required this.att,
    required this.mid,
    required this.def,
    this.playStyle = PlayStyle.none,
    this.attPercent = 0.5,
    this.fundamental = 0,
  }) {
    if (fundamental > 100) fundamental = 100;
  }
  final String name;
  int fundamental;
  int pts;
  int won;
  int drawn;
  int lost;

  int winStack;
  int noLoseStack;
  int loseStack;
  int noWinStack;

  int gf;
  int ga;
  int gd;

  int att;
  int mid;
  int def;
  double attPercent;
  PlayStyle playStyle;

  calcPts() {
    pts = won * 3 + drawn;
  }

  win() {
    won++;
    winStack++;
    noLoseStack++;
    noWinStack = 0;
    loseStack = 0;
    calcPts();
  }

  draw() {
    drawn++;
    noLoseStack++;
    noWinStack++;
    winStack = 0;
    loseStack = 0;
    calcPts();
  }

  lose() {
    lost++;
    loseStack++;
    noWinStack++;
    noLoseStack = 0;
    winStack = 0;
  }

  @override
  String toString() {
    return '$name , $won , $drawn , $lost';
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Game {
  final Team team1;
  final Team team2;
  int team1Score;
  int team2Score;
  Game({
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

class _MyHomePageState extends State<MyHomePage> {
  int _round = 0;
  List<List<Game>> _matchs = [];
  bool _finishedRound = false;
  bool _autoPlay = false;
  bool _autoPlayFast = false;
  bool _showMainGame = false;
  bool _finishedLeague = true;
  bool _showDetail = true;
  Duration _autoPlaySpeed = const Duration(milliseconds: 300);

  Team createTeam({
    required String name,
    required int att,
    required int mid,
    required int def,
    fundamental = 0,
    double attPercent = 0.5,
  }) {
    return Team(
      name: name,
      att: att,
      def: def,
      mid: mid,
      attPercent: attPercent,
      fundamental: fundamental,
    );
  }

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

  final List<String> _teamData = [
    '토트넘',
    '맨시티',
    '아스날',
    '리버풀',
    '아스톤빌라',
    '뉴캐슬',
    '브라이튼',
    '맨유',
    '웨스트햄',
    '첼시',
    '크팰',
    '울버햄튼',
    '풀럼',
    '브랜트포드',
    '노팅엄',
    '에버턴',
    '루턴',
    '번리',
    '본머스',
    '쉐필드',
  ];

  void teamSetting() {
    if (_teams.isEmpty) {
      _teams = [
        createTeam(name: '토트넘', att: 80, mid: 50, def: 60, fundamental: 20),
        createTeam(name: '맨시티', att: 90, mid: 90, def: 90, fundamental: 30),
        createTeam(name: '아스날', att: 90, mid: 80, def: 100, fundamental: 60),
        createTeam(name: '리버풀', att: 100, mid: 70, def: 80, fundamental: 60),
        createTeam(name: '아스톤빌라', att: 50, mid: 50, def: 50),
        createTeam(name: '뉴캐슬', att: 50, mid: 50, def: 50, fundamental: 10),
        createTeam(name: '브라이튼', att: 50, mid: 50, def: 50),
        createTeam(name: '맨유', att: 40, mid: 40, def: 40, fundamental: 70),
        createTeam(name: '웨스트햄', att: 40, mid: 40, def: 40),
        createTeam(name: '첼시', att: 40, mid: 40, def: 40, fundamental: 20),
        createTeam(name: '크팰', att: 35, mid: 35, def: 35),
        createTeam(name: '울버햄튼', att: 35, mid: 35, def: 35),
        createTeam(name: '풀럼', att: 50, mid: 30, def: 30, attPercent: 0.8),
        createTeam(name: '브랜트포드', att: 30, mid: 30, def: 30, attPercent: 0.1),
        createTeam(name: '노팅엄', att: 30, mid: 30, def: 30),
        createTeam(name: '에버턴', att: 30, mid: 30, def: 30),
        createTeam(name: '루턴', att: 30, mid: 20, def: 20),
        createTeam(name: '번리', att: 20, mid: 20, def: 40, attPercent: 0.2),
        createTeam(name: '본머스', att: 20, mid: 20, def: 20),
        createTeam(name: '쉐필드', att: 20, mid: 20, def: 20),
      ];
    } else {
      int index = 0;
      _teams = _teams.map((team) {
        int fundamental = team.fundamental > 80 ? team.fundamental - 5 : team.fundamental;

        if (index == 0) {
          fundamental = fundamental + 5;
        } else if (index == 1) {
          fundamental = fundamental + 3;
        } else if (index < 4) {
          fundamental = fundamental + 2;
        } else if (index < 6) {
          fundamental = fundamental + 1;
        }

        int rowRankBonus = (++index * 0.58).floor();
        int fundermantalBonus = (team.fundamental / 5.2).floor();

        int att = team.att + Random().nextInt(5 + fundermantalBonus) - (8 + Random().nextInt(max(fundermantalBonus - 13, 1))) + rowRankBonus;
        int mid = team.mid + Random().nextInt(5 + fundermantalBonus) - (8 + Random().nextInt(max(fundermantalBonus - 13, 1))) + rowRankBonus;
        int def = team.def + Random().nextInt(5 + fundermantalBonus) - (8 + Random().nextInt(max(fundermantalBonus - 13, 1))) + rowRankBonus;

        return Team(
          name: team.name,
          att: min(max(att, 0), 200),
          mid: min(max(mid, 0), 200),
          def: min(max(def, 0), 200),
          fundamental: min(fundamental, 100),
        );
      }).toList();
    }
  }

  void creatRound() {
    if (_finishedLeague) {
      teamSetting();
      _finishedRound = false;
      _round = 0;
      _matchs = roundRobin(teams: _teams);
      _matchs.shuffle();
      setState(() {});
      _finishedLeague = false;

      if (_autoPlay) {
        playGame();
      }
    }
  }

  void nextRound() {
    if (_finishedRound) {
      setState(() {
        if (_matchs.length - 1 > _round) {
          _finishedRound = false;
          _round++;
        }

        if (_matchs.length - 1 == _round) _finishedLeague = true;
      });

      if (_round == 37) {
        _record.add(_teams);
        creatRound();
      }

      if (_autoPlay) {
        playGame();
      }
    }
  }

  List<List<Game>> roundRobin({required List teams}) {
    List<List<Game>> res = [];

    int n = teams.length;
    if (n % 2 != 0) {
      teams.add(0); // BYE는 경기가 없는 팀을 의미합니다.
      n++;
    }

    for (int round = 0; round < (n - 1) * 2; round++) {
      List<Game> rounds = [];

      for (int i = 0; i < n / 2; i++) {
        rounds.add(Game(team1: teams[i], team2: teams[n - 1 - i]));
      }

      rounds.shuffle();

      res.add(rounds);
      rounds = [];

      teams.insert(1, teams.removeLast());
    }

    return res;
  }

  playGame() async {
    if (!_finishedRound) {
      List<Game> matchs = _matchs[_round];

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

  Game game({required Game match}) {
    Team team1 = match.team1;
    Team team2 = match.team2;
    double ranNum = Random().nextDouble();
    int team1Score = 0;
    int team2Score = 0;

    double getAttPoewr({required int att, required int mid}) => (att + mid / 2) * 0.2;
    double getDefPower({required int def, required int mid}) => (def * 1.5 + mid / 1.5);

    double team1Att = getAttPoewr(att: team1.att, mid: team1.mid);
    double team1Def = getDefPower(def: team1.def, mid: team1.mid);
    double team2Att = getAttPoewr(att: team2.att, mid: team2.mid);
    double team2Def = getDefPower(def: team2.def, mid: team2.mid);

    List.generate(team1.winStack, (index) {
      if (Random().nextDouble() > 0.5) {
        team1Att = team1Att * 1.05;
        team2Def = team2Def * 0.98;
      }

      if (Random().nextDouble() > 0.9) {
        team1Def = team1Def * 0.5;
      }
    });

    List.generate(team2.winStack, (index) {
      if (Random().nextDouble() > 0.5) {
        team2Att = team2Att * 1.05;
        team1Def = team1Def * 0.98;
      }

      if (Random().nextDouble() > 0.9) {
        team2Def = team2Def * 0.5;
      }
    });

    List.generate(team1.loseStack, (index) {
      if (Random().nextDouble() > 0.7) {
        team1Def = team1Def * 1.1;
      }

      if (Random().nextDouble() > 0.95) {
        team1Att = team1Att * 1.5;
      }
    });
    List.generate(team2.loseStack, (index) {
      if (Random().nextDouble() > 0.7) {
        team2Def = team2Def * 1.1;
      }

      if (Random().nextDouble() > 0.95) {
        team2Att = team2Att * 1.5;
      }
    });

    team1Att = team1Att * (0.2 + team1.attPercent);
    team1Def = team1Def * (1.1 - team1.attPercent);

    team2Att = team2Att * (0.2 + team2.attPercent);
    team2Def = team2Def * (1.1 - team2.attPercent);

    List.generate(10, (index) {
      ranNum = Random().nextDouble();
      bool team1Goal = team1Att / (team1Att + team2Def + team1Score * 40) > ranNum;
      ranNum = Random().nextDouble();
      bool team2Goal = team2Att / (team2Att + team1Def + team2Score * 40) > ranNum;

      if (team1Goal) team1Score++;
      if (team2Goal) team2Score++;
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

  Iterable<Game> getMainGames({required List<Game> games}) {
    if (!_showMainGame) return games;
    findIndex({required Team target}) => _teams.indexWhere((team) => team.name == target.name);

    List<Game> mainGames = [...games.where((game) => findIndex(target: game.team1) < 5 || findIndex(target: game.team2) < 5)];

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
                                  game: match,
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
