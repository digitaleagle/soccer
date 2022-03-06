import 'package:flutter/material.dart';
import 'package:soccer/data/Player.dart';
import 'package:soccer/data/Team.dart';
import 'package:soccer/nav/args/TeamArgs.dart';
import 'package:soccer/pages/setup/EventListSetup.dart';
import 'package:soccer/pages/setup/TeamGeneralForm.dart';
import 'package:soccer/pages/setup/TeamPositionSetup.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';

import 'PlayerListSetup.dart';

class TeamSetup extends StatefulWidget {
  static const route = '/setup/team';
  @override
  _TeamSetupState createState() => _TeamSetupState();
}

class _TeamSetupState extends State<TeamSetup> {
  StorageService storage = locator<StorageService>();
  late List<Player> _players;

  @override
  Widget build(BuildContext context) {
    final TeamArgs args = ModalRoute.of(context)!.settings.arguments as TeamArgs;

    var title = "Soccer: Team ${args.id}";
    if (args.id <= 0) {
      title = "Soccer: New Team";
    }

    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final playersController = TextEditingController();

    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.settings)),
                  Tab(icon: Icon(Icons.supervisor_account)),
                  Tab(icon: Icon(Icons.sports_soccer)),
                  Tab(icon: Icon(Icons.map)),
                ]
            ),
          ),
          body: FutureBuilder<Team>(
              future: getTeam(args.id),
              builder: (context, snapshot) {
                Team team;
                if (snapshot.hasData) {
                  team = snapshot.data!;
                  nameController.text = team.name;
                  ageController.text = team.age;
                  playersController.text = team.playersOnField.toString();
                  return TabBarView(children: [
                    TeamGeneralForm(
                        team, nameController, ageController, playersController),
                    PlayerListSetup(team, _players),
                    EventListSetup(team),
                    TeamPositionSetup(team),
                  ]);
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ));
  }

  Future<Team> getTeam(int id) async {
    Team team;
    if (id <= 0) {
      team = Team();
    } else {
      team = await storage.getTeam(id);
    }
    _players = await team.players;
    return team;
  }
}
