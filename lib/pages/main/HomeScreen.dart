import 'package:flutter/material.dart';
import 'package:soccer/data/Game.dart';
import 'package:soccer/data/Practice.dart';
import 'package:soccer/data/Team.dart';
import 'package:soccer/nav/NavDrawer.dart';
import 'package:soccer/data/EventItem.dart';
import 'package:soccer/nav/args/EventArgs.dart';
import 'package:soccer/nav/args/TeamArgs.dart';
import 'package:soccer/pages/main/GameMain.dart';
import 'package:soccer/pages/main/PracticeMain.dart';
import 'package:soccer/pages/setup/TeamSetup.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State {
  StorageService storage = locator<StorageService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Soccer"),
        ),
        drawer: NavDrawer(),
        body: Container(
          padding: EdgeInsets.all(20),
          child: FutureBuilder(
            future: loadEvents(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<EventItem> events = snapshot.data;
                if (events.length == 0) {
                  return ListView(
                    children: [
                      ListTile(
                        title: Text("Click Here to Make a Team"),
                        tileColor: Colors.black12,
                        onTap: () {
                          Navigator.pushNamed(
                              context, TeamSetup.route, arguments: TeamArgs(
                              -1));
                        },
                      ),
                      ListTile(
                        title: Text("You currently have no teams"),
                        tileColor: Colors.white,
                      )
                    ],
                  );
                } else {
                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      EventItem event = events[index];
                      return ListTile(
                        title: Text(event.descr),
                        leading: CircleAvatar(
                          backgroundColor: event.eventType == EventType.Practice
                              ? Colors.green
                              : Colors.red,
                          child: Text(
                              event.eventType == EventType.Practice
                                  ? "P"
                                  : "G"),
                        ),
                        onTap: () {
                          var route = event.eventType == EventType.Practice
                              ? PracticeMain.route
                              : GameMain.route;
                          Navigator.pushNamed(context, route,
                              arguments: EventArgs(event.event.id, event.team));
                        },
                      );
                    },
                  );
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ));
  }

  Future<List<EventItem>> loadEvents() async {
    List<EventItem> list = [];
    List<Team> teams = await storage.listTeams();
    DateTime showAfter = DateTime.now().subtract(new Duration(days: 1));
    for (Team team in teams) {
      for (Practice practice in await team.practices) {
        if (practice.eventDate.isAfter(showAfter)) {
          EventItem event =
          EventItem(EventType.Practice, practice.id, practice, team);
          list.add(event);
        }
      }
      for (Game game in await team.games) {
        if (game.eventDate.isAfter(showAfter)) {
          EventItem event = EventItem(EventType.Game, game.id, game, team);
          list.add(event);
        }
      }
    }
    list.sort((a, b) => a.event.eventDate.compareTo(b.event.eventDate));
    return list;
  }
}
