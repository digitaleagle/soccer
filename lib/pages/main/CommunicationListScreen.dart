import 'package:flutter/material.dart';
import 'package:soccer/data/Communication.dart';
import 'package:soccer/nav/args/CommunicationArgs.dart';
import 'package:soccer/nav/args/TeamArgs.dart';
import 'package:soccer/pages/main/CommunicationMain.dart';
import 'package:soccer/pages/setup/TeamSetup.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';
import 'package:telephony/telephony.dart';

class CommunicationListScreen extends StatefulWidget {
  static String route = "/communications";

  @override
  _CommunicationListScreenState createState() =>
      _CommunicationListScreenState();
}

class _CommunicationListScreenState extends State {
  StorageService storage = locator<StorageService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Soccer: Communications"),
      ),
      body: FutureBuilder(
          future: getCommunicationList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Communication> communications = snapshot.data;

              return Column(
                children: [
                  Flexible(
                    child: Container(
                      child: ListView.builder(
                        itemCount: communications.length,
                        itemBuilder: (context, index) {
                          Communication communication = communications[index];
                          return ListTile(
                            title: Text(communication.descr),
                            onTap: () {
                              Navigator.pushNamed(context, CommunicationMain.route,
                                  arguments: CommunicationArgs(id: communication.id)).then((value) {
                                setState(() {

                                });
                              });
                            },
                            trailing: FloatingActionButton(
                              child: Icon(Icons.delete),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue,
                              onPressed: () {
                                storage.deleteCommunication(communication);
                                setState(() {

                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: Text("Test SMS"),
                    onPressed: () async {
                      final Telephony telephony = Telephony.instance;
                      bool permissionsGranted =
                          await telephony.requestPhoneAndSmsPermissions;
                      telephony.sendSms(
                          to: "****", message: "Testing my soccer app!!");
                    },
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
      floatingActionButton: FloatingActionButton(
        heroTag: "newCommunication",
        onPressed: () {
          Navigator.pushNamed(context, CommunicationMain.route,
              arguments: CommunicationArgs(id: -1)).then((value) {
                setState(() {

                });
          });
        },
        tooltip: 'New Communication',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<List<Communication>> getCommunicationList() {
    return storage.listCommunications();
  }
}
