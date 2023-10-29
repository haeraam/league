import 'package:flutter/material.dart';
import 'package:leage_simulator/main.dart';

class LeageTable extends StatelessWidget {
  const LeageTable({super.key, required this.teams});
  final List<Team> teams;

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return Container(
        height: 420,
        child: Column(
          children: teams
              .map((team) => Row(children: [
                    SizedBox(
                      width: 70,
                      child: Text(teams[index].name),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        'pts: ${teams[index].pts}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        'W: ${teams[index].won}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        'D: ${teams[index].drawn}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        'L: ${teams[index].lost}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: Text(
                        'gf: ${teams[index].gf}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: Text(
                        'ga: ${teams[index].ga}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: Text(
                        'gd: ${teams[index++].gd}',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ]))
              .toList(),
        )
        // ListView.builder(
        //   itemCount: teams.length,
        //   itemBuilder: (context, index) => Row(children: [
        //     SizedBox(
        //       width: 70,
        //       child: Text(teams[index].name),
        //     ),
        //     SizedBox(
        //       width: 60,
        //       child: Text(
        //         'pts: ${teams[index].pts}',
        //         style: const TextStyle(fontSize: 12),
        //       ),
        //     ),
        //     SizedBox(
        //       width: 40,
        //       child: Text(
        //         'W: ${teams[index].won}',
        //         style: const TextStyle(fontSize: 12),
        //       ),
        //     ),
        //     SizedBox(
        //       width: 40,
        //       child: Text(
        //         'D: ${teams[index].drawn}',
        //         style: const TextStyle(fontSize: 12),
        //       ),
        //     ),
        //     SizedBox(
        //       width: 40,
        //       child: Text(
        //         'L: ${teams[index].lost}',
        //         style: const TextStyle(fontSize: 12),
        //       ),
        //     ),
        //     SizedBox(
        //       width: 50,
        //       child: Text(
        //         'gf: ${teams[index].gf}',
        //         style: const TextStyle(fontSize: 12),
        //       ),
        //     ),
        //     SizedBox(
        //       width: 50,
        //       child: Text(
        //         'ga: ${teams[index].ga}',
        //         style: const TextStyle(fontSize: 12),
        //       ),
        //     ),
        //     SizedBox(
        //       width: 50,
        //       child: Text(
        //         'gd: ${teams[index].gd}',
        //         style: const TextStyle(fontSize: 11),
        //       ),
        //     ),
        //   ]),
        // ),
        );
  }
}
