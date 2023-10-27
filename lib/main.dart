import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
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
    this.loseStack = 0,
    required this.att,
    required this.mid,
    required this.def,
  });
  final String name;
  int pts;
  int won;
  int drawn;
  int lost;

  int winStack;
  int loseStack;

  int gf;
  int ga;
  int gd;

  int att;
  int mid;
  int def;

  @override
  String toString() {
    return '$name , $won , $drawn , $lost';
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Match {
  final Team team1;
  final Team team2;
  int team1Score;
  int team2Score;
  Match({
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
  List<List<Match>> _matchs = [];
  bool _finishedRound = false;
  bool _autoPlay = false;
  bool _finishedLeague = true;

  Team createTeam({required int max, int min = 0, required String name}) {
    return Team(
      name: name,
      att: Random().nextInt(max - min) + min,
      def: Random().nextInt(max - min) + min,
      mid: Random().nextInt(max - min) + min,
    );
  }

  List<Team> teamData = [];

  @override
  void initState() {
    teamSetting();
    super.initState();
  }

  void teamSetting() {
    teamData = [
      createTeam(name: '토트넘', max: 600, min: 250),
      createTeam(name: '맨시티', max: 800, min: 300),
      createTeam(name: '아스날', max: 750, min: 400),
      createTeam(name: '리버풀', max: 800, min: 350),
      createTeam(name: '아스톤빌라', max: 400, min: 200),
      createTeam(name: '뉴캐슬', max: 550, min: 300),
      createTeam(name: '브라이튼', max: 350, min: 300),
      createTeam(name: '맨유', max: 650, min: 250),
      createTeam(name: '웨스트햄', max: 500),
      createTeam(name: '첼시', max: 650, min: 250),
      createTeam(name: '크팰', max: 300),
      createTeam(name: '울버햄튼', max: 500),
      createTeam(name: '풀럼', max: 500),
      createTeam(name: '브랜트포드', max: 500),
      createTeam(name: '노팅엄', max: 200),
      createTeam(name: '에버턴', max: 200),
      createTeam(name: '루턴', max: 200),
      createTeam(name: '번리', max: 400),
      createTeam(name: '본머스', max: 200),
      createTeam(name: '쉐필드', max: 200),
    ];
  }

  void creatRound() {
    if (_finishedLeague) {
      teamSetting();
      _finishedRound = false;
      _round = 0;
      _matchs = roundRobin(teams: teamData);
      _matchs.shuffle();
      setState(() {});
      _finishedLeague = false;
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

      if (_autoPlay) {
        playGame();
      }
    }
  }

  List<List<Match>> roundRobin({required List teams}) {
    List<List<Match>> res = [];

    int n = teams.length;
    if (n % 2 != 0) {
      teams.add(0); // BYE는 경기가 없는 팀을 의미합니다.
      n++;
    }

    for (int round = 0; round < (n - 1) * 2; round++) {
      List<Match> rounds = [];

      for (int i = 0; i < n / 2; i++) {
        rounds.add(Match(team1: teams[i], team2: teams[n - 1 - i]));
      }

      rounds.shuffle();

      res.add(rounds);
      rounds = [];

      teams.insert(1, teams.removeLast());
    }

    return res;
  }

  playGame() {
    if (!_finishedRound) {
      List<Match> matchs = _matchs[_round];

      _matchs[_round] = matchs.map((match) => game(match: match)).toList();

      print(teamData);
      setState(() {
        _finishedRound = true;
      });
    }
  }

  Match game({required Match match}) {
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

    List.generate(10, (index) {
      ranNum = Random().nextDouble();
      bool team1Goal = team1Att / (team1Att + team2Def) > ranNum;
      ranNum = Random().nextDouble();
      bool team2Goal = team2Att / (team2Att + team1Def) > ranNum;

      if (team1Goal) team1Score++;
      if (team2Goal) team2Score++;
    });

    if (team1Score > team2Score) {
      match.team1.won += 1;
      match.team1.pts += 3;
      match.team1.winStack += 1;
      match.team1.loseStack = 0;

      match.team2.loseStack += 1;
      match.team2.winStack = 0;
      match.team2.lost += 1;
    } else if (team1Score < team2Score) {
      match.team2.won += 1;
      match.team2.pts += 3;
      match.team2.winStack += 1;
      match.team2.loseStack = 0;

      match.team1.loseStack += 1;
      match.team1.winStack = 0;
      match.team1.lost += 1;
    } else {
      match.team2.drawn += 1;
      match.team1.drawn += 1;
      match.team1.pts += 1;
      match.team2.pts += 1;

      match.team1.winStack = 0;
      match.team1.loseStack = 0;
      match.team2.winStack = 0;
      match.team2.loseStack = 0;
    }

    match.team1.gf += team1Score;
    match.team1.ga += team2Score;
    match.team1.gd += (team1Score - team2Score);

    match.team2.gf += team2Score;
    match.team2.ga += team1Score;
    match.team2.gd += (team2Score - team1Score);

    match.team1Score = team1Score;
    match.team2Score = team2Score;

    teamData.sort((a, b) {
      if (a.pts == b.pts) {
        return a.gd > b.gd ? 0 : 1;
      } else {
        return a.pts > b.pts ? 0 : 1;
      }
    });

    return match;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(children: [
        Expanded(
          child: Container(
            child: Column(
              children: [
                Text(
                  'Round : ${_round + 1}',
                  style: const TextStyle(fontSize: 25),
                ),
                if (_matchs.isNotEmpty)
                  ..._matchs[_round]
                      .map(
                        (match) => Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: MatchCard(match: match, showScore: _finishedRound),
                        ),
                      )
                      .toList(),
                const Row(),
                Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: teamData.length,
                    itemBuilder: (context, index) => Row(children: [
                      SizedBox(
                        width: 70,
                        child: Text(teamData[index].name),
                      ),
                      SizedBox(
                        width: 60,
                        child: Text(
                          'pts: ${teamData[index].pts}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          'W: ${teamData[index].won}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          'D: ${teamData[index].drawn}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          'L: ${teamData[index].lost}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: Text(
                          'gf: ${teamData[index].gf}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: Text(
                          'ga: ${teamData[index].ga}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: Text(
                          'gd: ${teamData[index].gd}',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ]),
                  ),
                )
              ],
            ),
          ),
        ),
        Checkbox(
            value: _autoPlay,
            onChanged: (check) {
              setState(() {
                _autoPlay = check ?? false;
              });
            }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20).add(
            const EdgeInsets.only(bottom: 40),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: creatRound,
                  child: const Text('대진표 생성'),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: ElevatedButton(onPressed: playGame, child: const Text('라운드 진행')),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: ElevatedButton(onPressed: nextRound, child: const Text('다음 라운드')),
              ),
            ],
          ),
        )
      ]),
    );
  }
}

