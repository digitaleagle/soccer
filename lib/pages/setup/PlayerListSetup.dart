import 'package:flutter/material.dart';
import 'package:soccer/data/Player.dart';
import 'package:soccer/data/Team.dart';
import 'package:soccer/nav/args/PlayerArgs.dart';
import 'package:soccer/pages/setup/PlayerSetup.dart';
import 'package:soccer/pages/util/PopupMenuContainer.dart';

class PlayerListSetup extends StatefulWidget {
  final Team team;
  final List<Player> players;

  PlayerListSetup(this.team, this.players);

  @override
  _PlayerListSetupState createState() =>
      _PlayerListSetupState(this.team, this.players);
}

class _PlayerListSetupState extends State {
  final Team team;
  final List<Player> players;

  _PlayerListSetupState(this.team, this.players);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: players.length,
          itemBuilder: (context, index) {
            Player player = players[index];
            return PopupMenuContainer(
              child: ListTile(
                title: Text("#${player.id} - ${player.name}"),
                onTap: () {
                  Navigator.pushNamed(context, PlayerSetup.route,
                      arguments: PlayerArgs(player.id, team));
                },
              ),
              items: [
                PopupMenuItem(value: "delete", child: Text("Delete")),
              ],
              onItemSelected: (value) {
                if (value == 'delete') {
                  setState(() {
                    team.removePlayer(player);
                  });
                }
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        heroTag: "newPlayer",
        onPressed: () {
          Navigator.pushNamed(context, PlayerSetup.route,
                  arguments: PlayerArgs(-1, team))
              .then((value) {
            setState(() {});
          });
        },
        tooltip: "New Player",
        child: Icon(Icons.add),
      ),
    );
  }
}
