import 'dart:convert';

import 'package:soccer/data/Event.dart';
import 'package:intl/intl.dart';
import 'package:soccer/data/Player.dart';
import 'package:soccer/data/PracticePlayer.dart';


class Practice extends Event {
  int id = -1;
  final List<int> attendees = [];
  final List<int> goalies = [];

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
      Practice practice = Practice();
      practice.id = data["id"];
      try {
        practice.eventDate = Event.dateFormat.parse(data["eventDate"]);
      } catch (d) {
        practice.eventDate = DateTime.now();
      }
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