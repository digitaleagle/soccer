import 'package:flutter/material.dart';
import 'package:soccer/data/Player.dart';
import 'package:soccer/pages/setup/ContactItem.dart';

class PlayerContactForm extends StatelessWidget {
  final Player player;
  final TextEditingController emailController;
  final ContactEditingController momContactController;
  final ContactEditingController playerContactController;
  final ContactEditingController dadContactController;
  final Function(BuildContext, Player) saveFunction;
  final _formKey = GlobalKey<FormState>();

  PlayerContactForm(
    this.player,
    this.emailController,
    this.momContactController,
    this.playerContactController,
    this.dadContactController,
    this.saveFunction,
  );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              ContactItem(
                showName: false,
                  controller: playerContactController),
              ContactItem(
                labelPrefix: "Mom's ",
                  controller: momContactController),
              ContactItem(
                  labelPrefix: "Dad's ",
                  controller: dadContactController),
              TextFormField(
                decoration: InputDecoration(labelText: "Email Address"),
                controller: emailController,
              ),
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
