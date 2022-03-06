import 'package:flutter/material.dart';
import 'package:soccer/data/Game.dart';
import 'package:soccer/data/Practice.dart';
import 'package:soccer/nav/args/EventArgs.dart';
import 'package:soccer/pages/main/GameMain.dart';
import 'package:soccer/pages/main/PracticeMain.dart';
import 'package:soccer/pages/setup/GameCheckboxes.dart';
import 'package:soccer/pages/util/DateField.dart';
import 'package:soccer/pages/util/TimeField.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';

class GameSetup extends StatefulWidget {
  static const route = "/setup/game";
  @override
  _GameSetupState createState() => _GameSetupState();
}

class _GameSetupState extends State<GameSetup> {
  StorageService storage = locator<StorageService>();
  final DateEditingController gameDateController = DateEditingController();
  final TimeEditingController gameTimeController = TimeEditingController();
  final TextEditingController fieldController = TextEditingController();
  final TextEditingController opponentController = TextEditingController();
  final TextEditingController refreshemntsController = TextEditingController();
  late EventArgs args;

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as EventArgs;
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          title: Text("Soccer: Game"),
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                Navigator.pushNamed(context, GameMain.route,
                    arguments: args);
              },
                itemBuilder: (context) {
              return [PopupMenuItem(value: "go", child: Text("Go"))];
            })
          ],
        ),
        body: FutureBuilder<Game>(
            future: getGame(args.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Game game = snapshot.data!;
                gameDateController.value = game.eventDate;
                gameTimeController.value = game.eventDate == null ? null: TimeOfDay.fromDateTime(game.eventDate);
                fieldController.text = game.field;
                opponentController.text = game.opponent;
                refreshemntsController.text = game.refreshments;
                return Form(
                    key: _formKey,
                    child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            DateField(
                              labelText: "Date of Game",
                              controller: gameDateController,
                              validator: (newValue) {
                                if(newValue == null) {
                                  return "Practice date is required";
                                }
                              },
                            ),
                            TimeField(
                              labelText: "Time of Game",
                              controller: gameTimeController,
                              validator: (newValue) {
                                if(newValue == null) {
                                  return "Practice time is required";
                                }
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: "Field"),
                              controller: fieldController,
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: "Opponent"),
                              controller: opponentController,
                            ),
                            TextFormField(
                              decoration: InputDecoration(labelText: "Refreshments"),
                              controller: refreshemntsController,
                            ),
                            GameCheckboxes(game: game),
                            Container(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                child: ElevatedButton(
                                  child: Text("Save"),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      DateTime date = gameDateController.value ?? DateTime.now();
                                      TimeOfDay? time = gameTimeController.value;
                                      game.eventDate = DateTime(date.year, date.month, date.day, time == null ? 0 : time.hour, time == null ? 0 : time.minute);
                                      game.field = fieldController.text;
                                      game.opponent = opponentController.text;
                                      game.refreshments = refreshemntsController.text;

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text("Saving...")));
                                      bool isNew = false;
                                      if (game.id <= 0) {
                                        isNew = true;
                                      }
                                      await storage.saveGame(game);
                                      if (isNew) {
                                        print("adding to team ${game.id}");
                                        args.team.addGame(game);
                                        await storage.saveTeam(args.team);
                                      }
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              SnackBar(content: Text("Saved")));
                                    }
                                  },
                                ))
                          ],
                        )));
              } else {
                return CircularProgressIndicator();
              }
            }));
  }

  Future<Game> getGame(int id) async {
    Game? game;
    if (id <= 0) {
      game = Game(eventDate: DateTime. now());
    } else {
      game = await storage.getGame(id);
    }
    if(game.teamId != args.team.id) {
      game.teamId = args.team.id;
    }
    return game;
  }
}
