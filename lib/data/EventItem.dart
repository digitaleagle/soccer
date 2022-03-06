import 'package:intl/intl.dart';
import 'package:soccer/data/Event.dart';
import 'package:soccer/data/Team.dart';

class EventItem {
  final EventType eventType;
  final int id;
  final Event event;
  final Team team;

  EventItem(this.eventType, this.id, this.event, this.team);

  get descr {
    DateFormat dateFormat = DateFormat("M/d/yyyy");
    if(eventType == EventType.Game) {
      return "Game: ${dateFormat.format(event.eventDate)}";
    } else {
      return "Practice: ${dateFormat.format(event.eventDate)}";
    }
  }
}

enum EventType {
  Practice,
  Game
}