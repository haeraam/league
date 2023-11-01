import 'package:flutter/material.dart';
import 'package:leage_simulator/entities/club/club.dart';

class RecordDetailPage extends StatelessWidget {
  const RecordDetailPage({super.key, required this.clubs});
  final List<Club> clubs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
          children: clubs
              .map((club) => Row(
                    children: [
                      Text(club.name),
                      SizedBox(
                        width: 8,
                      ),
                      Text('승점:${club.pts}'),
                      SizedBox(
                        width: 8,
                      ),
                      Text('power:${club.att + club.mid + club.def}'),
                      SizedBox(
                        width: 8,
                      ),
                      Text('승:${club.won}'),
                      SizedBox(
                        width: 8,
                      ),
                      Text('무:${club.drawn}'),
                      SizedBox(
                        width: 8,
                      ),
                      Text('패:${club.lost}'),
                      SizedBox(
                        width: 8,
                      ),
                      Text('F:${club.fundamental}'),
                    ],
                  ))
              .toList()),
    );
  }
}
