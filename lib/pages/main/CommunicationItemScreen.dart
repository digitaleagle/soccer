import 'package:flutter/material.dart';
import 'package:soccer/data/CommunicationItem.dart';
import 'package:soccer/data/Team.dart';
import 'package:soccer/nav/args/CommunicationArgs.dart';
import 'package:soccer/nav/args/PlayerArgs.dart';
import 'package:soccer/pages/setup/PlayerSetup.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';
import 'package:telephony/telephony.dart';

class CommunicationItemScreen extends StatefulWidget {
  static const route = "/communication/item";

  const CommunicationItemScreen({Key? key}) : super(key: key);

  @override
  _CommunicationItemState createState() => _CommunicationItemState();
}

class _CommunicationItemState extends State {
  StorageService storage = locator<StorageService>();
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    final CommunicationArgs args =
        ModalRoute.of(context)!.settings.arguments as CommunicationArgs;
    var communication = args.communication;
    var player = args.player;
    if (communication == null) {
      throw Exception("Screen can't have null communication");
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Soccer: Communication Item"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.person, size: 30),
                Expanded(child: Text("Player: ${player!.player.name}",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)),
                Visibility(
                  visible: player.player.flag,
                  child: const Icon(
                    Icons.flag,
                    color: Colors.red,
                    size: 32.0,
                    semanticLabel: "Soccer Player Main Number",
                  ),
                ),
              ],
            ),
            CheckboxListTile(
              title: const Text("Player Communication Complete?"),
              value: player.complete,
              onChanged: (value) async {
                player.complete = value ?? false;
                await storage.saveCommunication(communication);
                setState(() {});
              },
            ),
            Row(
              children: [
                Switch(
                  value: _showDetails,
                  onChanged: (bool value) {
                    setState(() {
                      _showDetails = !_showDetails;
                    });
                  },
                ),
                const Text("Show Details"),
              ],
            ),
            Visibility(
              visible: _showDetails,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 24.0,
                        semanticLabel: "Soccer Player Name",
                      ),
                      Text("Name: ${player.player.name}"),
                      IconButton(
                        icon: const Icon(Icons.open_in_new),
                        tooltip: "Add to contacted items",
                        onPressed: () async {
                          Team team = await storage.findPlayersTeam(player.player);
                          Navigator.pushNamed(context, PlayerSetup.route,
                              arguments: PlayerArgs(player.player.id, team)).then((value) {
                                setState(() {

                                });
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone,
                        size: 24.0,
                        semanticLabel: "Soccer Player Main Number",
                      ),
                      Text("Main Phone: ${player.player.playerPhone}"),
                      IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: "Add to contacted items",
                        onPressed: () {
                          player.items.add(CommunicationItem(
                            player: player.player,
                            address: player.player.playerPhone,
                            complete: false,
                            isCall: true,
                            isText: player.player.playerPhoneCanText,
                            isEmail: false,
                          ));
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.female,
                        size: 24.0,
                        semanticLabel: "Mom Name/Number",
                      ),
                      Text(
                          "Mom: ${player.player.mom} ${player.player.momPhone}"),
                      IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: "Add to contacted items",
                        onPressed: () {
                          player.items.add(CommunicationItem(
                            player: player.player,
                            address: player.player.momPhone,
                            complete: false,
                            isCall: true,
                            isText: player.player.momPhoneCanText,
                            isEmail: false,
                          ));
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.male,
                        size: 24.0,
                        semanticLabel: "Dad Name/Number",
                      ),
                      Text(
                          "Dad: ${player.player.dad} ${player.player.dadPhone}"),
                      IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: "Add to contacted items",
                        onPressed: () {
                          player.items.add(CommunicationItem(
                            player: player.player,
                            address: player.player.dadPhone,
                            complete: false,
                            isCall: true,
                            isText: player.player.dadPhoneCanText,
                            isEmail: false,
                          ));
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Flexible(
                child: ListView.separated(
                  itemCount: player.items.length,
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemBuilder: (context, index) {
                    var item = player.items[index];
                    TextEditingController _noteController =
                        TextEditingController();
                    _noteController.text = item.note;
                    return Row(
                      children: [
                    Expanded(
                      child: Column(children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(item.address)),
                        CheckboxListTile(
                            title: const Text("Sent"),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: item.sent,
                            onChanged: (value) async {
                              item.sent = value ?? false;
                              await storage.saveCommunication(communication);
                              setState(() {});
                            }),
                        CheckboxListTile(
                            title: const Text("Complete/Answered"),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: item.complete,
                            onChanged: (value) async {
                              item.complete = value ?? false;
                              await storage.saveCommunication(communication);
                              setState(() {});
                            }),
                        Visibility(
                          visible: !item.isEmail,
                          child: CheckboxListTile(
                              title: const Text("Left Message"),
                              controlAffinity:
                                  ListTileControlAffinity.leading,
                              value: item.leftMessage,
                              onChanged: (value) async {
                                item.leftMessage = value ?? false;
                                await storage
                                    .saveCommunication(communication);
                                setState(() {});
                              }),
                        ),
                        Visibility(
                          visible: !item.isEmail,
                          child: CheckboxListTile(
                              title: const Text("No Answer"),
                              controlAffinity:
                                  ListTileControlAffinity.leading,
                              value: item.noAnswer,
                              onChanged: (value) async {
                                item.noAnswer = value ?? false;
                                await storage
                                    .saveCommunication(communication);
                                setState(() {});
                              }),
                        ),
                        TextField(
                          decoration: const InputDecoration(labelText: "Note"),
                          controller: _noteController,
                          onChanged: (String newValue) async {
                            item.note = newValue;
                            await storage.saveCommunication(communication);
                          },
                        ),
                      ]),
                    ),
                    Visibility(
                      visible: item.isText && !item.sent,
                      child: FloatingActionButton(
                        child: const Text("Send"),
                        onPressed: () async {
                          final Telephony telephony = Telephony.instance;
                          bool permissionsGranted = (await telephony
                                  .requestPhoneAndSmsPermissions) ??
                              false;

                          if (!permissionsGranted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Permission to SMS not granted")));
                            return;
                          }

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Sending to ${item.address} ...")));

                          if (communication.text.length > 160) {
                            telephony.sendSms(
                              to: item.address,
                              message: communication.text,
                              isMultipart: true,
                            );
                          } else {
                            telephony.sendSms(
                                to: item.address,
                                message: communication.text);
                          }

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context)
                              .removeCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Sent")));

                          item.sent = true;
                          await storage.saveCommunication(communication);
                          setState(() {});

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context)
                              .removeCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Sent and saved")));
                        },
                      ),
                    ),
                      ],
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }
}
