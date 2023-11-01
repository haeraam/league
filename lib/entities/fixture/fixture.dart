// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  bool isHomeOwnBall = true;
  int playTime = 0;
  int homeBallPercent = 0;
  int awayBallPercent = 0;
  double buildUpBonus = 0;

  still() {
    double totalPower = homeClub.power + awayClub.power;
    if (Random().nextDouble() > (isHomeOwnBall ? homeClub.power / totalPower : awayClub.power / totalPower)) {
      buildUpBonus = 0;
      isHomeOwnBall = !isHomeOwnBall;
    }
  }

  GroundArea longPass({required GroundArea from, required GroundArea to}) {
    if (Random().nextDouble() > 0.8) {
      return to;
    }
    still();
    return from;
  }

  GroundArea throughPass({required GroundArea from, required GroundArea to}) {
    if (Random().nextDouble() > 0.7) {
      return to;
    }
    still();
    return from;
  }

  GroundArea cross({required GroundArea from, required GroundArea to}) {
    if (Random().nextDouble() > 0.75) {
      return to;
    }
    still();
    return from;
  }

  GroundArea buildUpPass({required GroundArea from, required GroundArea to}) {
    if (Random().nextDouble() > 0.1) {
      return to;
    }
    still();
    buildUpBonus += 0.01;
    return from;
  }

  GroundArea shoot({required GroundArea from}) {
    if (Random().nextDouble() < 0.02 + buildUpBonus) {
      isHomeOwnBall ? homeClubScore++ : awayClubScore++;
      isHomeOwnBall = !isHomeOwnBall;
      return GroundArea();
    } else {
      return from;
    }
  }

  GroundArea playCenter({required GroundArea ballLocation}) {
    Vertical successFront = isHomeOwnBall ? Vertical.away : Vertical.home;
    double ranNum = Random().nextDouble();

    return switch (ranNum) {
      < 0.1 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: successFront)),
      < 0.2 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: successFront)),
      < 0.3 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: successFront)),
      < 0.4 => longPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: successFront)),
      < 0.5 => longPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: successFront)),
      < 0.6 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: Vertical.center)),
      < 0.7 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: Vertical.center)),
      _ => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: Vertical.center)),
    };
  }

  GroundArea playCenterHalfSpace({required GroundArea ballLocation}) {
    Vertical successFront = isHomeOwnBall ? Vertical.away : Vertical.home;
    double ranNum = Random().nextDouble();

    return switch (ranNum) {
      < 0.1 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: successFront)),
      < 0.3 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: successFront)),
      < 0.6 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: successFront)),
      < 0.7 => longPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: successFront)),
      < 0.8 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: Vertical.center)),
      _ => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: Vertical.center)),
    };
  }

  GroundArea playCenterSide({required GroundArea ballLocation}) {
    Vertical successFront = isHomeOwnBall ? Vertical.away : Vertical.home;
    double ranNum = Random().nextDouble();

    return switch (ranNum) {
      < 0.55 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: successFront)),
      < 0.15 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: successFront)),
      < 0.6 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: successFront)),
      < 0.65 => longPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: successFront)),
      < 0.8 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: Vertical.center)),
      _ => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: Vertical.center)),
    };
  }

  GroundArea playDefenceCenter({required GroundArea ballLocation}) {
    Vertical successFront = isHomeOwnBall ? Vertical.away : Vertical.home;
    double ranNum = Random().nextDouble();

    return switch (ranNum) {
      < 0.1 => longPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: successFront)),
      < 0.2 => longPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: successFront)),
      < 0.6 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: Vertical.center)),
      < 0.7 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: Vertical.center)),
      < 1.4 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: ballLocation.v)),
      _ => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: ballLocation.v)),
    };
  }

  GroundArea playDefenceSide({required GroundArea ballLocation}) {
    Vertical successFront = isHomeOwnBall ? Vertical.away : Vertical.home;
    double ranNum = Random().nextDouble();

    return switch (ranNum) {
      < 0.1 => longPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: successFront)),
      < 0.2 => longPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: successFront)),
      < 0.3 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: Vertical.center)),
      < 0.6 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: Vertical.center)),
      < 0.8 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: ballLocation.v)),
      _ => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: ballLocation.v)),
    };
  }

  GroundArea playDefenceHalfSpace({required GroundArea ballLocation}) {
    Vertical successFront = isHomeOwnBall ? Vertical.away : Vertical.home;
    double ranNum = Random().nextDouble();

    return switch (ranNum) {
      < 0.1 => longPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: successFront)),
      < 0.2 => longPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: successFront)),
      < 0.3 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: Vertical.center)),
      < 0.6 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: Vertical.center)),
      < 0.8 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: ballLocation.v)),
      _ => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: ballLocation.v)),
    };
  }

  GroundArea playAttackCenter({required GroundArea ballLocation}) {
    double ranNum = Random().nextDouble();

    return switch (ranNum) {
      < 0.7 => shoot(from: ballLocation),
      _ => throughPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: ballLocation.v)),
    };
  }

  GroundArea playAttackSide({required GroundArea ballLocation}) {
    double ranNum = Random().nextDouble();

    return switch (ranNum) {
      < 0.7 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: ballLocation.v)),
      < 0.3 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: ballLocation.v)),
      _ => cross(from: ballLocation, to: GroundArea(h: Horizental.center, v: ballLocation.v)),
    };
  }

  GroundArea playAttackHalfSpace({required GroundArea ballLocation}) {
    double ranNum = Random().nextDouble();

    return switch (ranNum) {
      < 0.3 => shoot(from: ballLocation),
      < 0.7 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: ballLocation.v)),
      _ => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: ballLocation.v)),
    };
  }

  play() async {
    if (played) return;
    GroundArea ballLocation = GroundArea();
    double time = 0;
    while (time < 100) {
      switch (ballLocation.v) {
        case Vertical.home:
          switch (ballLocation.h) {
            case Horizental.side:
              ballLocation = isHomeOwnBall ? playDefenceSide(ballLocation: ballLocation) : playAttackSide(ballLocation: ballLocation);
              break;
            case Horizental.halfSpace:
              ballLocation = isHomeOwnBall ? playDefenceHalfSpace(ballLocation: ballLocation) : playAttackHalfSpace(ballLocation: ballLocation);
              break;
            case Horizental.center:
              ballLocation = isHomeOwnBall ? playDefenceCenter(ballLocation: ballLocation) : playAttackCenter(ballLocation: ballLocation);
              break;
          }
          break;
        case Vertical.center:
          switch (ballLocation.h) {
            case Horizental.side:
              ballLocation = playCenterSide(ballLocation: ballLocation);
              break;
            case Horizental.halfSpace:
              ballLocation = playCenterHalfSpace(ballLocation: ballLocation);
              break;
            case Horizental.center:
              ballLocation = playCenter(ballLocation: ballLocation);
              break;
          }
          break;
        case Vertical.away:
          switch (ballLocation.h) {
            case Horizental.side:
              ballLocation = !isHomeOwnBall ? playDefenceSide(ballLocation: ballLocation) : playAttackSide(ballLocation: ballLocation);
              break;
            case Horizental.halfSpace:
              ballLocation = !isHomeOwnBall ? playDefenceHalfSpace(ballLocation: ballLocation) : playAttackHalfSpace(ballLocation: ballLocation);
              break;
            case Horizental.center:
              ballLocation = !isHomeOwnBall ? playDefenceCenter(ballLocation: ballLocation) : playAttackCenter(ballLocation: ballLocation);
              break;
          }
          break;
      }
      time += 0.5;
      isHomeOwnBall ? homeBallPercent++ : awayBallPercent++;
    }

    homeClub.saveResult(scored: homeClubScore, conceded: awayClubScore);
    awayClub.saveResult(scored: awayClubScore, conceded: homeClubScore);
    played = true;
  }

  @override
  String toString() {
    return '$homeClub , $awayClub';
  }
}

class GroundArea {
  final Vertical v;
  final Horizental h;
  GroundArea({
    this.v = Vertical.center,
    this.h = Horizental.center,
  });

  @override
  String toString() {
    return '$v $h';
  }
}

enum Vertical { home, center, away }

enum Horizental { side, halfSpace, center }
