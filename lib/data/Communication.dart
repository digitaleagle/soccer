import 'dart:convert';

import 'package:soccer/data/CommunicationItem.dart';
import 'package:soccer/data/CommunicationPlayer.dart';
import 'package:soccer/service/StorageService.dart';
import 'package:soccer/service/serviceLocator.dart';

class Communication {
  int id = -1;
  String descr = "";
  bool isComplete = false;
  final List<CommunicationPlayer> _items = [];
  bool listIsLoaded = false;
  String text = "";

  Future<List<CommunicationPlayer>> get items async {
    if(!listIsLoaded) {
      await loadList();
    }
    return _items;
  }

  loadList() async {
    StorageService storage = locator<StorageService>();

    for(var player in _items) {
      player.player = await storage.getPlayer(player.player_id!);
      for(var item in player.items) {
        item.player = player.player;
      }
    }

    listIsLoaded = true;
  }

  String toJSON() {
    var playerList = [];
    for(var player in _items) {
      var itemList = [];
      for(var item in player.items) {
        Object item_obj = {
          "isEmail": item.isEmail,
          "isText": item.isText,
          "isCall": item.isCall,
          "address": item.address,
          "sent": item.sent,
          "complete": item.complete,
          "leftMessage": item.leftMessage,
          "noAnswer": item.noAnswer,
        };
        itemList.add(item_obj);
      }
      Object player_obj = {
        "id": player.player_id,
        "items": itemList,
        "complete": player.complete,
      };
      playerList.add(player_obj);
    }
    Object obj = {
      "id": id,
      "descr": descr,
      "isComplete": isComplete,
      "items": playerList,
      "text": text,
    };
    return jsonEncode(obj);
  }

  static Communication fromJSON(String json) {
    try {
      Map<String, dynamic> obj = jsonDecode(json);
      Communication communication = Communication();
      communication.id = obj["id"];
      communication.descr = obj["descr"];
      communication.isComplete = obj["isComplete"] == true;
      if(obj["text"] == null) {
        communication.text = "";
      } else {
        communication.text = obj["text"];
      }
      communication.listIsLoaded = false;
      communication._items.clear();
      if(obj["items"] != null) {
        for (var p in obj["items"]) {
          CommunicationPlayer player = CommunicationPlayer();
          player.player_id = p["id"];
          player.complete = p["complete"] == true;
          for (var i in p["items"]) {
            var item = CommunicationItem();
            item.isEmail = i["isEmail"];
            item.isCall = i["isCall"];
            item.isText = i["isText"];
            item.address = i["address"];
            item.sent = i["sent"] == true;
            item.complete = i["complete"] == true;
            item.leftMessage = i["leftMessage"] == true;
            item.noAnswer = i["noAnswe"] == true;
            player.items.add(item);
          }
          communication._items.add(player);
        }
      }
      return communication;
    } catch (e) {
      print("Error loading Communication $e");
      throw Exception("Error loading communication");
    }
  }
}