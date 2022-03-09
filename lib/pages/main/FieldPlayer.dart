import 'package:flutter/material.dart';
import 'package:soccer/data/Player.dart';
import 'package:soccer/data/Position.dart';

class FieldPlayer extends StatelessWidget {
  final Position position;
  final Player? player;
  final VoidCallback? onPressed;
  final bool duplicate;
  final bool positionOnly;
  static const double height = 40;

  const FieldPlayer(
      {Key? key,
      required this.position,
      this.player,
      this.onPressed,
      this.duplicate = false,
      this.positionOnly = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: duplicate ? Colors.red : Colors.white,
        onPrimary: Colors.black,
      ),
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        }
      },
      child: SizedBox(
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Text(
            position.id,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(player == null
                    ? (positionOnly ? position.name : "??")
                    : player!.name,
                style: const TextStyle(fontSize: 14),),
                Visibility(
                    visible: !positionOnly,
                    child: Text(player == null ? "" : player!.jersey,
                    style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),)
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
