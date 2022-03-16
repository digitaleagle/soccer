
import 'package:flutter/material.dart';
import 'package:soccer/data/Team.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';

class TeamGeneralForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final Team team;
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController playersController;
  final StorageService storage = locator<StorageService>();

  TeamGeneralForm(this.team, this.nameController, this.ageController, this.playersController);

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: "Team Name"),
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a name";
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Age"),
                  controller: ageController,
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return "Please enter an age";
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Players on Field"),
                  controller: playersController,
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return "Please enter the number of players";
                    }
                  },
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            team.name = nameController.value.text;
                            team.age = ageController.value.text;
                            team.playersOnField = int.parse(playersController.value.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Saving...")));
                            storage.saveTeam(team);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Saved")));
                          }
                        },
                        child: Text("Save"))
                ),

              ])),
        ));
  }
}