import 'dart:math';

import 'package:leage_simulator/entities/league/fixture.dart';
import 'package:leage_simulator/entities/team/team.dart';

class League {
  League({required this.teams}) {
    _initialTeam = [...teams];
    startNewSeason();
  }
  int round = 0;
  List<List<Fixture>> season = [];
  late final List<Team> _initialTeam;
  List<Team> teams;
  List<List<Team>> record = [];
  bool finishedRound = false;
  bool finishedLeague = true;

  allReset() {
    teams = [..._initialTeam];
    record = [];
    season = [];
    finishedRound = false;
    finishedLeague = true;
  }

  void startNewSeason() {
    _teamSetting();
    round = 0;
    season = _createFixtures(teams: teams);
    finishedRound = false;
    finishedLeague = false;
  }

  List<List<Fixture>> _createFixtures({required List teams}) {
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

  void _teamSetting() {
    int index = 0;
    List<Team> ratedByFundamental = ([...teams]..sort(
        (a, b) => a.fundamental > b.fundamental ? 0 : 1,
      ));

    teams = teams.map((team) {
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

  void nextRound() {
    if (finishedRound) {
      if (finishedLeague) {
        record.add(teams);
        startNewSeason();
      } else {
        if (season.length - 1 > round) {
          finishedRound = false;
          round++;
        }

        if (season.length - 1 == round) finishedLeague = true;
      }
    }
  }

  playGame() async {
    if (!finishedRound) {
      List<Fixture> matchs = season[round];

      season[round] = matchs.map((match) => game(match: match)).toList();

      finishedRound = true;
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

    teams.sort((a, b) {
      if (a.pts == b.pts) {
        return a.gd > b.gd ? 0 : 1;
      } else {
        return a.pts > b.pts ? 0 : 1;
      }
    });

    return match;
  }
}
