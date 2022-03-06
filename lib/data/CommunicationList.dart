import 'dart:convert';

class CommunicationList {
  final List<int> idList = [];
  int nextId = 1;

  String toJSON() {
    Object obj = {
      "idList": idList,
      "nextId": nextId,
    };
    print("saving ... $nextId");
    return jsonEncode(obj);
  }

  static CommunicationList fromJSON(String json) {
    print("loading comm list  $json");
    try {
      var obj = jsonDecode(json);
      CommunicationList comm = CommunicationList();
      comm.idList.clear();
      if (obj['idList'].length > 0) {
        for (int id in obj['idList']) {
          if(!comm.idList.contains(id)) {
            comm.idList.add(id);
          }
        }
      }
      comm.nextId = obj["nextId"];
      print("loaded  ${comm.nextId}");
      return comm;
    } catch (e) {
      print("Failed to load communication list: $e");
      throw Exception("Failed to load communication list: $json");
    }
  }
}