import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soccer/data/Game.dart';

class GameInfo extends StatelessWidget {
  final Game game;

  GameInfo(this.game);

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat.yMd().add_jm();
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Text("Date: ${format.format(game.eventDate)}"),
          Text("Field: ${game.field}"),
          Text("Refreshments: ${game.refreshments}"),
          Flexible(
            child: InteractiveViewer(
                child: Image(
              image: AssetImage("assets/graphics/field_layout.png"),
            )),
          ),
        ],
      ),
    );
  }
}
