import 'package:flutter/material.dart';
import 'package:soccer/data/Player.dart';
import 'package:soccer/nav/args/PlayerArgs.dart';
import 'package:soccer/pages/setup/PlayerSetup.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class SearchForm extends StatefulWidget {
  static const route = '/search';

  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  StorageService storage = locator<StorageService>();
  List<Player> results = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Soccer: Search"),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 60, 10, 10),
            child: const Center(
                child: Text(
              "Note: Search is experimental.",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
          ),
          FloatingSearchBar(
            hint: "Search...",
            isScrollControlled: true,
            debounceDelay: const Duration(milliseconds: 500),
            onQueryChanged: doSearch,
            actions: [
              FloatingSearchBarAction(
                showIfOpened: false,
                child: CircularButton(
                  icon: const Icon(Icons.place),
                  onPressed: () {},
                ),
              ),
              FloatingSearchBarAction.searchToClear(
                showIfClosed: false,
              ),
            ],
            builder: (BuildContext context, Animation<double> transition) {
              return ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(results[index].name),
                    onTap: () async {
                      Navigator.pushNamed(context, PlayerSetup.route,
                          arguments: PlayerArgs(results[index].id,
                              await storage.findPlayersTeam(results[index])));
                    },
                  );
                },
              );
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  color: Colors.white,
                  elevation: 4.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: Colors.accents.map((color) {
                      return Container(height: 112, color: color);
                    }).toList(),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void doSearch(String inputQuery) async {
    var query = inputQuery.toLowerCase();
    results.clear();

    var teams = await storage.listTeams();
    for (var team in teams) {
      for (var player in await team.players) {
        if (player.name.toLowerCase().contains(query)) {
          results.add(player);
        }
      }
    }
  }
}
