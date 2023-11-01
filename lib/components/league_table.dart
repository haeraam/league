import 'package:flutter/material.dart';
import 'package:leage_simulator/entities/club/club.dart';

class LeageTable extends StatelessWidget {
  const LeageTable({super.key, required this.clubs});
  final List<Club> clubs;

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return Container(
        height: 420,
        child: Column(
          children: clubs
              .map((club) => Row(children: [
                    SizedBox(
                      width: 70,
                      child: Text(
                        clubs[index].name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        'pts: ${clubs[index].pts}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        'W: ${clubs[index].won}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        'D: ${clubs[index].drawn}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        'L: ${clubs[index].lost}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: Text(
                        'gf: ${clubs[index].gf}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: Text(
                        'ga: ${clubs[index].ga}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: Text(
                        'gd: ${clubs[index++].gd}',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ]))
              .toList(),
        )
        // ListView.builder(
        //   itemCount: clubs.length,
        //   itemBuilder: (context, index) => Row(children: [
        //     SizedBox(
        //       width: 70,
        //       child: Text(clubs[index].name),
        //     ),
        //     SizedBox(
        //       width: 60,
        //       child: Text(
        //         'pts: ${clubs[index].pts}',
        //         style: const TextStyle(fontSize: 12),
        //       ),
        //     ),
        //     SizedBox(
        //       width: 40,
        //       child: Text(
        //         'W: ${clubs[index].won}',
        //         style: const TextStyle(fontSize: 12),
        //       ),
        //     ),
        //     SizedBox(
        //       width: 40,
        //       child: Text(
        //         'D: ${clubs[index].drawn}',
        //         style: const TextStyle(fontSize: 12),
        //       ),
        //     ),
        //     SizedBox(
        //       width: 40,
        //       child: Text(
        //         'L: ${clubs[index].lost}',
        //         style: const TextStyle(fontSize: 12),
        //       ),
        //     ),
        //     SizedBox(
        //       width: 50,
        //       child: Text(
        //         'gf: ${clubs[index].gf}',
        //         style: const TextStyle(fontSize: 12),
        //       ),
        //     ),
        //     SizedBox(
        //       width: 50,
        //       child: Text(
        //         'ga: ${clubs[index].ga}',
        //         style: const TextStyle(fontSize: 12),
        //       ),
        //     ),
        //     SizedBox(
        //       width: 50,
        //       child: Text(
        //         'gd: ${clubs[index].gd}',
        //         style: const TextStyle(fontSize: 11),
        //       ),
        //     ),
        //   ]),
        // ),
        );
  }
}
