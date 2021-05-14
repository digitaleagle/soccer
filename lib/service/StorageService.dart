import 'package:soccer/data/Communication.dart';
import 'package:soccer/data/Game.dart';
import 'package:soccer/data/Player.dart';
import 'package:soccer/data/Practice.dart';
import 'package:soccer/data/RestoreResult.dart';
import 'package:soccer/data/Team.dart';

abstract class StorageService {
  Future<List<Team>> listTeams();

  Future<Team> getTeam(int id);

  Future<void> saveTeam(Team team);

  Future<Player> getPlayer(int id);

  Future<void> savePlayer(Player player);

  Future<Game> getGame(int id);

  Future<void> saveGame(Game game);

  Future<Practice> getPractice(int id);

  Future<void> savePractice(Practice practice);

  Future<String> backup();

  Future<RestoreResult> restore(String json);

  Future<RestoreResult> restoreUpdate(String json);

  Future<void> googleSignIn();

  Future<Communication> getCommunication(int id);

  Future<void> saveCommunication(Communication communication);

  Future<List<Communication>> listCommunications();

  Future<void> deleteCommunication(Communication communication);
}