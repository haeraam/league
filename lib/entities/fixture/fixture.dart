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

  still() {
    isHomeOwnBall = !isHomeOwnBall;
  }

  double getBonus(Vertical v) {
    double bonus;
    if (isHomeOwnBall) {
      bonus = switch (v) {
        Vertical.away => homeClub.att / awayClub.def,
        Vertical.center => homeClub.mid / awayClub.mid,
        Vertical.home => homeClub.def / awayClub.att,
      };
    } else {
      bonus = switch (v) {
        Vertical.away => awayClub.def / homeClub.att,
        Vertical.center => awayClub.mid / homeClub.mid,
        Vertical.home => awayClub.att / homeClub.def,
      };
    }

    return sqrt(bonus * 2) / 2;
  }

  GroundArea longPass({required GroundArea from, required GroundArea to}) {
    double fromBonus = getBonus(from.v) * 0.15;
    double toBonus = getBonus(to.v) * 0.1;
    if (Random().nextDouble() > (-0.1 + fromBonus + toBonus)) {
      still();
    }
    return to;
  }

  GroundArea throughPass({required GroundArea from, required GroundArea to}) {
    double fromBonus = getBonus(from.v) * 0.25;
    double toBonus = getBonus(to.v) * 0.15;
    if (Random().nextDouble() > 0.2 + fromBonus + toBonus) {
      still();
    }
    return to;
  }

  GroundArea cross({required GroundArea from, required GroundArea to}) {
    double fromBonus = getBonus(from.v) * 0.05;
    double toBonus = getBonus(to.v) * 0.1;
    if (Random().nextDouble() > 0.2 + fromBonus + toBonus) {
      still();
    }
    return to;
  }

  GroundArea shoot({required GroundArea from}) {
    print('/////////// shoot/////////// ');
    double fromBonus = sqrt(getBonus(from.v) * 20) / 20;
    print(fromBonus);
    if (Random().nextDouble() < 0.05 + fromBonus) {
      isHomeOwnBall ? homeClubScore++ : awayClubScore++;
      isHomeOwnBall = !isHomeOwnBall;
      return GroundArea();
    } else {
      return from;
    }
  }

  GroundArea buildUpPass({required GroundArea from, required GroundArea to}) {
    double fromBonus = getBonus(from.v) * 0.4;
    double toBonus = getBonus(to.v) * 0.3;
    if (Random().nextDouble() > 0.4 + fromBonus + toBonus) {
      still();
    }
    return to;
  }

  GroundArea playCenter({required GroundArea ballLocation}) {
    Vertical successFront = isHomeOwnBall ? Vertical.away : Vertical.home;
    double ranNum = Random().nextDouble();

    return switch (ranNum) {
      < 0.15 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: successFront)),
      < 0.4 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: successFront)),
      < 0.6 => longPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: successFront)),
      < 0.8 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: Vertical.center)),
      _ => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: Vertical.center)),
    };
  }

  GroundArea playCenterHalfSpace({required GroundArea ballLocation}) {
    Vertical successFront = isHomeOwnBall ? Vertical.away : Vertical.home;
    double ranNum = Random().nextDouble();

    return switch (ranNum) {
      < 0.1 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: successFront)),
      < 0.4 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: successFront)),
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
      < 0.05 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: successFront)),
      < 0.15 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: successFront)),
      < 0.5 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: successFront)),
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
      < 0.3 => longPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: successFront)),
      < 0.5 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: Vertical.center)),
      < 0.7 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: Vertical.center)),
      < 0.9 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: ballLocation.v)),
      _ => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: ballLocation.v)),
    };
  }

  GroundArea playDefenceSide({required GroundArea ballLocation}) {
    Vertical successFront = isHomeOwnBall ? Vertical.away : Vertical.home;
    double ranNum = Random().nextDouble();

    return switch (ranNum) {
      < 0.1 => longPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: successFront)),
      < 0.3 => longPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: successFront)),
      < 0.4 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: Vertical.center)),
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
      < 0.3 => longPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: successFront)),
      < 0.4 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: Vertical.center)),
      < 0.6 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: Vertical.center)),
      < 0.8 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: ballLocation.v)),
      _ => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: ballLocation.v)),
    };
  }

  GroundArea playAttackCenter({required GroundArea ballLocation}) {
    double ranNum = Random().nextDouble();

    return switch (ranNum) {
      < 0.5 => shoot(from: ballLocation),
      _ => throughPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: ballLocation.v)),
    };
  }

  GroundArea playAttackSide({required GroundArea ballLocation}) {
    double ranNum = Random().nextDouble();

    return switch (ranNum) {
      < 0.2 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: ballLocation.v)),
      < 0.4 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: ballLocation.v)),
      _ => cross(from: ballLocation, to: GroundArea(h: Horizental.center, v: ballLocation.v)),
    };
  }

  GroundArea playAttackHalfSpace({required GroundArea ballLocation}) {
    double ranNum = Random().nextDouble();

    return switch (ranNum) {
      < 0.4 => shoot(from: ballLocation),
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
