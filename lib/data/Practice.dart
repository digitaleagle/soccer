import 'dart:convert';

import 'package:soccer/data/Event.dart';
import 'package:intl/intl.dart';
import 'package:soccer/data/Player.dart';
import 'package:soccer/data/PracticePlayer.dart';


class Practice extends Event {
  int id;
  final List<int> attendees = [];
  final List<int> goalies = [];

  Practice({this.id = -1, required DateTime eventDate}) : super(id: id, eventDate: eventDate);

  bool get hasAttendance => (attendees.length > 0);

  String toJSON() {
    Object obj = {
      "id": id,
      "eventDate": Event.dateFormat.format(eventDate),
      "attendees": attendees,
      "goalies": goalies,
    };
    return jsonEncode(obj);
  }

  static Practice fromJSON(String json) {
    try {
      Map<String, dynamic> data = jsonDecode(json);
      var eventDate;
      try {
        eventDate = Event.dateFormat.parse(data["eventDate"]);
      } catch (d) {
        eventDate = DateTime.now();
      }
      Practice practice = Practice(
        id: data["id"],
        eventDate: eventDate
      );
      practice.attendees.clear();
      if(data["attendees"] != null) {
        for(int id in data["attendees"]) {
          practice.attendees.add(id);
        }
      }
      practice.goalies.clear();
      if(data["goalies"] != null) {
        for(int id in data["goalies"]) {
          practice.goalies.add(id);
        }
      }
      return practice;
    } catch(e) {
      print("Failed to load $json");
      throw Exception("Failed to load practice");
    }
  }

  List<PracticePlayer> loadPlayers(List<Player> list) {
    List<PracticePlayer> players = [];
    for(var player in list) {
      PracticePlayer p = PracticePlayer(player, this);
      if(attendees.contains(player.id)) {
        p.attended = true;
      }
      if(goalies.contains(player.id)) {
        p.goalie = true;
      }
      players.add(p);
    }
    return players;
  }
}