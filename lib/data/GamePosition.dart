import 'package:soccer/data/Player.dart';
import 'package:soccer/data/Position.dart';

class GamePosition {
  Player player;
  Position position;
  int quarter;

  GamePosition({required this.player, required this.position, required this.quarter});
}