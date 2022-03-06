import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:soccer/data/Position.dart';
import 'package:soccer/nav/args/PositionSelectArgs.dart';
import 'package:soccer/pages/setup/PlayerPrefSliders.dart';

class PositionSelector extends StatelessWidget {
  static const route = "/game/selectPosition";

  @override
  Widget build(BuildContext context) {
    final PositionSelectArgs args = ModalRoute.of(context)!.settings.arguments as PositionSelectArgs;

    var player = args.player;
    var game = args.game;

    return Scaffold(
      appBar: AppBar(
        title: Text("Select Position"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Hero(
                  tag: "player-name-${player.id}",
                  child: Text(
                    player.name,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(30, 30, 0, 10),
                    child: Text("Select a position")),
              ],
            ),
            Expanded(
              child: Row(children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: ListView.builder(
                        itemCount: game.positions.length + 1,
                        itemBuilder: (context, index) {
                          Position? position;
                          if(index == 0) {
                            position = null;
                          } else {
                            position = game.positions[index - 1];
                          }
                          return ListTile(
                            title: position == null ? Text("Bench") : Text("${position.id} - ${position.name}"),
                            onTap: () {
                              if(position == null) {
                                Navigator.pop(context, "bench");
                              } else {
                                Navigator.pop(context, position);
                              }
                            },
                          );
                        }),
                  ),
                ),
                Expanded(
                    child: PlayerPrefSliders(player, true)
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
