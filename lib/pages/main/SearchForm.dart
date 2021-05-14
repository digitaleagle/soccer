import 'package:flutter/material.dart';
import 'package:search_widget/search_widget.dart';
import 'package:soccer/data/Team.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';

class SearchForm extends StatefulWidget {
  static const route = '/search';

  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  StorageService storage = locator<StorageService>();
  List<Team> teams;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Soccer: Search"),
      ),
      body: FutureBuilder(
        future: getSearchList(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            // Search Widget -- https://pub.dev/packages/search_widget
            return SearchWidget<Team>(
                dataList: teams
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<List<Team>> getSearchList() async {
        teams = await storage.listTeams();
        return teams;
  }
  
}