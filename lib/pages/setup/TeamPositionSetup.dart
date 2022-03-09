import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:soccer/data/Position.dart';
import 'package:soccer/data/Team.dart';
import 'package:soccer/nav/args/PositionArgs.dart';
import 'package:soccer/pages/setup/PositionSetup.dart';
import 'package:soccer/pages/setup/position_template_setup.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';

class TeamPositionSetup extends StatefulWidget {
  final Team team;

  const TeamPositionSetup({Key? key, required this.team}) : super(key: key);

  @override
  _TeamPositionSetupState createState() => _TeamPositionSetupState();
}

class _TeamPositionSetupState extends State<TeamPositionSetup> {
  final StorageService storage = locator<StorageService>();

  _TeamPositionSetupState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: widget.team.positions.length,
          itemBuilder: (context, index) {
            var position = widget.team.positions[index];
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
      floatingActionButton: SpeedDial(
        heroTag: "addPositions",
        tooltip: "Add Position(s)",
        icon: Icons.add,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.group_add),
              label: "Template",
              onTap: () {
                var newPosition = Position();
                Navigator.pushNamed(context, PositionTemplateSetup.route,
                    arguments: PositionArgs(newPosition))
                    .then((positions) {
                      if(positions != null) {
                        widget.team.positions.clear();
                        widget.team.positions.addAll(positions as List<Position>);
                        storage.saveTeam(widget.team);
                        setState(() {
                        });
                      }
                });
              }),
          SpeedDialChild(
              child: const Icon(Icons.person_add),
              label: "Single Position",
              onTap: () {
                var newPosition = Position();
                Navigator.pushNamed(context, PositionSetup.route,
                    arguments: PositionArgs(newPosition))
                    .then((obj) {
                  setState(() {
                    if(newPosition.id.isNotEmpty || newPosition.name.isNotEmpty) {
                      widget.team.positions.add(newPosition);
                      storage.saveTeam(widget.team);
                    }
                  });
                });
              }),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(5),
        child: Text("${widget.team.positions.length} positions", style: const TextStyle(color: Colors.white),),
        color: Colors.blue,
      ),
    );
  }
}
