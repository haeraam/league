// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:leage_simulator/entities/club/club.dart';
import 'package:leage_simulator/entities/club/enum.dart';

enum StillLevel {
  easy,
  normal,
  hard,
  veryHard,
}

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
  bool passLogging = false;
  GroundArea ballLocation = GroundArea();
  double time = 0;

  bool still({required GroundArea area, required StillLevel stillLevel}) {
    double attackerPower = switch (isHomeOwnBall) {
      true => switch (area.v) {
          Vertical.home => homeClub.def.toDouble(),
          Vertical.center => homeClub.mid.toDouble(),
          Vertical.away => homeClub.att.toDouble(),
        },
      false => switch (area.v) {
          Vertical.home => awayClub.att.toDouble(),
          Vertical.center => awayClub.mid.toDouble(),
          Vertical.away => awayClub.def.toDouble(),
        },
    };

    double defenderPower = switch (isHomeOwnBall) {
      true => switch (area.v) {
          Vertical.home => awayClub.att * 0.5,
          Vertical.center => awayClub.mid.toDouble(),
          Vertical.away => awayClub.def.toDouble(),
        },
      false => switch (area.v) {
          Vertical.home => homeClub.def * 0.5,
          Vertical.center => homeClub.mid.toDouble(),
          Vertical.away => homeClub.att.toDouble(),
        },
    };

    double stillLevelBonus = switch (stillLevel) {
      StillLevel.easy => 0.15,
      StillLevel.normal => 0.25,
      StillLevel.hard => 0.5,
      StillLevel.veryHard => 0.65,
    };

    PlayStyle attackerPlayStyle = isHomeOwnBall ? homeClub.playStyle : awayClub.playStyle;
    PlayStyle defenderPlayStyle = isHomeOwnBall ? awayClub.playStyle : homeClub.playStyle;

    double pressBonus = defenderPlayStyle == PlayStyle.press ? 0.1 : 0;
    double passBonus = attackerPlayStyle == PlayStyle.pass ? 0.1 : 0;

    attackerPower = sqrt(sqrt(attackerPower));
    defenderPower = sqrt(defenderPower);

    double totalPower = attackerPower + defenderPower;
    if (Random().nextDouble() - stillLevelBonus - buildUpBonus + pressBonus - passBonus > (attackerPower / totalPower)) {
      if (passLogging) print('${!isHomeOwnBall ? homeClub.name : awayClub.name}[[<<<<still]]');
      buildUpBonus = 0;
      isHomeOwnBall = !isHomeOwnBall;
      return true;
    } else {
      return false;
    }
  }

  GroundArea longPass({required GroundArea from, required GroundArea to}) {
    if (passLogging) print('${isHomeOwnBall ? homeClub.name : awayClub.name}[[longPass]]');
    bool isStillFrom = false;
    isStillFrom = still(area: from, stillLevel: StillLevel.veryHard);
    if (isStillFrom) return from;
    still(area: to, stillLevel: StillLevel.easy);
    return to;
  }

  GroundArea throughPass({required GroundArea from, required GroundArea to}) {
    if (passLogging) print('${isHomeOwnBall ? homeClub.name : awayClub.name}[[throughPass]]');
    bool isStillFrom = false;
    isStillFrom = still(area: from, stillLevel: StillLevel.normal);
    if (isStillFrom) return from;
    still(area: to, stillLevel: StillLevel.easy);
    return to;
  }

  GroundArea cross({required GroundArea from, required GroundArea to}) {
    if (passLogging) print('${isHomeOwnBall ? homeClub.name : awayClub.name}[[cross]]');
    bool isStillFrom = false;
    isStillFrom = still(area: from, stillLevel: StillLevel.hard);
    if (isStillFrom) return from;
    //헤딩 슛
    if (Random().nextDouble() < 0.25 + buildUpBonus) {
      gall();
      return GroundArea();
    } else {
      still(area: to, stillLevel: StillLevel.easy);
      return from;
    }
  }

  GroundArea buildUpPass({required GroundArea from, required GroundArea to}) {
    if (passLogging) print('${isHomeOwnBall ? homeClub.name : awayClub.name}[[buildUpPass]]');
    bool isStillFrom = false;
    isStillFrom = still(area: from, stillLevel: StillLevel.veryHard);
    if (isStillFrom) return from;
    still(area: to, stillLevel: StillLevel.veryHard);
    buildUpBonus += 0.01;
    return to;
  }

  GroundArea shoot({required GroundArea from}) {
    if (passLogging) print('${isHomeOwnBall ? homeClub.name : awayClub.name}[[shoot]]');
    if (Random().nextDouble() < 0.02 + buildUpBonus) {
      gall();
      return GroundArea();
    } else {
      isHomeOwnBall = !isHomeOwnBall;
      return from;
    }
  }

  gall() {
    if (passLogging) print('${isHomeOwnBall ? homeClub.name : awayClub.name}[[gall!!!!!!!!!!!!!]]');
    isHomeOwnBall ? homeClubScore++ : awayClubScore++;
    isHomeOwnBall = !isHomeOwnBall;
  }

  double getPlayNumber() {
    PlayStyle playStyle = isHomeOwnBall ? homeClub.playStyle : awayClub.playStyle;
    double playStyleBonus = switch (playStyle) {
      PlayStyle.counter => Random().nextDouble() > 0.25 ? 0 : -0.3,
      PlayStyle.none => 0,
      PlayStyle.pass => Random().nextDouble() > 0.25 ? 0 : 0.3,
      PlayStyle.press => 0,
    };

    double ranNum = Random().nextDouble() + playStyleBonus;

    return ranNum;
  }

  GroundArea playCenter({required GroundArea ballLocation}) {
    Vertical successFront = isHomeOwnBall ? Vertical.away : Vertical.home;

    double ranNum = getPlayNumber();

    return switch (ranNum) {
      < 0.05 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: successFront)),
      < 0.1 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: successFront)),
      < 0.15 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: successFront)),
      < 0.35 => longPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: successFront)),
      < 0.55 => longPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: successFront)),
      < 0.75 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: Vertical.center)),
      _ => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: Vertical.center)),
    };
  }

  GroundArea playCenterHalfSpace({required GroundArea ballLocation}) {
    Vertical successFront = isHomeOwnBall ? Vertical.away : Vertical.home;
    double ranNum = getPlayNumber();

    return switch (ranNum) {
      < 0.05 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: successFront)),
      < 0.1 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: successFront)),
      < 0.3 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: successFront)),
      < 0.6 => longPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: successFront)),
      < 0.8 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: Vertical.center)),
      _ => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: Vertical.center)),
    };
  }

  GroundArea playCenterSide({required GroundArea ballLocation}) {
    Vertical successFront = isHomeOwnBall ? Vertical.away : Vertical.home;
    double ranNum = getPlayNumber();

    return switch (ranNum) {
      < 0.05 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: successFront)),
      < 0.1 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: successFront)),
      < 0.4 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: successFront)),
      < 0.5 => longPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: successFront)),
      < 0.8 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: Vertical.center)),
      _ => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: Vertical.center)),
    };
  }

  GroundArea playDefenceCenter({required GroundArea ballLocation}) {
    Vertical successFront = isHomeOwnBall ? Vertical.away : Vertical.home;
    double ranNum = getPlayNumber();

    return switch (ranNum) {
      < 0.1 => longPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: successFront)),
      < 0.2 => longPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: successFront)),
      < 0.3 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: Vertical.center)),
      < 0.6 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: Vertical.center)),
      < 0.8 => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: ballLocation.v)),
      _ => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: ballLocation.v)),
    };
  }

  GroundArea playDefenceSide({required GroundArea ballLocation}) {
    Vertical successFront = isHomeOwnBall ? Vertical.away : Vertical.home;
    double ranNum = getPlayNumber();

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
    double ranNum = getPlayNumber();

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
    double ranNum = getPlayNumber();

    return switch (ranNum) {
      < 0.7 => shoot(from: ballLocation),
      _ => throughPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: ballLocation.v)),
    };
  }

  GroundArea playAttackSide({required GroundArea ballLocation}) {
    double ranNum = getPlayNumber();

    return switch (ranNum) {
      < 0.1 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: ballLocation.v)),
      < 0.25 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.halfSpace, v: ballLocation.v)),
      < 0.7 => cross(from: ballLocation, to: GroundArea(h: Horizental.center, v: ballLocation.v)),
      _ => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: Vertical.center)),
    };
  }

  GroundArea playAttackHalfSpace({required GroundArea ballLocation}) {
    double ranNum = getPlayNumber();

    return switch (ranNum) {
      < 0.4 => shoot(from: ballLocation),
      < 0.75 => throughPass(from: ballLocation, to: GroundArea(h: Horizental.center, v: ballLocation.v)),
      _ => buildUpPass(from: ballLocation, to: GroundArea(h: Horizental.side, v: ballLocation.v)),
    };
  }

  playNext() {
    if (time >= 100) played = true;
    if (played) return;
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

  autoPlay() async {
    if (played) return;
    while (time < 100) {
      playNext();
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
