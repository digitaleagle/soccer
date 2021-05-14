import 'package:soccer/data/Game.dart';
import 'package:soccer/data/GamePosition.dart';
import 'package:soccer/data/Player.dart';

class PositionSelectArgs {
  final int quarter;
  final Player player;
  final Game game;

  PositionSelectArgs(this.quarter, this.player, this.game);

}