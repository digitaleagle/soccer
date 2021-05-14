import 'package:flutter/material.dart';
import 'package:soccer/data/Game.dart';

class GameQuarter extends StatelessWidget {
  final Game game;
  final VoidCallback onChanged;

  const GameQuarter({Key key, this.game, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container()),
        FloatingActionButton(
          child: Text("1"),
          backgroundColor:
          game.currentQuarter == 1 ? Colors.red : Colors.blue,
          onPressed: () {
            game.currentQuarter = 1;
            onChanged();
          },
        ),
        FloatingActionButton(
          child: Text("2"),
          backgroundColor:
          game.currentQuarter == 2 ? Colors.red : Colors.blue,
          onPressed: () {
            game.currentQuarter = 2;
            onChanged();
          },
        ),
        FloatingActionButton(
          child: Text("3"),
          backgroundColor:
          game.currentQuarter == 3 ? Colors.red : Colors.blue,
          onPressed: () {
            game.currentQuarter = 3;
            onChanged();
          },
        ),
        FloatingActionButton(
          child: Text("4"),
          backgroundColor:
          game.currentQuarter == 4 ? Colors.red : Colors.blue,
          onPressed: () {
            game.currentQuarter = 4;
            onChanged();
          },
        ),
        Expanded(child: Container()),
      ],
    );
  }
  
  
}