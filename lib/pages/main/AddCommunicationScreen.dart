import 'package:flutter/material.dart';
import 'package:soccer/data/CommunicationItem.dart';
import 'package:soccer/data/CommunicationPlayer.dart';
import 'package:soccer/data/Team.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';

class AddCommunicationScreen extends StatefulWidget {
  static const route = "/communication/add";

  _AddCommunicationState createState() => _AddCommunicationState();
}

class _AddCommunicationState extends State<AddCommunicationScreen> {
  StorageService storage = locator<StorageService>();
  bool whatToAddSelected = false;
  bool teamsSelected = false;
  List<TeamSelection> teams = [];
  TypeSelection emailSelection = TypeSelection();
  TypeSelection primarySelection = TypeSelection();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Soccer: Add to Communication"),
      ),
      body: FutureBuilder(
        future: loadItems(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Visibility(
                  visible: !whatToAddSelected,
                  child: Flexible(
                    child: Container(
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text("Add Players from Team"),
                            onTap: () {
                              whatToAddSelected = true;
                              teamsSelected = true;
                              setState(() {});
                            },
                          ),
                          ListTile(
                            title: Text("Add Players from Practice"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: teamsSelected,
                  child: Flexible(
                    child: Container(
                      child: ListView.builder(
                        itemCount: teams.length,
                        itemBuilder: (context, index) {
                          TeamSelection team = teams[index];
                          print("team building ${team.team.name} -- ${team.selected}");
                          return TeamSelector(
                            key: widget.key,
                            title: team.team.name,
                            selection: team,
                            onChanged: (value) {
                              print("changing ... $value ... ${teams[0].selected} - ${teams[0].team.name} - ${team.team.name} = ${team.selected}");
                              // I don't understand why I have to do this
                              teams[index].selected = value;
                              print("changing ... $value ... ${teams[0].selected} - ${teams[0].team.name} - ${team.team.name} = ${team.selected}");
                            }
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: whatToAddSelected,
                  child: Flexible(
                    child: Container(
                      child: ListView(
                        children: [
                          TypeSelector(
                            selection: emailSelection,
                            title: "Include Emails",
                          ),
                          TypeSelector(
                            selection: primarySelection,
                            title: "Include Primary Numbers",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                      onPressed: () async {
                        List<CommunicationPlayer> returnList = [];
                        print("teams selected = $teamsSelected");
                        if(teamsSelected) {
                          for(var team in teams) {
                            print("team selected ... ${team.team.name} -- selected: ${team.selected}");
                            if(team.selected) {
                              for(var player in await team.team.players) {
                                var cp = CommunicationPlayer();
                                cp.player = player;
                                returnList.add(cp);
                              }
                            }
                          }
                        }
                        for(var cp in returnList) {
                          if(emailSelection.selected) {
                            var item = CommunicationItem();
                            item.isEmail = true;
                            item.player = cp.player;
                            item.address = cp.player.email;
                            cp.items.add(item);
                          }
                          if(primarySelection.selected) {
                            if(cp.player.playerPhonePreferred) {
                              var item = CommunicationItem();
                              if(cp.player.playerPhoneCanText) {
                                item.isText = true;
                              } else {
                                item.isCall = true;
                              }
                              item.player = cp.player;
                              item.address = cp.player.playerPhone;
                              cp.items.add(item);
                            }
                            if(cp.player.dadPhonePreferred) {
                              var item = CommunicationItem();
                              if(cp.player.dadPhoneCanText) {
                                item.isText = true;
                              } else {
                                item.isCall = true;
                              }
                              item.player = cp.player;
                              item.address = cp.player.dadPhone;
                              cp.items.add(item);
                            }
                            if(cp.player.momPhonePreferred) {
                              var item = CommunicationItem();
                              if(cp.player.momPhoneCanText) {
                                item.isText = true;
                              } else {
                                item.isCall = true;
                              }
                              item.player = cp.player;
                              item.address = cp.player.momPhone;
                              cp.items.add(item);
                            }
                          }
                        }
                        print("return list size = ${returnList.length}");
                        Navigator.pop(context, returnList);
                      },
                      child: Text("Add")),
                )
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<String> loadItems() async {
    var teams = await storage.listTeams();
    this.teams = [];
    for (var team in teams) {
      this.teams.add(TeamSelection(team));
    }
    return "";
  }
}

class TeamSelection {
  bool selected = false;
  Team team;

  TeamSelection(this.team);
}

class TypeSelection {
  bool selected = false;
}

class TeamSelector extends StatefulWidget {
  final TeamSelection selection;
  final String title;
  final ValueChanged<bool> onChanged;

  const TeamSelector({Key? key, required this.selection, required this.title, required this.onChanged}) : super(key: key);

  @override
  _TeamSelectorState createState() => _TeamSelectorState(selection, title, onChanged);
}

class _TeamSelectorState extends State<TeamSelector> {
  final TeamSelection selection;
  final String title;
  final ValueChanged<bool> onChanged;

  _TeamSelectorState(this.selection, this.title, this.onChanged);

  @override
  Widget build(BuildContext context) {
    print("building team selector ... ${selection.team.name} -- ${selection.selected}");
    return CheckboxListTile(
      title: Text(title),
      value: selection.selected,
      onChanged: (value) {
        setState(() {
          print("marking team ${selection.team.name} as $value  ${selection.selected}");
          selection.selected = value ?? false;
          if(onChanged != null) {
            onChanged(value ?? false);
          }
        });
      },
    );
  }
}


class TypeSelector extends StatefulWidget {
  final TypeSelection selection;
  final String title;
  final ValueChanged<bool>? onChanged;

  const TypeSelector({Key? key, required this.selection, required this.title, this.onChanged}) : super(key: key);

  @override
  _TypeSelectorState createState() => _TypeSelectorState();
}

class _TypeSelectorState extends State<TypeSelector> {
  _TypeSelectorState();

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.title),
      value: widget.selection.selected,
      onChanged: (value) {
        setState(() {
          widget.selection.selected = value ?? false;
          if(widget.onChanged != null) {
            widget.onChanged!(value ?? false);
          }
        });
      },
    );
  }
}