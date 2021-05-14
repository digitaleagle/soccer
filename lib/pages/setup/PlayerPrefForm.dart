import 'package:flutter/material.dart';
import 'package:soccer/data/Player.dart';
import 'package:soccer/pages/setup/PlayerPrefSliders.dart';
import 'package:soccer/pages/util/PrefSelector.dart';

class PlayerPrefForm extends StatelessWidget {
  final Player player;
  final Function(BuildContext, Player) saveFunction;
  final _formKey = GlobalKey<FormState>();

  PlayerPrefForm(
      this.player,
      this.saveFunction);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              PlayerPrefSliders(player, false),
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
