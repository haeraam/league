import 'package:flutter/material.dart';
import 'package:leage_simulator/entities/team/team.dart';

const TextStyle teamCardTitleStyle = TextStyle(fontSize: 13, fontWeight: FontWeight.bold);

const TextStyle teamCardWinnerFontColor = TextStyle(
  color: Color.fromARGB(255, 4, 0, 44),
);

const TextStyle teamCardStacStyle = TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold);

enum Result { win, draw, lose, none }

class TeamCard extends StatelessWidget {
  const TeamCard({
    super.key,
    required this.team,
    this.showDetail = false,
    this.result = Result.none,
    this.rank,
  });
  final Team team;
  final bool showDetail;
  final Result result;
  final int? rank;

  Text getTitleText({required String name, required Color color}) {
    return Text(
      name,
      style: teamCardTitleStyle.copyWith(color: color),
    );
  }

  Widget createStackCard({required String text, required Color bgColor}) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4)),
      child: Text(
        text,
        style: teamCardStacStyle,
      ),
    );
  }

  Widget getStackText({required Team team}) {
    List<Widget> res = [];
    if (team.winStack > 1) {
      res.add(
        createStackCard(text: '${team.winStack}연승', bgColor: const Color.fromARGB(255, 68, 209, 125)),
      );
    }
    if (team.noLoseStack > 3) {
      res.add(
        createStackCard(text: '${team.noLoseStack}연속 무패', bgColor: const Color.fromARGB(255, 46, 148, 232)),
      );
    }
    if (team.loseStack > 1) {
      res.add(
        createStackCard(text: '${team.loseStack}연패', bgColor: const Color.fromARGB(255, 217, 65, 86)),
      );
    }
    if (team.noWinStack > 3) {
      res.add(
        createStackCard(text: '${team.noWinStack}연속 무승', bgColor: const Color.fromARGB(255, 97, 97, 97)),
      );
    }

    return Row(
      children: res,
    );
  }

  (Color, Color) _getColor({required Result result}) {
    if (result == Result.win) {
      return (Colors.black, const Color.fromARGB(255, 195, 226, 203));
    } else if (result == Result.lose) {
      return (const Color.fromARGB(169, 192, 32, 21), const Color.fromARGB(255, 241, 197, 197));
    } else if (result == Result.draw) {
      return (Colors.grey, const Color.fromARGB(255, 236, 236, 236));
    } else {
      return (const Color.fromARGB(255, 0, 0, 0), const Color.fromARGB(255, 236, 236, 236));
    }
  }

  getRankText({required int? rank}) {
    String text = switch (rank) { 1 => 'st', 2 => 'nd', 3 => 'rd', _ => 'th' };
    TextStyle textStyle = switch (rank) {
      1 => const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 22, 22, 22)),
      2 => const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color.fromARGB(179, 22, 22, 22)),
      3 => const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color.fromARGB(186, 22, 22, 22)),
      _ => const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color.fromARGB(87, 22, 22, 22)),
    };

    return Row(
      children: [
        Text(
          '$rank',
          style: textStyle,
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color.fromARGB(87, 22, 22, 22)),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var (textColor, bgColor) = _getColor(result: result);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
      height: showDetail ? 48 : 27,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  getRankText(rank: rank),
                  const SizedBox(
                    width: 2,
                  ),
                  getTitleText(name: team.name, color: textColor),
                ],
              ),
              const SizedBox(width: 4),
              // Row(
              //   children: [
              //     Text(
              //       '${team.att}',
              //       style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
              //     ),
              //     const SizedBox(width: 2),
              //     Text(
              //       '/${team.mid}',
              //       style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
              //     ),
              //     const SizedBox(width: 2),
              //     Text(
              //       '/${team.def}',
              //       style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
              //     ),
              //   ],
              // )
            ],
          ),
          if (showDetail) const SizedBox(height: 4),
          if (showDetail) getStackText(team: team),
        ],
      ),
    );
  }
}
