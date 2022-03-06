import 'package:soccer/data/Communication.dart';
import 'package:soccer/data/CommunicationPlayer.dart';

class CommunicationArgs {
  int id;
  final Communication? communication;
  final CommunicationPlayer? player;

  CommunicationArgs({required this.id, this.communication = null, this.player = null});
}