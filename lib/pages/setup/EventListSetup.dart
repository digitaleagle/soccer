import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:soccer/data/Event.dart';
import 'package:soccer/data/Game.dart';
import 'package:soccer/data/Practice.dart';
import 'package:soccer/data/Team.dart';
import 'package:soccer/nav/args/EventArgs.dart';
import 'package:soccer/pages/setup/PracticeSetup.dart';

import 'GameSetup.dart';

class EventListSetup extends StatefulWidget {
  final Team team;

  EventListSetup(this.team);

  @override
  _EventListSetupState createState() => _EventListSetupState(this.team);
}

class _EventListSetupState extends State {
  final Team team;
  static final _dateFormat = DateFormat('M/d/yyyy @ K:mma');

  _EventListSetupState(this.team);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: FutureBuilder(
          future: buildEvents(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Event> events = snapshot.data;
              // https://www.geeksforgeeks.org/flutter-grouped-list/
              return GroupedListView(
                elements: events,
                groupBy: (event) {
                  if (event is Game) {
                    return "Game";
                  } else {
                    return "Practice";
                  }
                },
                itemBuilder: (c, event) {
                  return ListTile(
                    title: Text(_dateFormat.format(event.eventDate)),
                    onTap: () {
                      var route = event is Practice ? PracticeSetup.route : GameSetup.route;
                      Navigator.pushNamed(context, route,
                              arguments: EventArgs(event.id, team))
                          .then((value) {
                        setState(() {});
                      });
                    },
                  );
                },
                groupSeparatorBuilder: (group) {
                  return Text(
                    group,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  );
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: SpeedDial(
        heroTag: "newEvent",
        tooltip: "New Event",
        icon: Icons.add,
        children: [
          SpeedDialChild(
              child: Icon(Icons.add),
              label: "Practice",
              onTap: () {
                Navigator.pushNamed(context, PracticeSetup.route,
                        arguments: EventArgs(-1, team))
                    .then((value) {
                  setState(() {});
                });
              }),
          SpeedDialChild(
              child: Icon(Icons.add),
              label: "Game",
              onTap: () {
                Navigator.pushNamed(context, GameSetup.route,
                        arguments: EventArgs(-1, team))
                    .then((value) {
                  setState(() {});
                });
              }),
        ],
      ),
    );
  }

  Future<List<Event>> buildEvents() async {
    List<Event> events = [];
    List<Game> games = await team.games;
    events.addAll(games);
    List<Practice> practices = await team.practices;
    events.addAll(practices);
    return events;
  }
}
