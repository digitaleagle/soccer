import 'package:flutter/material.dart';
import 'package:soccer/data/Player.dart';

class PlayerGeneralForm extends StatefulWidget {
  final Player player;
  final TextEditingController nameController;
  final TextEditingController preferredNameController;
  final TextEditingController genderController;
  final TextEditingController jerseyController;
  final TextEditingController notesController;
  final TextEditingController flagReason;
  final Function(BuildContext, Player) saveFunction;

  const PlayerGeneralForm(
      {Key key,
      this.player,
      this.nameController,
      this.preferredNameController,
      this.genderController,
      this.jerseyController,
      this.notesController,
      this.flagReason,
      this.saveFunction})
      : super(key: key);

  @override
  _PlayerGeneralState createState() => _PlayerGeneralState(
      player,
      nameController,
      preferredNameController,
      genderController,
      jerseyController,
      notesController,
      flagReason,
      saveFunction);
}

class _PlayerGeneralState extends State {
  final Player player;
  final TextEditingController nameController;
  final TextEditingController preferredNameController;
  final TextEditingController genderController;
  final TextEditingController jerseyController;
  final TextEditingController notesController;
  final TextEditingController flagReason;
  final Function(BuildContext, Player) saveFunction;
  final _formKey = GlobalKey<FormState>();

  _PlayerGeneralState(
      this.player,
      this.nameController,
      this.preferredNameController,
      this.genderController,
      this.jerseyController,
      this.notesController,
      this.flagReason,
      this.saveFunction);

  @override
  Widget build(BuildContext context) {
    if (genderController.text.isEmpty) {
      genderController.text = " ";
    }
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Name"),
                controller: nameController,
                validator: (newValue) {
                  if (newValue.isEmpty) {
                    return "Please enter a name";
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Preferred Name"),
                controller: preferredNameController,
              ),
              DropdownButtonFormField(
                items: <String>[" ", "Male", "Female"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                value: genderController.text,
                onChanged: (newValue) {
                  genderController.text = newValue;
                },
                decoration: InputDecoration(labelText: "Gender"),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Jersey"),
                controller: jerseyController,
              ),
              Row(children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    child: CheckboxListTile(
                        title: Text("Flag"),
                        value: player.flag,
                        onChanged: (newValue) {
                          setState(() {
                            player.flag = newValue;
                            if(!player.flag) {
                              flagReason.text = "";
                            }
                          });
                        }),
                  ),
                ),
                Visibility(
                  visible: player.flag,
                  child: Flexible(
                    flex: 10,
                    child: Container(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Reason"),
                        controller: flagReason,
                      ),
                    ),
                  ),
                ),
              ]),
              Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    this.saveFunction(context, player);
                  },
                  child: Text("Save"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
