import 'dart:math';

import 'package:leage_simulator/entities/fixture/fixture.dart';
import 'package:leage_simulator/entities/club/club.dart';

class League {
  League({required this.clubs}) {
    _initialClub = [...clubs];
    startNewSeason();
  }
  int round = 0;
  List<List<Fixture>> season = [];
  late final List<Club> _initialClub;
  List<Club> clubs;
  List<List<Club>> record = [];
  List<List<List<Fixture>>> fixtureRecord = [];
  bool finishedRound = false;
  bool finishedLeague = true;

  allReset() {
    clubs = [..._initialClub];
    record = [];
    season = [];
    finishedRound = false;
    finishedLeague = true;
    startNewSeason();
  }

  void startNewSeason() {
    _clubSetting();
    round = 0;
    season = _createFixtures(clubs: clubs);
    finishedRound = false;
    finishedLeague = false;
  }

  List<List<Fixture>> _createFixtures({required List clubs}) {
    List<List<Fixture>> rounds = [];

    int n = clubs.length;
    // if (n % 2 != 0) {
    //   clubs.add(0); // BYE는 경기가 없는 팀을 의미합니다.
    //   n++;
    // }

    for (int round = 0; round < (n - 1) * 2; round++) {
      List<Fixture> games = [];

      bool firshHalfRound = round < (n - 1);

      for (int i = 0; i < n / 2; i++) {
        if (firshHalfRound) {
          games.add(Fixture(homeClub: clubs[i], awayClub: clubs[n - 1 - i]));
        } else {
          games.add(Fixture(homeClub: clubs[n - 1 - i], awayClub: clubs[i]));
        }
      }

      rounds.add(games);
      games = [];

      clubs.insert(1, clubs.removeLast());
    }
    List<List<Fixture>> firstHalfRounds = rounds.sublist(0, (rounds.length / 2).round());
    List<List<Fixture>> secondHalfRounds = rounds.sublist((rounds.length / 2).round());

    firstHalfRounds.shuffle();
    secondHalfRounds.shuffle();

    return [...firstHalfRounds, ...secondHalfRounds];
  }

  void _clubSetting() {
    int index = 0;
    List<Club> ratedByFundamental = ([...clubs]..sort(
        (a, b) => a.fundamental > b.fundamental ? 0 : 1,
      ));

    clubs = clubs.map((club) {
      double fundamental = club.fundamental;

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
        int idx = ratedByFundamental.indexWhere((fClub) => club.name == fClub.name);
        double fundamentalBonus = switch (idx) {
          0 => 0.21,
          1 => 0.175,
          2 => 0.145,
          3 => 0.1,
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
          < 17 => 0.065,
          _ => 0.12,
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

      Club newClub = Club(
        name: club.name,
        att: max(club.att + getValue(randomNum: ranAtt, fundamental: fundamental, rankBefore: index), 5),
        mid: max(club.mid + getValue(randomNum: ranMid, fundamental: fundamental, rankBefore: index), 5),
        def: max(club.def + getValue(randomNum: ranDef, fundamental: fundamental, rankBefore: index), 5),
        fundamental: fundamental,
        attPercent: club.attPercent,
        playStyle: club.playStyle,
        homeColor: club.homeColor,
        awayColor: club.awayColor,
        country: club.country,
        leagueTier: club.leagueTier,
      );

      index++;

      return newClub;
    }).toList();
  }

  void nextRound() {
    if (finishedRound) {
      if (finishedLeague) {
        record.add(clubs);
        fixtureRecord.add(season);
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

  playAllFixture() async {
    if (!finishedRound) {
      for (var fixture in season[round]) {
        fixture.autoPlay();
      }

      clubs.sort((a, b) {
        if (a.pts == b.pts) {
          return a.gd > b.gd ? 0 : 1;
        } else {
          return a.pts > b.pts ? 0 : 1;
        }
      });

      finishedRound = true;
    }
  }
}
