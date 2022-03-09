import 'package:flutter/material.dart';
import 'package:soccer/data/Position.dart';
import 'package:soccer/pages/main/FieldPlayer.dart';

class PositionTemplateSetup extends StatefulWidget {
  static const route = "/team/position_templates";

  const PositionTemplateSetup({Key? key}) : super(key: key);

  @override
  State<PositionTemplateSetup> createState() => _PositionTemplateSetupState();
}

class _PositionTemplateSetupState extends State<PositionTemplateSetup> {
  List<Position> _positions = [];
  String _selectedTemplate = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Soccer: Choose Position Layout"),
      ),
      body: Column(
        children: [
          Flexible(
            child: InteractiveViewer(
              child: AspectRatio(
                aspectRatio: 1046/732,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    var fieldItems = <Widget>[
                      const Image(
                        image: AssetImage("assets/graphics/field.png"),
                      ),
                    ];
                    for (Position position in _positions) {
                      var _top = constraints.biggest.height * (position.top / 100) -
                          (FieldPlayer.height);
                      var _left = constraints.biggest.width * (position.left / 100);
                      fieldItems.add(Positioned(
                        top: _top,
                        left: _left,
                        child: FieldPlayer(
                          position: position,
                          positionOnly: true,
                        ),
                      ));
                    }

                    return Stack(
                      children: fieldItems,
                    );
                  },
                ),
              ),
            ),
          ),
          Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                  child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Choose a template",
                      ),
                      value: _selectedTemplate,
                      items: const [
                        DropdownMenuItem(value: "", child: Text(" ")),
                        DropdownMenuItem(value: "default", child: Text("4-3-3 Default (11 Players)")),
                        DropdownMenuItem(
                            value: "433attack",
                            child: Text("4-3-3 Attack (11 Players)")),
                        DropdownMenuItem(
                            value: "433defense",
                            child: Text("4-3-3 Defense (11 Players)")),
                        DropdownMenuItem(
                            value: "442diamond",
                            child: Text("4-4-2 Diamond (11 Players)")),
                        DropdownMenuItem(
                            value: "442flat",
                            child: Text("4-4-2 Flat (11 Players)")),
                        DropdownMenuItem(
                            value: "231", child: Text("2-3-1 (7 Players)")),
                        DropdownMenuItem(
                            value: "1311", child: Text("1-3-1-1 (7 Players)")),
                        DropdownMenuItem(
                            value: "321", child: Text("3-2-1 (7 Players)")),
                        DropdownMenuItem(
                            value: "222", child: Text("2-2-2 (7 Players)")),
                        DropdownMenuItem(
                            value: "141", child: Text("1-4-1 (7 Players)")),
                        DropdownMenuItem(
                            value: "213", child: Text("2-1-3 (7 Players)")),
                      ],
                      onChanged: _pickTemplate),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _positions);
                  },
                  child: const Text("Save"))
            ],
          ),
        ],
      ),
    );
  }

  void _pickTemplate(String? templateName) {
    _selectedTemplate = templateName ?? "";
    switch (templateName) {
      case "default":
        _positions = _getDefaultPosition();
        break;
      case "433attack":
        _positions = _get433Attack();
        break;
      case "433defense":
        _positions = _get433Defense();
        break;
      case "442diamond":
        _positions = _get442Diamond();
        break;
      case "442flat":
        _positions = _get442Flat();
        break;
      case "231":
        _positions = _get231();
        break;
      case "1311":
        _positions = _get1311();
        break;
      case "321":
        _positions = _get321();
        break;
      case "222":
        _positions = _get222();
        break;
      case "141":
        _positions = _get141();
        break;
      case "213":
        _positions = _get213();
        break;
      default:
        _positions = [];
        break;
    }
    setState(() {});
  }

  List<Position> _getDefaultPosition() {
    List<Position> positions = [];

    positions.add(Position(
      id: "G",
      name: "Goalie",
      top: 50.0,
      left: 1.0,
    ));
    positions.add(Position(
      id: "S",
      name: "Sweeper",
      top: 60.0,
      left: 10.0,
    ));
    positions.add(Position(
      id: "LB",
      name: "Left Back",
      top: 25.0,
      left: 25.0,
    ));
    positions.add(Position(
      id: "CB",
      name: "Center Back",
      top: 50.0,
      left: 25.0,
    ));
    positions.add(Position(
      id: "RB",
      name: "Right Back",
      top: 75.0,
      left: 25.0,
    ));
    positions.add(Position(
      id: "LM",
      name: "Left Mid",
      top: 25.0,
      left: 45.0,
    ));
    positions.add(Position(
      id: "CM",
      name: "Center Mid",
      top: 50.0,
      left: 45.0,
    ));
    positions.add(Position(
      id: "RM",
      name: "Right Mid",
      top: 75.0,
      left: 45.0,
    ));
    positions.add(Position(
      id: "LF",
      name: "Left Forward",
      top: 25.0,
      left: 70.0,
    ));
    positions.add(Position(
      id: "CF",
      name: "Center Forward",
      top: 50.0,
      left: 70.0,
    ));
    positions.add(Position(
      id: "RF",
      name: "Right Forward",
      top: 75.0,
      left: 70.0,
    ));

    return positions;
  }

  List<Position> _get433Attack() {
    List<Position> positions = [];

    positions.add(Position(
      id: "G",
      name: "Goalie",
      top: 50.0,
      left: 1.0,
    ));
    positions.add(Position(
      id: "LWB",
      name: "Left Wing Back",
      top: 17.0,
      left: 25.0,
    ));
    positions.add(Position(
      id: "LB",
      name: "Left Back",
      top: 30.0,
      left: 20.0,
    ));
    positions.add(Position(
      id: "RB",
      name: "Right Back",
      top: 60.0,
      left: 20.0,
    ));
    positions.add(Position(
      id: "RWB",
      name: "Right Wing Back",
      top: 80.0,
      left: 25.0,
    ));
    positions.add(Position(
      id: "LM",
      name: "Left Mid",
      top: 35.0,
      left: 51.0,
    ));
    positions.add(Position(
      id: "CM",
      name: "Center Mid",
      top: 50.0,
      left: 35.0,
    ));
    positions.add(Position(
      id: "RM",
      name: "Right Mid",
      top: 65.0,
      left: 51.0,
    ));
    positions.add(Position(
      id: "LF",
      name: "Left Forward",
      top: 25.0,
      left: 70.0,
    ));
    positions.add(Position(
      id: "CF",
      name: "Center Forward",
      top: 50.0,
      left: 70.0,
    ));
    positions.add(Position(
      id: "RF",
      name: "Right Forward",
      top: 75.0,
      left: 70.0,
    ));

    return positions;
  }

  List<Position> _get433Defense() {
    List<Position> positions = [];

    positions.add(Position(
      id: "G",
      name: "Goalie",
      top: 50.0,
      left: 1.0,
    ));
    positions.add(Position(
      id: "LWB",
      name: "Left Wing Back",
      top: 17.0,
      left: 25.0,
    ));
    positions.add(Position(
      id: "LB",
      name: "Left Back",
      top: 30.0,
      left: 20.0,
    ));
    positions.add(Position(
      id: "RB",
      name: "Right Back",
      top: 60.0,
      left: 20.0,
    ));
    positions.add(Position(
      id: "RWB",
      name: "Right Wing Back",
      top: 80.0,
      left: 25.0,
    ));
    positions.add(Position(
      id: "LM",
      name: "Left Mid",
      top: 35.0,
      left: 40.0,
    ));
    positions.add(Position(
      id: "CM",
      name: "Center Mid",
      top: 50.0,
      left: 51.0,
    ));
    positions.add(Position(
      id: "RM",
      name: "Right Mid",
      top: 65.0,
      left: 40.0,
    ));
    positions.add(Position(
      id: "LF",
      name: "Left Forward",
      top: 25.0,
      left: 70.0,
    ));
    positions.add(Position(
      id: "CF",
      name: "Center Forward",
      top: 50.0,
      left: 70.0,
    ));
    positions.add(Position(
      id: "RF",
      name: "Right Forward",
      top: 75.0,
      left: 70.0,
    ));

    return positions;
  }

  List<Position> _get442Diamond() {
    List<Position> positions = [];

    positions.add(Position(
      id: "G",
      name: "Goalie",
      top: 50.0,
      left: 1.0,
    ));
    positions.add(Position(
      id: "LWB",
      name: "Left Wing Back",
      top: 17.0,
      left: 25.0,
    ));
    positions.add(Position(
      id: "LB",
      name: "Left Back",
      top: 30.0,
      left: 20.0,
    ));
    positions.add(Position(
      id: "RB",
      name: "Right Back",
      top: 60.0,
      left: 20.0,
    ));
    positions.add(Position(
      id: "RWB",
      name: "Right Wing Back",
      top: 80.0,
      left: 25.0,
    ));
    positions.add(Position(
      id: "LM",
      name: "Left Mid",
      top: 35.0,
      left: 45.0,
    ));
    positions.add(Position(
      id: "CM",
      name: "Center Mid Back",
      top: 46.0,
      left: 35.0,
    ));
    positions.add(Position(
      id: "C2",
      name: "Center Mid Front",
      top: 52.0,
      left: 51.0,
    ));
    positions.add(Position(
      id: "RM",
      name: "Right Mid",
      top: 65.0,
      left: 45.0,
    ));
    positions.add(Position(
      id: "LF",
      name: "Left Forward",
      top: 25.0,
      left: 70.0,
    ));
    positions.add(Position(
      id: "RF",
      name: "Right Forward",
      top: 75.0,
      left: 70.0,
    ));

    return positions;
  }

  List<Position> _get442Flat() {
    List<Position> positions = [];

    positions.add(Position(
      id: "G",
      name: "Goalie",
      top: 50.0,
      left: 1.0,
    ));
    positions.add(Position(
      id: "LWB",
      name: "Left Wing Back",
      top: 17.0,
      left: 25.0,
    ));
    positions.add(Position(
      id: "LB",
      name: "Left Back",
      top: 30.0,
      left: 20.0,
    ));
    positions.add(Position(
      id: "RB",
      name: "Right Back",
      top: 60.0,
      left: 20.0,
    ));
    positions.add(Position(
      id: "RWB",
      name: "Right Wing Back",
      top: 80.0,
      left: 25.0,
    ));
    positions.add(Position(
      id: "LWM",
      name: "Left Wing Mid",
      top: 25.0,
      left: 45.0,
    ));
    positions.add(Position(
      id: "LM",
      name: "Left Mid",
      top: 40.0,
      left: 45.0,
    ));
    positions.add(Position(
      id: "RM",
      name: "Right Mid",
      top: 55.0,
      left: 45.0,
    ));
    positions.add(Position(
      id: "RWM",
      name: "Right Wing Mid",
      top: 70.0,
      left: 45.0,
    ));
    positions.add(Position(
      id: "LF",
      name: "Left Forward",
      top: 35.0,
      left: 70.0,
    ));
    positions.add(Position(
      id: "RF",
      name: "Right Forward",
      top: 60.0,
      left: 70.0,
    ));

    return positions;
  }

  List<Position> _get231() {
    List<Position> positions = [];

    positions.add(Position(
      id: "G",
      name: "Goalie",
      top: 50.0,
      left: 1.0,
    ));
    positions.add(Position(
      id: "LB",
      name: "Left Back",
      top: 30.0,
      left: 20.0,
    ));
    positions.add(Position(
      id: "RB",
      name: "Right Back",
      top: 70.0,
      left: 20.0,
    ));
    positions.add(Position(
      id: "LM",
      name: "Left Mid",
      top: 30.0,
      left: 45.0,
    ));
    positions.add(Position(
      id: "CM",
      name: "Center Mid",
      top: 50.0,
      left: 45.0,
    ));
    positions.add(Position(
      id: "RM",
      name: "Right Mid",
      top: 70.0,
      left: 45.0,
    ));
    positions.add(Position(
      id: "LF",
      name: "Left Forward",
      top: 30.0,
      left: 70.0,
    ));
    positions.add(Position(
      id: "RF",
      name: "Right Forward",
      top: 70.0,
      left: 70.0,
    ));

    return positions;
  }

  List<Position> _get1311() {
    List<Position> positions = [];

    positions.add(Position(
      id: "G",
      name: "Goalie",
      top: 50.0,
      left: 1.0,
    ));
    positions.add(Position(
      id: "FB",
      name: "Full Back",
      top: 50.0,
      left: 15.0,
    ));
    positions.add(Position(
      id: "LM",
      name: "Left Mid",
      top: 30.0,
      left: 37.0,
    ));
    positions.add(Position(
      id: "CM",
      name: "Center Mid",
      top: 50.0,
      left: 37.0,
    ));
    positions.add(Position(
      id: "RM",
      name: "Right Mid",
      top: 70.0,
      left: 37.0,
    ));
    positions.add(Position(
      id: "F1",
      name: "Back Forward",
      top: 45.0,
      left: 55.0,
    ));
    positions.add(Position(
      id: "F2",
      name: "Front Forward",
      top: 52.0,
      left: 70.0,
    ));

    return positions;
  }

  List<Position> _get321() {
    List<Position> positions = [];

    positions.add(Position(
      id: "G",
      name: "Goalie",
      top: 50.0,
      left: 1.0,
    ));
    positions.add(Position(
      id: "LB",
      name: "Left Back",
      top: 25.0,
      left: 20.0,
    ));
    positions.add(Position(
      id: "CB",
      name: "Center Back",
      top: 50.0,
      left: 20.0,
    ));
    positions.add(Position(
      id: "RB",
      name: "Right Back",
      top: 75.0,
      left: 20.0,
    ));
    positions.add(Position(
      id: "LM",
      name: "Left Mid",
      top: 35.0,
      left: 47.0,
    ));
    positions.add(Position(
      id: "RM",
      name: "Right Mid",
      top: 60.0,
      left: 47.0,
    ));
    positions.add(Position(
      id: "CF",
      name: "Forward",
      top: 50.0,
      left: 70.0,
    ));

    return positions;
  }

  List<Position> _get222() {
    List<Position> positions = [];

    positions.add(Position(
      id: "G",
      name: "Goalie",
      top: 50.0,
      left: 1.0,
    ));
    positions.add(Position(
      id: "LB",
      name: "Left Back",
      top: 25.0,
      left: 20.0,
    ));
    positions.add(Position(
      id: "RB",
      name: "Right Back",
      top: 75.0,
      left: 20.0,
    ));
    positions.add(Position(
      id: "LM",
      name: "Left Mid",
      top: 35.0,
      left: 47.0,
    ));
    positions.add(Position(
      id: "RM",
      name: "Right Mid",
      top: 60.0,
      left: 47.0,
    ));
    positions.add(Position(
      id: "LF",
      name: "Forward",
      top: 25.0,
      left: 70.0,
    ));
    positions.add(Position(
      id: "RF",
      name: "Center Back",
      top: 75.0,
      left: 70.0,
    ));

    return positions;
  }

  List<Position> _get141() {
    List<Position> positions = [];

    positions.add(Position(
      id: "G",
      name: "Goalie",
      top: 50.0,
      left: 1.0,
    ));
    positions.add(Position(
      id: "FB",
      name: "Full Back",
      top: 50.0,
      left: 20.0,
    ));
    positions.add(Position(
      id: "LWM",
      name: "Left Wing Mid",
      top: 25.0,
      left: 45.0,
    ));
    positions.add(Position(
      id: "LM",
      name: "Left Mid",
      top: 40.0,
      left: 45.0,
    ));
    positions.add(Position(
      id: "RM",
      name: "Right Mid",
      top: 55.0,
      left: 45.0,
    ));
    positions.add(Position(
      id: "RWM",
      name: "Right Wing Mid",
      top: 70.0,
      left: 45.0,
    ));
    positions.add(Position(
      id: "FW",
      name: "Forward",
      top: 50.0,
      left: 70.0,
    ));

    return positions;
  }

  List<Position> _get213() {
    List<Position> positions = [];

    positions.add(Position(
      id: "G",
      name: "Goalie",
      top: 50.0,
      left: 1.0,
    ));
    positions.add(Position(
      id: "LB",
      name: "Left Back",
      top: 35.0,
      left: 20.0,
    ));
    positions.add(Position(
      id: "RB",
      name: "Right Back",
      top: 65.0,
      left: 20.0,
    ));
    positions.add(Position(
      id: "CM",
      name: "Center Mid",
      top: 50.0,
      left: 45.0,
    ));
    positions.add(Position(
      id: "LF",
      name: "Left Forward",
      top: 25.0,
      left: 70.0,
    ));
    positions.add(Position(
      id: "CF",
      name: "Center Forward",
      top: 50.0,
      left: 70.0,
    ));
    positions.add(Position(
      id: "RF",
      name: "Right Forward",
      top: 75.0,
      left: 70.0,
    ));

    return positions;
  }
}