class MatchCard extends StatelessWidget {
  const MatchCard({super.key, required this.showScore, required this.match});
  final bool showScore;
  final Match match;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TeamCard(
          team: match.team1,
          accent: [if (match.team1Score > match.team2Score) Accent.name],
        ),
        if (showScore)
          Text(
            '${match.team1Score}',
            // style: TextStyle(color: (match.team1Score > match.team2Score) ? Colors.red : null),
          ),
        const Text('vs'),
        if (showScore)
          Text(
            '${match.team2Score}',
            // style: TextStyle(color: (match.team2Score > match.team1Score) ? Colors.red : null),
          ),
        TeamCard(
          team: match.team2,
          accent: [if (match.team2Score > match.team1Score) Accent.name],
          nameFirst: true,
        ),
      ],
    );
  }
}

enum Accent {
  name,
  att,
  mid,
  def,
}

class TeamCard extends StatelessWidget {
  const TeamCard({super.key, required this.team, this.nameFirst = false, this.accent = const []});
  final Team team;
  final bool nameFirst;
  final List<Accent> accent;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      if (nameFirst) ...[
        Text(
          team.name,
          style: TextStyle(
            fontSize: 17,
            color: accent.contains(Accent.name) ? Colors.red : null,
          ),
        ),
        const Text('('),
        Text(
          '${team.winStack}',
          style: team.winStack > 3 ? const TextStyle(color: Colors.red) : null,
        ),
        const Text(','),
        Text(
          '${team.loseStack}',
          style: team.loseStack > 3 ? const TextStyle(color: Colors.blue) : null,
        ),
        const Text(')'),
      ],
      Text(
        '${team.att}/',
        style: const TextStyle(fontSize: 10),
      ),
      Text(
        '${team.mid}/',
        style: const TextStyle(fontSize: 10),
      ),
      Text(
        '${team.def}',
        style: const TextStyle(fontSize: 10),
      ),
      if (!nameFirst) ...[
        Text(
          team.name,
          style: TextStyle(
            fontSize: 17,
            color: accent.contains(Accent.name) ? Colors.red : null,
          ),
        ),
        const Text('('),
        Text(
          '${team.winStack}',
          style: team.winStack > 3 ? const TextStyle(color: Colors.red) : null,
        ),
        const Text(','),
        Text(
          '${team.loseStack}',
          style: team.loseStack > 3 ? const TextStyle(color: Colors.blue) : null,
        ),
        const Text(')'),
      ],
    ]);
  }
}
