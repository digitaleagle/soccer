import 'package:flutter/material.dart';
import 'package:soccer/pages/data/DataForm.dart';
import 'package:soccer/pages/main/CommunicationListScreen.dart';
import 'package:soccer/pages/main/HomeScreen.dart';
import 'package:soccer/pages/main/SearchForm.dart';
import 'package:soccer/pages/setup/TeamListSetup.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
      DrawerHeader(
        child: Text('Soccer'),
        decoration: BoxDecoration(color: Colors.blue),
      ),
      ListTile(
        title: Text('Home'),
        onTap: () {
          Navigator.pushNamed(context, HomeScreen.route);
        },
      ),
      ListTile(
        title: Text("Search"),
        onTap: () {
          Navigator.pushNamed(context, SearchForm.route);
        },
      ),
      ListTile(
        title: Text("Setup"),
        onTap: () {
          Navigator.pushNamed(context, TeamListSetup.route);
        },
      ),
      ListTile(
        title: Text("Data"),
        onTap: () {
          Navigator.pushNamed(context, DataForm.route);
        },
      ),
      ListTile(
        title: Text("Communication"),
        onTap: () {
          Navigator.pushNamed(context, CommunicationListScreen.route);
        },
      ),
    ]));
  }
}
