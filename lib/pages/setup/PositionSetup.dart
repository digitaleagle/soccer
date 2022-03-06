import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soccer/nav/args/PositionArgs.dart';

class PositionSetup extends StatelessWidget {
  static const route = "/team/position";

  @override
  Widget build(BuildContext context) {
    final PositionArgs args = ModalRoute.of(context)!.settings.arguments as PositionArgs;
    var position = args.position;

    return Scaffold(
      appBar: AppBar(
        title: Text("Soccer: Team Position"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: "id"),
              initialValue: position.id,
              onChanged: (value) {
                position.id = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Name"),
              initialValue: position.name,
              onChanged: (value) {
                position.name = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Top"),
              initialValue: position.top.toString(),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
              onChanged: (value) {
                position.top = double.parse(value);
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Left"),
              initialValue: position.left.toString(),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
              onChanged: (value) {
                position.left = double.parse(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
