import 'package:flutter/material.dart';
import 'package:soccer/data/Player.dart';
import 'package:soccer/nav/args/PlayerArgs.dart';
import 'package:soccer/pages/setup/ContactItem.dart';
import 'package:soccer/pages/setup/PlayerContactForm.dart';
import 'package:soccer/pages/setup/PlayerGeneralForm.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';

import 'PlayerPrefForm.dart';

class PlayerSetup extends StatefulWidget {
  static const route = '/setup/player';

  @override
  _PlayerSetupState createState() => _PlayerSetupState();
}

class _PlayerSetupState<PlayerSetup> extends State {
  StorageService storage = locator<StorageService>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController preferredNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController jerseyController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController flagReason = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final ContactEditingController momController = ContactEditingController();
  final ContactEditingController playerController = ContactEditingController();
  final ContactEditingController dadController = ContactEditingController();

  @override
  Widget build(BuildContext context) {
    final PlayerArgs args = ModalRoute.of(context).settings.arguments;

    return DefaultTabController(
        length: 3,
        child: WillPopScope(
            onWillPop: checkSave,
            child: Scaffold(
              appBar: AppBar(
                  title: Text("Soccer: Player"),
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        text: "Details",
                      ),
                      Tab(
                        text: "Contact",
                      ),
                      Tab(
                        text: "Preferences",
                      )
                    ],
                  )),
              body: FutureBuilder(
                future: getPlayer(args.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Player player = snapshot.data;
                    nameController.text = player.name;
                    preferredNameController.text = player.preferredName;
                    genderController.text = player.gender;
                    jerseyController.text = player.jersey;
                    playerController.update("", player.playerPhone,
                        player.playerPhonePreferred, player.playerPhoneCanText);
                    momController.update(player.mom, player.momPhone,
                        player.momPhonePreferred, player.momPhoneCanText);
                    dadController.update(player.dad, player.dadPhone,
                        player.dadPhonePreferred, player.dadPhoneCanText);
                    emailController.text = player.email;
                    flagReason.text = player.flagReason;
                    return TabBarView(
                      children: [
                        PlayerGeneralForm(
                          player: player,
                          nameController: nameController,
                          preferredNameController: preferredNameController,
                          genderController: genderController,
                          jerseyController: jerseyController,
                          notesController: notesController,
                          flagReason: flagReason,
                          saveFunction: saveFunction,
                        ),
                        PlayerContactForm(
                            player,
                            emailController,
                            momController,
                            playerController,
                            dadController,
                            saveFunction),
                        PlayerPrefForm(player, saveFunction),
                      ],
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
            )));
  }

  void saveFunction(BuildContext context, Player player) async {
    final PlayerArgs args = ModalRoute.of(context).settings.arguments;
    print("save function start ... ${args.parentTeam.id}");

    player.name = nameController.text;
    player.preferredName = preferredNameController.text;
    player.gender = genderController.text;
    player.jersey = jerseyController.text;
    player.playerPhone = playerController.phoneController.text;
    player.playerPhonePreferred = playerController.primary;
    player.playerPhoneCanText = playerController.canText;
    player.mom = momController.nameController.text;
    player.momPhone = momController.phoneController.text;
    player.momPhonePreferred = momController.primary;
    player.momPhoneCanText = momController.canText;
    player.dad = dadController.nameController.text;
    player.dadPhone = dadController.phoneController.text;
    player.dadPhonePreferred = dadController.primary;
    player.dadPhoneCanText = dadController.canText;
    player.email = emailController.text;
    player.flagReason = flagReason.text;
    print("saving ... ${player.toJSON()}");

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Saving...")));
    bool addToTeam = false;
    if (player.id <= 0) {
      addToTeam = true;
    }
    print("player before -- ${player.toJSON()}");
    await storage.savePlayer(player);
    print("player after -- ${player.toJSON()}");
    if (addToTeam) {
      args.parentTeam.addPlayer(player);
      await storage.saveTeam(args.parentTeam);
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Saved")));
  }

  Future<bool> checkSave() async {
    print("Is it saved?");
    return true;
  }

  Future<Player> getPlayer(int id) async {
    print("PlayerSetup id = $id");
    if (id <= 0) {
      return Player();
    }
    return storage.getPlayer(id);
  }
}
