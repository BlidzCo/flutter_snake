import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake/widgets/snake/snake.dart';
import 'package:flutter_snake/widgets/snake/snake_enums/game_event.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double caseWidth = 25.0;
  final int numberCaseHorizontally = 11;
  final int numberCaseVertically = 11;
  StreamController<GAME_EVENT>? controller;
  SnakeGame? snakeGame;

  List<String> _eventList = [];

  @override
  void initState() {
    super.initState();
    controller = StreamController<GAME_EVENT>();

    snakeGame = new SnakeGame(
      caseWidth: caseWidth,
      numberCaseHorizontally: numberCaseHorizontally,
      numberCaseVertically: numberCaseVertically,
      controllerEvent: controller,
      colorBackground1: Color(0XFF32CD32),
      colorBackground2: Color(0XFF7CFC00),
      durationBetweenTicks: Duration(milliseconds: 500),
    );

    controller?.stream.listen((GAME_EVENT value) {
      setState(() {
        _eventList.add(value.toString());
      });
    });
  }

  @override
  void dispose() {
    controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 16,
        ),
        Text(
          "Snake game",
          style: Theme.of(context).textTheme.headline3,
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          "Parameters:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text("- caseWidth: $caseWidth"),
        Text("- numberCaseHorizontally: $numberCaseHorizontally"),
        Text("- numberCaseVertically: $numberCaseVertically"),
        SizedBox(
          height: 32,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                print("-- START");
                setState(() {
                  snakeGame = new SnakeGame(
                    caseWidth: caseWidth,
                    numberCaseHorizontally: numberCaseHorizontally,
                    numberCaseVertically: numberCaseVertically,
                    controllerEvent: controller,
                    durationBetweenTicks: Duration(milliseconds: 500),
                  );
                  _eventList.clear();
                });
              },
              child: Text("START"),
            ),
            TextButton(
              onPressed: () {
                print("-- RESTART");
                setState(() {
                  snakeGame = null;
                  _eventList.clear();
                });
              },
              child: Text("STOP"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  snakeGame?.caseWidth = 10.0;
                });
              },
              child: Text("REDUCE"),
            ),
            TextButton(
              onPressed: () => snakeGame?.nextDirection = SNAKE_MOVE.left,
              child: Text("LEFT"),
            ),
            TextButton(
              onPressed: () => snakeGame?.nextDirection = SNAKE_MOVE.right,
              child: Text("RIGHT"),
            ),
          ],
        ),
        snakeGame ?? Text("Not initialized"),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemCount: _eventList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              child: Center(child: Text('EVENT: ${_eventList.reversed.elementAt(index)}')),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        )
      ],
    );
  }
}
