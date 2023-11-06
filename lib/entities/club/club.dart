import 'dart:math';

import 'package:leage_simulator/entities/club/enum.dart';

class Club {
  Club({
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
    required this.country,
    required this.leagueTier,
    this.playStyle = PlayStyle.none,
    this.attPercent = 0.5,
    this.fundamental = 0.0,
    this.ownPercent = 0.0,
    this.awayColor = ClubColor.black,
    this.homeColor = ClubColor.green,
    String? fullName,
  }) {
    this.fullName = fullName ?? name;
  }
  final String name;
  late final String fullName;
  final Country country;
  final int leagueTier;

  double fundamental;
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
  double ownPercent;
  ClubColor homeColor;
  ClubColor awayColor;

  clear() {
    pts = 0;
    won = 0;
    drawn = 0;
    lost = 0;
    gf = 0;
    ga = 0;
    gd = 0;
    winStack = 0;
    noLoseStack = 0;
    loseStack = 0;
    noWinStack = 0;
  }

  calcPts() {
    pts = won * 3 + drawn;
  }

  saveResult({required int scored, required int conceded}) {
    gf += scored;
    ga += conceded;
    gd += (scored - conceded);
    if (scored > conceded) {
      win();
    } else if (conceded > scored) {
      lose();
    } else {
      draw();
    }
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

  get power {
    return sqrt(att + mid + def);
  }

  get attPower {
    return (att * 0.05 + mid * 0.2);
  }

  get defPower {
    return (def * 1.65 + mid * 0.35);
  }

  @override
  String toString() {
    return '$name , $won , $drawn , $lost';
  }

  Club.fromJson(Map map)
      : name = map['name'],
        att = map['att'],
        mid = map['mid'],
        def = map['def'],
        playStyle = map['playStyle'] ?? PlayStyle.none,
        homeColor = map['homeColor'] ?? ClubColor.black,
        awayColor = map['awayColor'] ?? ClubColor.green,
        country = map['country'],
        leagueTier = map['leagueTier'],
        pts = 0,
        won = 0,
        drawn = 0,
        lost = 0,
        gf = 0,
        ga = 0,
        gd = 0,
        winStack = 0,
        noLoseStack = 0,
        loseStack = 0,
        noWinStack = 0,
        attPercent = map['attPercent'] ?? 0.5,
        fundamental = map['fundamental'] ?? 0.0,
        ownPercent = 0.0;
}
