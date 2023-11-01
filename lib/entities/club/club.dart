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
    this.playStyle = PlayStyle.none,
    this.attPercent = 0.5,
    this.fundamental = 0.0,
    String? fullName,
  }) {
    fullName = fullName ?? name;
  }
  final String name;
  late final String fullName;
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
    ga -= conceded;
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
}
