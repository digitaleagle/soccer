import 'package:flutter/material.dart';
import 'package:soccer/data/Player.dart';
import 'package:soccer/pages/util/PrefSelector.dart';

class PlayerPrefSliders extends StatelessWidget {
  final Player player;
  final bool displayOnly;

  PlayerPrefSliders(this.player, this.displayOnly);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          PrefSelector(
            value: player.goaliePref,
            label: "Goalie",
            onChanged: displayOnly ? null :
                (value) {
              player.goaliePref = value;
            },
          ),
          PrefSelector(
            value: player.forwardPref,
            label: "Forward",
            onChanged: displayOnly ? null :
                (value) {
              player.forwardPref = value;
            },
          ),
          PrefSelector(
            value: player.midFieldPref,
            label: "Mid-Field",
            onChanged: displayOnly ? null :
                (value) {
              player.midFieldPref = value;
            },
          ),
          PrefSelector(
            value: player.defensePref,
            label: "Defense",
            onChanged: displayOnly ? null :
                (value) {
              player.defensePref = value;
            },
          ),
          PrefSelector(
            value: player.sweeperPref,
            label: "Sweeper",
            onChanged: displayOnly ? null :
                (value) {
              player.sweeperPref = value;
            },
          ),
        ],
      ),
    );
  }
}
