import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soccer/data/RestoreResult.dart';

class LoadResults extends StatelessWidget {
  static final String route = "/data/loaded";

  @override
  Widget build(BuildContext context) {
    final RestoreResult result = ModalRoute.of(context).settings.arguments;
    final TextEditingController errorTextController = TextEditingController();
    errorTextController.text = result.errorMessage;

    return Scaffold(
      appBar: AppBar(
        title: Text("Soccer: Data Loaded"),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text("Loaded"),
          ),
          Visibility(
            visible: result.success,
            child: Flexible(
              child: ListView(
                children: [
                  ListTile(
                    title: Text("Teams Loaded: ${result.teamsLoaded}"),
                  ),
                  ListTile(
                    title: Text("Players Loaded: ${result.playersLoaded}"),
                  ),
                  ListTile(
                    title: Text("Games Loaded: ${result.gamesLoaded}"),
                  ),
                  ListTile(
                    title: Text("Practices Loaded: ${result.practicesLoaded}"),
                  ),
                  ListTile(
                    title: Text("Communications Loaded: ${result.communicationsLoaded}"),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: !result.success,
              child: Flexible(
                child: TextField(
            controller: errorTextController,
            decoration: InputDecoration(labelText: "Error Message"),
          ),
              ))
        ],
      ),
    );
  }

}