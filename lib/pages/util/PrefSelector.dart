import 'package:flutter/material.dart';

class PrefSelector extends StatefulWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const PrefSelector({Key key, this.label, this.value, this.onChanged}) : super(key: key);

  @override
  _PrefSelectorState createState() => _PrefSelectorState(label, value, onChanged);
}

class _PrefSelectorState extends State {
  final String label;
  double _value;
  final ValueChanged<double> onChanged;

  _PrefSelectorState(this.label, this._value, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
        Expanded(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                  alignment: Alignment.centerLeft,
                  child: Text(getDescrValue(_value))),
              Slider(
                min: 0,
                max: 5,
                divisions: 5,
                value: _value,
                label: getDescrValue(_value),
                onChanged: (value) {
                  _value = value.roundToDouble();
                  onChanged(_value);
                  setState(() {});
                },
              )
            ],
          ),
        )
      ],
    );
  }

  String getDescrValue(double value) {
    var rounded = value.round();
    if (rounded == 0) return "N/A";
    if (rounded == 1) return "Never";
    if (rounded == 2) return "Maybe";
    if (rounded == 3) return "Sometimes";
    if (rounded == 4) return "Enjoy";
    if (rounded == 5) return "Favorite";
    return "?? ${value.toString()}";
  }
}
