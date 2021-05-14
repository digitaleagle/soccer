import 'dart:convert';

import 'package:reflectable/reflectable.dart';


class Player extends Reflectable {
  Player();
  int id = -1;
  String name;
  String gender;
  String jersey;
  String playerPhone;
  bool playerPhonePreferred = false;
  bool playerPhoneCanText = false;
  String mom;
  String momPhone;
  bool momPhonePreferred = false;
  bool momPhoneCanText = false;
  String dad;
  String dadPhone;
  bool dadPhonePreferred = false;
  bool dadPhoneCanText = false;
  String preferredName;
  String email;
  String notes;
  bool flag;
  String flagReason;
  double goaliePref = 0;
  double forwardPref = 0;
  double midFieldPref = 0;
  double defensePref = 0;
  double sweeperPref = 0;


  String toJSON() {
    Object obj = {
      "id": this.id,
      "name": this.name,
      "gender": this.gender,
      "jersey": this.jersey,
      "playerPhone": this.playerPhone,
      "playerPhonePreferred": this.playerPhonePreferred,
      "playerPhoneCanText": this.playerPhoneCanText,
      "mom": this.mom,
      "momPhone": this.momPhone,
      "momPhonePreferred": this.momPhonePreferred,
      "momPhoneCanText": this.momPhoneCanText,
      "dad": this.dad,
      "dadPhone": this.dadPhone,
      "dadPhonePreferred": this.dadPhonePreferred,
      "dadPhoneCanText": this.dadPhoneCanText,
      "preferredName": this.preferredName,
      "email": this.email,
      "notes": this.notes,
      "flag": this.flag,
      "flagReason": this.flagReason,
      "goaliePref": this.goaliePref,
      "forwardPref": this.forwardPref,
      "midFieldPref": this.midFieldPref,
      "defensePref": this.defensePref,
      "sweeperPref": this.sweeperPref,
    };
    /* List<String> properties = [];
    InstanceMirror im = reflect(Player());
    ClassMirror classMirror = im.type;
    for(TypeVariableMirror t in classMirror.typeVariables) {
      properties.add(t.qualifiedName);
    } */
    //return "Testing(${jsonEncode(obj)}); props(${properties.join(',')})";
    return jsonEncode(obj);
  }

  static Player fromJSON(String json) {
    try {
      Map<String, dynamic> obj = jsonDecode(json);
      Player player = Player();
      player.id = obj["id"];
      player.name = obj["name"];
      player.gender = obj["gender"];
      player.jersey = obj["jersey"];
      player.playerPhone = obj["playerPhone"];
      player.playerPhonePreferred = obj["playerPhonePreferred"] == true;
      player.playerPhoneCanText = obj["playerPhoneCanText"] == true;
      player.mom = obj["mom"];
      player.momPhone = obj["momPhone"];
      player.momPhonePreferred = obj["momPhonePreferred"] == true;
      player.momPhoneCanText = obj["momPhoneCanText"] == true;
      player.dad = obj["dad"];
      player.dadPhone = obj["dadPhone"];
      player.dadPhonePreferred = obj["dadPhonePreferred"] == true;
      player.dadPhoneCanText = obj["dadPhoneCanText"] == true;
      player.preferredName = obj["preferredName"];
      player.email = obj["email"];
      player.flag = obj["flag"] == true;
      if(obj["flagReason"] == null) {
        player.flagReason = "";
      } else {
        player.flagReason = obj["flagReason"];
      }
      if(obj["notes"] != null) {
        player.notes = obj["notes"];
      } else {
        player.notes = "";
      }
      player.goaliePref = obj["goaliePref"] == null ? 0 : obj["goaliePref"];
      player.forwardPref = obj["forwardPref"] == null ? 0 : obj["forwardPref"];
      player.midFieldPref = obj["midFieldPref"] == null ? 0 : obj["midFieldPref"];
      player.defensePref = obj["defensePref"] == null ? 0 : obj["defensePref"];
      player.sweeperPref = obj["sweeperPref"] == null ? 0 : obj["sweeperPref"];
      return player;
    } catch (e) {
      print("Error loading player $e");
      throw Exception("Error loading player");
    }
  }
}