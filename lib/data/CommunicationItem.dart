import 'Player.dart';

class CommunicationItem {
  Player? player;
  bool isEmail;
  bool isText;
  bool isCall;
  bool sent;
  bool complete;
  bool leftMessage;
  bool noAnswer;
  String address;
  String note;

  CommunicationItem({
    this.player,
    this.isEmail = false,
    this.isText = false,
    this.isCall = false,
    this.sent = false,
    this.complete = false,
    this.leftMessage = false,
    this.noAnswer = false,
    this.address = "",
    this.note = "",
  });
}
