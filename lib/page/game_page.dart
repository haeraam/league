import 'dart:math';

import 'package:flutter/material.dart';
import 'package:leage_simulator/entities/club/club.dart';
import 'package:leage_simulator/entities/fixture/fixture.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.fixture});
  final Fixture fixture;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  GlobalKey key = GlobalKey();
  double ballSize = 35.0;
  bool setSize = false;
  double _width = 0;
  double _height = 0;
  bool _isFastGame = false;

  double marginLeft = 0;
  double marginTop = 0;
  int beforeScore = 0;
  bool isVisiblaGoalText = false;

  Duration _gameSpeed = Duration(milliseconds: 200);

  setBall() {
    switch (widget.fixture.ballLocation.v) {
      case Vertical.away:
        marginTop = _height * 0.5 - ballSize / 2;
        break;
      case Vertical.center:
        marginTop = _height * 1.5 - ballSize / 2;
        break;
      case Vertical.home:
        marginTop = _height * 2.5 - ballSize / 2;
        break;
    }

    bool isLeft = Random().nextBool();

    switch (widget.fixture.ballLocation.h) {
      case Horizental.center:
        marginLeft = _width * 2.5 - ballSize / 2;
        break;
      case Horizental.halfSpace:
        marginLeft = _width * (1.5 + (isLeft ? 0 : 2)) - ballSize / 2;
        break;
      case Horizental.side:
        marginLeft = _width * (0.5 + (isLeft ? 0 : 4)) - ballSize / 2;
        break;
    }
    setState(() {});
  }

  play() async {
    widget.fixture.playNext();
    if (beforeScore != widget.fixture.homeClubScore + widget.fixture.awayClubScore) {
      setState(() {
        isVisiblaGoalText = true;
      });
      beforeScore = widget.fixture.homeClubScore + widget.fixture.awayClubScore;
      await Future.delayed(Duration(milliseconds: 1300));
    }
    await Future.delayed(_gameSpeed);
    setState(() {
      isVisiblaGoalText = false;
    });
    setBall();
    if (widget.fixture.time < 100) play();
  }

  Color getFlutterColor(ClubColor color) {
    return switch (color) {
      ClubColor.black => Colors.black,
      ClubColor.blue => Colors.blue,
      ClubColor.deepRed => Color.fromARGB(255, 108, 11, 11),
      ClubColor.green => Colors.green,
      ClubColor.purple => Colors.purple,
      ClubColor.red => Colors.red,
      ClubColor.white => Colors.white,
      ClubColor.orange => Colors.orange,
      ClubColor.skyBlue => Color.fromARGB(255, 85, 201, 255),
    };
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!setSize) {
        _width = (key.currentContext?.size?.width ?? 0) / 5;
        _height = (key.currentContext?.size?.height ?? 0) / 3;
        setBall();
        setSize = true;
      }
    });
    Widget background = Container(color: Color.fromARGB(255, 151, 198, 153), key: key);

    Color homeColor = getFlutterColor(widget.fixture.homeClub.homeColor);
    Color awayColor = getFlutterColor(widget.fixture.awayClub.homeColor == widget.fixture.homeClub.homeColor ? widget.fixture.awayClub.awayColor : widget.fixture.awayClub.homeColor);

    int totalPercent = widget.fixture.homeBallPercent + widget.fixture.awayBallPercent;
    double homeBallPercent = widget.fixture.homeBallPercent / totalPercent * 100;
    double awayBallPercent = widget.fixture.awayBallPercent / totalPercent * 100;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                    value: _isFastGame,
                    onChanged: (val) {
                      _isFastGame = val ?? false;
                      setState(() {
                        _gameSpeed = val ?? false ? Duration(milliseconds: 35) : Duration(milliseconds: 200);
                      });
                    }),
                ElevatedButton(
                    onPressed: () async {
                      play();
                    },
                    child: Text('start')),
              ],
            ),
            Row(
              children: [
                Text('Time: ${widget.fixture.time}'),
                SizedBox(width: 20),
                Text('${awayBallPercent.toStringAsFixed(1)}%'),
                Container(
                  width: 20,
                  height: 20,
                  color: awayColor,
                ),
                Text('${widget.fixture.awayClub.name} ${widget.fixture.awayClubScore}'),
                Text(':'),
                Text('${widget.fixture.homeClubScore} ${widget.fixture.homeClub.name}'),
                Container(
                  width: 20,
                  height: 20,
                  color: homeColor,
                ),
                Text('${homeBallPercent.toStringAsFixed(1)}%'),
              ],
            ),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  child: AspectRatio(
                    aspectRatio: 75 / 100,
                    child: Stack(
                      children: [
                        background,
                        Column(
                          children: [
                            AnimatedContainer(
                              height: marginTop,
                              duration: _gameSpeed,
                            ),
                            Row(
                              children: [
                                AnimatedContainer(
                                  width: marginLeft,
                                  duration: _gameSpeed,
                                ),
                                Visibility(
                                  visible: !isVisiblaGoalText,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: widget.fixture.isHomeOwnBall ? homeColor : awayColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    width: 35,
                                    height: 35,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Center(
                            child: Visibility(
                          visible: isVisiblaGoalText,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${!widget.fixture.isHomeOwnBall ? widget.fixture.homeClub.name : widget.fixture.awayClub.name}',
                                  style: TextStyle(
                                    color: !widget.fixture.isHomeOwnBall ? homeColor : awayColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  )),
                              Text(
                                'Goal!!!!!!!',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
