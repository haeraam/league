import 'dart:math';

import 'package:leage_simulator/entities/club/club.dart';

class Fixture {
  Fixture({
    required this.homeClub,
    required this.awayClub,
  });
  final Club homeClub;
  final Club awayClub;
  int homeClubScore = 0;
  int awayClubScore = 0;
  bool played = false;

  play() {
    if (played) return;
    double ranNum = 0.0;

    //10분이 지날수록 공격 시도 횟수 보정;
    double timerBonus = 0.1;

    List.generate(10, (index) {
      bool homeClubGoal = false;
      bool awayClubGoal = false;

      ranNum = Random().nextDouble();
      if (ranNum < homeClub.attPercent - (1 - awayClub.attPercent) + timerBonus) {
        ranNum = Random().nextDouble();
        homeClubGoal = homeClub.attPower / (awayClub.defPower) > ranNum + homeClubScore / 10;
      }

      ranNum = Random().nextDouble();
      if (ranNum < awayClub.attPercent - (1 - homeClub.attPercent) + timerBonus) {
        ranNum = Random().nextDouble();
        awayClubGoal = awayClub.attPercent / homeClub.defPower > ranNum + awayClubScore / 10;
      }

      if (homeClubGoal) homeClubScore++;
      if (awayClubGoal) awayClubScore++;
      timerBonus += 0.1;
    });

    homeClub.play(scored: homeClubScore, conceded: awayClubScore);
    awayClub.play(scored: awayClubScore, conceded: homeClubScore);
    played = true;
  }

  @override
  String toString() {
    return '$homeClub , $awayClub';
  }
}
