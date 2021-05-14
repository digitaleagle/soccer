import 'package:flutter/material.dart';

class ContactItem extends StatefulWidget {
  final ContactEditingController controller;
  final String labelPrefix;
  final bool showName;

  const ContactItem({this.controller, this.labelPrefix = "", this.showName = true});

  @override
  _ContactItem createState() => _ContactItem(controller, labelPrefix, showName);
}

class _ContactItem extends State {
  final ContactEditingController controller;
  final String labelPrefix;
  final bool showName;

  _ContactItem(this.controller, this.labelPrefix, this.showName);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Visibility(
          visible: showName,
          child: Flexible(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: TextFormField(
                controller: controller.nameController,
                decoration: InputDecoration(labelText: "${labelPrefix}Name"),
              ),
            ),
          ),
        ),
        Flexible(
            child: Container(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: TextFormField(
            controller: controller.phoneController,
            decoration: InputDecoration(labelText: "${labelPrefix}Phone"),
          ),
        )),
        Flexible(child: Container(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child:                 CheckboxListTile(
            title: Text("Primary"),
            controlAffinity: ListTileControlAffinity.leading,
            value: controller.primary,
            onChanged: (value) {
              setState(() {
                controller.primary = value;
              });
            },
          ),

        )),
        Flexible(child: Container(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child:                 CheckboxListTile(
            title: Text("Can Text"),
            controlAffinity: ListTileControlAffinity.leading,
            value: controller.canText,
            onChanged: (value) {
              setState(() {
                controller.canText = value;
              });
            },
          ),

        )),
      ],
    );
  }
}

class ContactEditingController {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool canText = false;
  bool primary = false;

  update(String name, String phone, bool primary, bool canText) {
    nameController.text = name;
    phoneController.text = phone;
    this.primary = primary;
    this.canText = canText;
  }
}
