import 'package:flutter/material.dart';
import 'package:soccer/nav/args/CommunicationArgs.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';
import 'package:telephony/telephony.dart';

class CommunicationItemScreen extends StatefulWidget {
  static const route = "/communication/item";

  @override
  _CommunicationItemState createState() => _CommunicationItemState();
}

class _CommunicationItemState extends State {
  StorageService storage = locator<StorageService>();

  @override
  Widget build(BuildContext context) {
    final CommunicationArgs args = ModalRoute.of(context)!.settings.arguments as CommunicationArgs;
    var communication = args.communication;
    var player = args.player;
    if(communication == null) {
      throw Exception("Screen can't have null communication");
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Soccer: Communication Item"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Player: ${player!.player.name}"),
            CheckboxListTile(
              title: Text("Player Communication Complete?"),
              value: player.complete,
              onChanged: (value) async {
                player.complete = value ?? false;
                if(communication == null) {
                  throw Exception("Can't save null communication");
                }
                await storage.saveCommunication(communication);
                setState(() {});
              },
            ),
            Flexible(
                child: Container(
              child: ListView.separated(
                itemCount: player.items.length,
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemBuilder: (context, index) {
                  var item = player.items[index];
                  return Container(
                      child: Row(
                    children: [
                      Expanded(
                        child: Column(children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(item.address)),
                          CheckboxListTile(
                              title: Text("Sent"),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: item.sent,
                              onChanged: (value) async {
                                item.sent = value ?? false;
                                if(communication == null) {
                                  throw Exception("Can't save null communication");
                                }
                                await storage.saveCommunication(communication);
                                setState(() {});
                              }),
                          CheckboxListTile(
                              title: Text("Complete/Answered"),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: item.complete,
                              onChanged: (value) async {
                                item.complete = value ?? false;
                                if(communication == null) {
                                  throw Exception("Can't save null communication");
                                }
                                await storage.saveCommunication(communication);
                                setState(() {});
                              }),
                          Visibility(
                            visible: !item.isEmail,
                            child: CheckboxListTile(
                                title: Text("Left Message"),
                                controlAffinity: ListTileControlAffinity.leading,
                                value: item.leftMessage,
                                onChanged: (value) async {
                                  item.leftMessage = value ?? false;
                                  if(communication == null) {
                                    throw Exception("Can't save null communication");
                                  }
                                  await storage.saveCommunication(communication);
                                  setState(() {});
                                }),
                          ),
                          Visibility(
                            visible: !item.isEmail,
                            child: CheckboxListTile(
                                title: Text("No Answer"),
                                controlAffinity: ListTileControlAffinity.leading,
                                value: item.noAnswer,
                                onChanged: (value) async {
                                  item.noAnswer = value ?? false;
                                  if(communication == null) {
                                    throw Exception("Can't save null communication");
                                  }
                                  await storage.saveCommunication(communication);
                                  setState(() {});
                                }),
                          ),
                        ]),
                      ),
                      Visibility(
                        visible: item.isText && !item.sent,
                        child: FloatingActionButton(
                          child: Text("Send"),
                          onPressed: () async {

                            final Telephony telephony = Telephony.instance;
                            bool permissionsGranted =
                            (await telephony.requestPhoneAndSmsPermissions) ?? false;

                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                content: Text("Sending to ${item.address} ...")));

                            if(communication.text.length > 160) {
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

                            ScaffoldMessenger.of(context)
                                .hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).removeCurrentSnackBar();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                                SnackBar(content: Text("Sent")));


                            item.sent = true;
                            if(communication == null) {
                              throw Exception("Can't save null communication");
                            }
                            await storage.saveCommunication(communication);
                            setState(() {});

                            ScaffoldMessenger.of(context)
                                .hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).removeCurrentSnackBar();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                                SnackBar(content: Text("Sent and saved")));

                          },
                        ),
                      ),
                    ],
                  ));
                },
              ),
            ))
          ],
        ),
      ),
    );
  }
}
