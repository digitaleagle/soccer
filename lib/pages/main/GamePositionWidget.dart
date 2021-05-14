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
  final Position position;

  const GamePositionWidget({Key key, this.player, this.quarter, this.game, this.position}) : super(key: key);

  @override
  _GamePositionState createState() => _GamePositionState(player, quarter, game, position);
}

class _GamePositionState extends State {
  StorageService storage = locator<StorageService>();
  final Player player;
  final int quarter;
  final Game game;
  Position position;

  _GamePositionState(this.player, this.quarter, this.game, this.position);


  @override
  void initState() {
    if(position == null) {
      print("getting position ${player.id} ${player.name} Q$quarter");
      position = game.getPosition(player, quarter);
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
        changeQuarter(context, quarter, player);
      },
      child: Text(position == null ? " " : position.id),
    );
  }

  changeQuarter(BuildContext context, int quarter, Player player) {
    Navigator.pushNamed(
        context, PositionSelector.route,
        arguments: PositionSelectArgs(quarter, player, game)).then((obj) async {
      if(obj != null) {
        if(obj == "bench") {
          position = null;
          game.setPosition(player, quarter, null);
        } else {
          game.setPosition(player, quarter, obj);
          position = obj;
        }
        storage.saveGame(game);
        setState(() {

        });
      }
    });
  }
}