import 'package:flutter/material.dart';
import 'package:leage_simulator/entities/team/team.dart';

class RecordDetailPage extends StatelessWidget {
  const RecordDetailPage({super.key, required this.teams});
  final List<Team> teams;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
          children: teams
              .map((team) => Row(
                    children: [
                      Text(team.name),
                      SizedBox(
                        width: 8,
                      ),
                      Text('승점:${team.pts}'),
                      SizedBox(
                        width: 8,
                      ),
                      Text('power:${team.att + team.mid + team.def}'),
                      SizedBox(
                        width: 8,
                      ),
                      Text('승:${team.won}'),
                      SizedBox(
                        width: 8,
                      ),
                      Text('무:${team.drawn}'),
                      SizedBox(
                        width: 8,
                      ),
                      Text('패:${team.lost}'),
                      SizedBox(
                        width: 8,
                      ),
                      Text('F:${team.fundamental}'),
                    ],
                  ))
              .toList()),
    );
  }
}
