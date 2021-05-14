import 'Player.dart';

class CommunicationItem {
  Player player;
  bool isEmail = false;
  bool isText = false;
  bool isCall = false;
  bool sent = false;
  bool complete = false;
  bool leftMessage = false;
  bool noAnswer = false;
  String address;
}