import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soccer/data/PracticePlayer.dart';
import 'package:soccer/data/Team.dart';
import 'package:soccer/nav/args/PlayerArgs.dart';
import 'package:soccer/pages/setup/PlayerSetup.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';

class PlayerPracticeTile extends StatefulWidget {
  final PracticePlayer player;
  final bool colored;
  final Team team;
  final ValueNotifier<int> counter;

  const PlayerPracticeTile({this.player, this.colored, this.team, this.counter});

  @override
  _PlayerPracticeTileState createState() => _PlayerPracticeTileState(player, colored, team, counter);
}

class _PlayerPracticeTileState extends State {
  final PracticePlayer player;
  final bool colored;
  final Team team;
  final ValueNotifier<int> counter;
  StorageService storage = locator<StorageService>();

  _PlayerPracticeTileState(this.player, this.colored, this.team, this.counter);

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");

    return ListTile(
      tileColor: colored ? Colors.black12 : Colors.white,
              leading: player.player.flag ? CircleAvatar(
                child: Icon(Icons.flag),
              ) : null,
              title: Row(children: [
                Expanded(child: Text(player.player.name)),
                Checkbox(
                  value: player.attended,
                  onChanged: (value) {
                    setState(() {
                      player.attended = value;
                      if(value) {
                        counter.value++;
                      } else {
                        counter.value--;
                      }
                    });
                    storage.savePractice(player.practice);
                  },
                ),
                Checkbox(
                  value: player.goalie,
                  onChanged: (value) {
                    setState(() {
                      player.goalie = value;
                    });
                    storage.savePractice(player.practice);
                  },
                ),
              ]),
      onTap: () {
        Navigator.pushNamed(context, PlayerSetup.route,
            arguments: PlayerArgs(player.player.id, team));
      },
    );
  }
}
