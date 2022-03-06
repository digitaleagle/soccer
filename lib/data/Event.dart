import 'package:intl/intl.dart';

class Event {
  static final dateFormat = DateFormat.yMd().add_jm();

  Event({required this.id, required this.eventDate});

  int id;
  DateTime eventDate;
}