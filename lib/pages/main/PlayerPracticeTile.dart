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

  const PlayerPracticeTile({required this.player, required this.colored, required this.team, required this.counter});

  @override
  _PlayerPracticeTileState createState() => _PlayerPracticeTileState();
}

class _PlayerPracticeTileState extends State<PlayerPracticeTile> {
  StorageService storage = locator<StorageService>();

  _PlayerPracticeTileState();

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");

    return ListTile(
      tileColor: widget.colored ? Colors.black12 : Colors.white,
              leading: widget.player.player.flag ? CircleAvatar(
                child: Icon(Icons.flag),
              ) : null,
              title: Row(children: [
                Expanded(child: Text(widget.player.player.name)),
                Checkbox(
                  value: widget.player.attended,
                  onChanged: (value) {
                    setState(() {
                      widget.player.attended = value;
                      if(value ?? false) {
                        widget.counter.value++;
                      } else {
                        widget.counter.value--;
                      }
                    });
                    storage.savePractice(widget.player.practice);
                  },
                ),
                Checkbox(
                  value: widget.player.goalie,
                  onChanged: (value) {
                    setState(() {
                      widget.player.goalie = value;
                    });
                    storage.savePractice(widget.player.practice);
                  },
                ),
              ]),
      onTap: () {
        Navigator.pushNamed(context, PlayerSetup.route,
            arguments: PlayerArgs(widget.player.player.id, widget.team));
      },
    );
  }
}
