import 'package:flutter/material.dart';
import 'package:soccer/data/Game.dart';
import 'package:soccer/data/Player.dart';
import 'package:soccer/data/Position.dart';
import 'package:soccer/nav/args/PositionSelectArgs.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';

import 'PositionSelector.dart';

class GamePositionWidget extends StatefulWidget {
  final Player player;
  final int quarter;
  final Game game;
  Position? position;

  GamePositionWidget({Key? key, required this.player, required this.quarter, required this.game, this.position}) : super(key: key);

  @override
  _GamePositionState createState() => _GamePositionState();
}

class _GamePositionState extends State<GamePositionWidget> {
  StorageService storage = locator<StorageService>();


  @override
  void initState() {
    if(widget.position == null) {
      widget.position = widget.game.getPosition(widget.player, widget.quarter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Colors.black,
      ),
      onPressed: () {
        changeQuarter(context, widget.quarter, widget.player);
      },
      child: Text(widget.position == null ? " " : widget.position!.id),
    );
  }

  changeQuarter(BuildContext context, int quarter, Player player) {
    Navigator.pushNamed(
        context, PositionSelector.route,
        arguments: PositionSelectArgs(quarter, player, widget.game)).then((obj) async {
      if(obj != null) {
        if(obj == "bench") {
          widget.position = null;
          widget.game.setPosition(player, quarter, null);
        } else {
          widget.game.setPosition(player, quarter, obj as Position);
          widget.position = obj as Position;
        }
        storage.saveGame(widget.game);
        setState(() {

        });
      }
    });
  }
}