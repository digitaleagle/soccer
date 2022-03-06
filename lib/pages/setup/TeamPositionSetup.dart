import 'package:flutter/material.dart';
import 'package:soccer/data/Position.dart';
import 'package:soccer/data/Team.dart';
import 'package:soccer/nav/args/PositionArgs.dart';
import 'package:soccer/pages/setup/PositionSetup.dart';

class TeamPositionSetup extends StatefulWidget {
  final Team team;

  const TeamPositionSetup(this.team);

  _TeamPositionSetupState createState() => _TeamPositionSetupState(team);
}

class _TeamPositionSetupState extends State {
  final Team team;

  _TeamPositionSetupState(this.team);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: team.positions.length,
          itemBuilder: (context, index) {
            var position = team.positions[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text(position.id),
              ),
              title: Text(position.name),
              onTap: () {
                Navigator.pushNamed(context, PositionSetup.route,
                    arguments: PositionArgs(position))
                    .then((obj) {
                  setState(() {
                  });
                });

              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          var newPosition = Position();
          Navigator.pushNamed(context, PositionSetup.route,
                  arguments: PositionArgs(newPosition))
              .then((obj) {
            setState(() {
              if(!newPosition.id.isEmpty || !newPosition.name.isEmpty) {
                team.positions.add(newPosition);
              }
            });
          });
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(5),
        child: Text("${team.positions.length} positions", style: TextStyle(color: Colors.white),),
        color: Colors.blue,
      ),
    );
  }
}
