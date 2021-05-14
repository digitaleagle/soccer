import 'package:flutter/material.dart';
import 'package:soccer/data/Player.dart';
import 'package:soccer/data/Position.dart';

class FieldPlayer extends StatelessWidget {
  final Position position;
  final Player player;
  final VoidCallback onPressed;
  final bool duplicate;

  const FieldPlayer({Key key, this.position, this.player, this.onPressed, this.duplicate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.left,
      top: position.top,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: duplicate ? Colors.red : Colors.white,
          onPrimary: Colors.black,
        ),
        onPressed: () {
          this.onPressed();
        },
        child: Column(children: [
          Text(position.id),
          Text(player == null? "??": player.name),
          Text(player == null? "??": player.jersey),
        ]),
      ),
    );
  }
}
