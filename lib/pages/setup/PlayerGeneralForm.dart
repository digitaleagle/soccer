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
      {Key? key,
      required this.player,
      required this.nameController,
      required this.preferredNameController,
      required this.genderController,
      required this.jerseyController,
      required this.notesController,
      required this.flagReason,
      required this.saveFunction})
      : super(key: key);

  @override
  _PlayerGeneralState createState() => _PlayerGeneralState();
}

class _PlayerGeneralState extends State<PlayerGeneralForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (widget.genderController.text.isEmpty) {
      widget.genderController.text = " ";
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
                controller: widget.nameController,
                validator: (newValue) {
                  if (newValue == null || newValue.isEmpty) {
                    return "Please enter a name";
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Preferred Name"),
                controller: widget.preferredNameController,
              ),
              DropdownButtonFormField<String>(
                items: <String>[" ", "Male", "Female"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                value: widget.genderController.text,
                onChanged: (newValue) {
                  widget.genderController.text = newValue ?? "";
                },
                decoration: InputDecoration(labelText: "Gender"),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Jersey"),
                controller: widget.jerseyController,
              ),
              Row(children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    child: CheckboxListTile(
                        title: Text("Flag"),
                        value: widget.player.flag,
                        onChanged: (newValue) {
                          setState(() {
                            widget.player.flag = newValue ?? false;
                            if(!widget.player.flag) {
                              widget.flagReason.text = "";
                            }
                          });
                        }),
                  ),
                ),
                Visibility(
                  visible: widget.player.flag,
                  child: Flexible(
                    flex: 10,
                    child: Container(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Reason"),
                        controller: widget.flagReason,
                      ),
                    ),
                  ),
                ),
              ]),
              Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    this.widget.saveFunction(context, widget.player);
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
