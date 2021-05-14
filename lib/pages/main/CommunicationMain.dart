import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:soccer/data/Communication.dart';
import 'package:soccer/data/CommunicationItem.dart';
import 'package:soccer/data/CommunicationPlayer.dart';
import 'package:soccer/nav/args/CommunicationArgs.dart';
import 'package:soccer/pages/main/AddCommunicationScreen.dart';
import 'package:soccer/pages/main/CommunicationItemScreen.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';
import 'package:telephony/telephony.dart';

class CommunicationMain extends StatefulWidget {
  static const route = "/communication";

  @override
  _CommunicationMainState createState() => _CommunicationMainState();
}

class _CommunicationMainState extends State {
  StorageService storage = locator<StorageService>();
  final _formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final smsTextController = TextEditingController();
  final emailsToSend = TextEditingController();
  CommunicationArgs args;

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;

    return FutureBuilder(
        future: getCommunication(args.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Communication communication = snapshot.data["communication"];
            List<CommunicationPlayer> items = snapshot.data["items"];
            descriptionController.text = communication.descr;
            smsTextController.text = communication.text;
            emailsToSend.text = buildEmailList(items);
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title: Text("Soccer: Communication"),
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        icon: Icon(Icons.phone),
                      ),
                      Tab(
                        icon: Icon(Icons.people),
                      ),
                    ],
                  ),
                ),
                body: Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                      child: Text("#${communication.id}")),
                                  Flexible(
                                    child: Container(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            labelText: "Description"),
                                        controller: descriptionController,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                child: TextFormField(
                                  decoration:
                                      InputDecoration(labelText: "SMS Text to send"),
                                  controller: smsTextController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                ),
                              ),
                              Container(
                                child: TextFormField(
                                  decoration:
                                  InputDecoration(labelText: "Emails"),
                                  controller: emailsToSend,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: ElevatedButton(
                                    onPressed: () {
                                      save(communication);
                                    },
                                    child: Text("Save")),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: ElevatedButton(
                                    onPressed: () async {

                                      var items = await communication.items;
                                      for(var playerItem in items) {
                                        for(var item in playerItem.items) {
                                          if(item.isEmail) {
                                            item.sent = true;
                                          }
                                        }
                                      }

                                      save(communication);
                                    },
                                    child: Text("Mark emails sent")),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: ElevatedButton(
                                    onPressed: () async {

                                      final Telephony telephony = Telephony.instance;
                                      bool permissionsGranted =
                                      await telephony.requestPhoneAndSmsPermissions;

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                          content: Text("Sending texts to everyone ...")));

                                      var items = await communication.items;
                                      for(var playerItem in items) {
                                        for(var item in playerItem.items) {
                                          if(item.isText) {
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
                                          }
                                          item.sent = true;
                                        }
                                      }

                                      save(communication);

                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          SnackBar(content: Text("Sent")));

                                    },
                                    child:
                                        Text("Send all texts")),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            CommunicationPlayer player = items[index];
                            String details = "";
                            for (var item in player.items) {
                              details = "$details, ${item.address}";
                            }
                            return ListTile(
                              title: Text(player.player.name),
                              subtitle: Text(details),
                              leading: CircleAvatar(
                                child: Icon(player.complete
                                    ? Icons.check
                                    : Icons.hourglass_bottom),
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, CommunicationItemScreen.route,
                                    arguments: CommunicationArgs(
                                      id: communication.id,
                                      communication: communication,
                                      player: player,
                                    )).then((value) {
                                  save(communication);
                                  setState(() {});
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  heroTag: "addContacts",
                  onPressed: () {
                    Navigator.pushNamed(context, AddCommunicationScreen.route,
                            arguments: CommunicationArgs(id: args.id))
                        .then((value) async {
                      if (value != null) {
                        List<CommunicationPlayer> returnedPlayers = value;
                        var items = await communication.items;
                        items.addAll(returnedPlayers);
                        save(communication);
                      }
                    });
                  },
                  tooltip: 'New Team',
                  child: Icon(Icons.add),
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });

    }

  save(Communication communication) async {
    if (_formKey.currentState.validate()) {
      communication.descr =
          descriptionController.text;
      communication.text =
          smsTextController.text;

      await storage.saveCommunication(communication);
      args.id = communication.id;
      setState(() {});
    }


  }

  Future<dynamic> getCommunication(int id) async {
    Communication communication;
    if (id <= 0) {
      communication = Communication();
    } else {
      communication = await storage.getCommunication(id);
    }
    List<CommunicationPlayer> items = await communication.items;
    return {
      "communication": communication,
      "items": items,
    };
  }

  String buildEmailList(List<CommunicationPlayer> items) {
    String list = "";
    for(var item in items) {
      for(var i in item.items) {
        if(i.isEmail) {
          if(list != "") {
            list = "$list; ";
          }
          list = "$list${i.address}";
        }
      }
    }
    return list;
  }

}
