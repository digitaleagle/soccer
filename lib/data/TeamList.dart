import 'dart:convert';

class TeamList {
  final List<int> idList = [];
  int nextId = 1;

  String toJSON() {
    Object obj = {
      "idList": this.idList,
      "nextId": this.nextId
    };
    return jsonEncode(obj);
  }

  static TeamList fromJSON(String json) {
    try {
      var obj = jsonDecode(json);
      TeamList team = TeamList();

      team.nextId = obj["nextId"];

      team.idList.clear();
      if (obj['idList'].length > 0) {
        for (int id in obj['idList']) {
          team.idList.add(id);
          if(id >= team.nextId) {
            team.nextId = id + 1;
          }
        }
      }
      return team;
    } catch (e) {
      print("Failed to load team list: $e");
      throw Exception("Failed to load team list: $json");
    }
  }
}