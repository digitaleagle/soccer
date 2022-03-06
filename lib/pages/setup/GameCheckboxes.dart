import 'package:flutter/material.dart';
import 'package:soccer/data/Game.dart';

class GameCheckboxes extends StatefulWidget {
  final Game game;

  const GameCheckboxes({Key? key, required this.game}) : super(key: key);

  @override
  _GameCheckboxesState createState() => _GameCheckboxesState(this.game);
}

class _GameCheckboxesState extends State {
  final Game game;

  _GameCheckboxesState(this.game);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            child: Container(
          child: CheckboxListTile(
            title: Text("Picture Day"),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (value) {
              setState(() {
                game.pictureDay = value ?? false;
              });
            },
            value: game.pictureDay,
          ),
        )),
        Flexible(
            child: Container(
          child: CheckboxListTile(
            title: Text("Tri-Star"),
            value: game.triStar,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (value) {
              setState(() {
                game.triStar = value ?? false;
              });
            },
          ),
        )),
      ],
    );
  }
}
