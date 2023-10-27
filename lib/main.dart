// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
    this.win = 0,
    this.drow = 0,
    this.lose = 0,
    required this.att,
    required this.mid,
    required this.def,
  });
  final String name;
  int pts;
  int win;
  int drow;
  int lose;

  final int att;
  final int mid;
  final int def;

  @override
  String toString() {
    return '$name , $win , $drow , $lose';
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

  List<Team> teamData = [
    Team(name: '토트넘', att: 100, def: 100, mid: 100),
    Team(name: '맨시티', att: 100, def: 100, mid: 100),
    Team(name: '아스날', att: 100, def: 100, mid: 100),
    Team(name: '리버풀', att: 100, def: 100, mid: 100),
    Team(name: '아스톤빌라', att: 100, def: 100, mid: 100),
    Team(name: '뉴캐슬', att: 100, def: 100, mid: 100),
    Team(name: '브라이튼', att: 100, def: 100, mid: 100),
    Team(name: '맨유', att: 100, def: 100, mid: 100),
    Team(name: '웨스트햄', att: 100, def: 100, mid: 100),
    Team(name: '첼시', att: 100, def: 100, mid: 100),
    Team(name: '크팰', att: 100, def: 100, mid: 100),
    Team(name: '울버햄튼', att: 100, def: 100, mid: 100),
    Team(name: '풀럼', att: 100, def: 100, mid: 100),
    Team(name: '브랜트포드', att: 100, def: 100, mid: 100),
    Team(name: '노팅엄', att: 100, def: 100, mid: 100),
    Team(name: '에버턴', att: 100, def: 100, mid: 100),
    Team(name: '루턴', att: 100, def: 100, mid: 100),
    Team(name: '번리', att: 100, def: 100, mid: 100),
    Team(name: '본머스', att: 100, def: 100, mid: 100),
    Team(name: '쉐필드', att: 100, def: 100, mid: 100),
  ];

  void creatRound() {
    _round = 0;
    _matchs = roundRobin(teams: teamData);
    _matchs.shuffle();
    setState(() {});
  }

  void nextRound() {
    setState(() {
      if (_matchs.length - 1 > _round) {
        _finishedRound = false;
        _round++;
      }
    });
  }

  List<List<Match>> roundRobin({required List teams}) {
    List<List<Match>> res = [];

    int n = teams.length;
    if (n % 2 != 0) {
      teams.add(0); // BYE는 경기가 없는 팀을 의미합니다.
      n++;
    }

    print('리그전 대진표: ');
    for (int round = 0; round < n - 1; round++) {
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

      print(_matchs);
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

    double getAttPoewr({required int att, required int mid}) => (att + mid / 2) * 0.1;
    double getDefPower({required int def, required int mid}) => (def + mid / 1.5);

    List.generate(10, (index) {
      double team1Att = getAttPoewr(att: team1.att, mid: team1.mid);
      double team1Def = getDefPower(def: team1.def, mid: team1.mid);
      double team2Att = getAttPoewr(att: team2.att, mid: team2.mid);
      double team2Def = getDefPower(def: team2.def, mid: team2.mid);

      ranNum = Random().nextDouble();
      bool team1Goal = team1Att / (team1Att + team2Def) > ranNum;
      ranNum = Random().nextDouble();
      bool team2Goal = team2Att / (team2Att + team1Def) > ranNum;

      if (team1Goal) team1Score++;
      if (team2Goal) team2Score++;
    });

    if (team1Score > team2Score) {
      match.team1.win += 1;
      match.team2.lose += 1;
    } else if (team1Score < team2Score) {
      match.team2.win += 1;
      match.team1.lose += 1;
    } else {
      match.team2.drow += 1;
      match.team1.drow += 1;
    }

    match.team1Score = team1Score;
    match.team2Score = team2Score;

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
                  style: TextStyle(fontSize: 25),
                ),
                if (_matchs.isNotEmpty)
                  ..._matchs[_round]
                      .map(
                        (match) => Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TeamCard(team: match.team1),
                              if (_finishedRound) Text('${match.team1Score}'),
                              Text('vs'),
                              if (_finishedRound) Text('${match.team2Score}'),
                              TeamCard(
                                team: match.team2,
                                nameFirst: true,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList()
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20).add(
            const EdgeInsets.only(bottom: 40),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(onPressed: creatRound, child: const Text('대진표 생성')),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: ElevatedButton(onPressed: playGame, child: const Text('라운드 진행')),
              ),
              SizedBox(
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

class TeamCard extends StatelessWidget {
  const TeamCard({super.key, required this.team, this.nameFirst = false});
  final Team team;
  final bool nameFirst;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      if (nameFirst)
        Text(
          team.name,
          style: TextStyle(fontSize: 20),
        ),
      Text('${team.win} 승'),
      Text('${team.drow} 무'),
      Text('${team.lose} 패'),
      if (!nameFirst)
        Text(
          team.name,
          style: TextStyle(fontSize: 20),
        ),
    ]);
  }
}
