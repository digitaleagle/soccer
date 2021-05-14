import 'package:flutter/material.dart';
import 'package:soccer/data/Team.dart';
import 'package:soccer/nav/NavDrawer.dart';
import 'package:soccer/nav/args/TeamArgs.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';

import 'TeamSetup.dart';

class TeamListSetup extends StatefulWidget {
  static const route = '/setup';
  @override
  _TeamListSetupState createState() => _TeamListSetupState();
}

class _TeamListSetupState extends State<TeamListSetup> {
  StorageService storage = locator<StorageService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Soccer"),
        ),
      drawer: NavDrawer(),
        body: FutureBuilder(
          future: getTeams(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    Team team = snapshot.data[index];
                    return ListTile(
                        title: Text("#${team.id} ${team.name}"),
                      onTap: () {
                        Navigator.pushNamed(context, TeamSetup.route, arguments: TeamArgs(team.id)).then((obj) {
                          setState(() {
                          });
                        });
                      },
                    );
                  }
              );
            }
            return CircularProgressIndicator();
          }
        ),
      floatingActionButton: FloatingActionButton(
        heroTag: "newTeam",
        onPressed: () {
          Navigator.pushNamed(context, TeamSetup.route, arguments: TeamArgs(-1));
        },
        tooltip: 'New Team',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<List<Team>> getTeams() async {
    return await storage.listTeams();
  }
}

