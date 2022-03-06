import 'package:flutter/material.dart';

class PrefSelector extends StatefulWidget {
  final String label;
  double value;
  final ValueChanged<double>? onChanged;

  PrefSelector({Key? key, required this.label, required this.value, this.onChanged}) : super(key: key);

  @override
  _PrefSelectorState createState() => _PrefSelectorState();
}

class _PrefSelectorState extends State<PrefSelector> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.label),
        Expanded(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                  alignment: Alignment.centerLeft,
                  child: Text(getDescrValue(widget.value))),
              Slider(
                min: 0,
                max: 5,
                divisions: 5,
                value: widget.value,
                label: getDescrValue(widget.value),
                onChanged: (newValue) {
                  widget.value = newValue.roundToDouble();
                  if(widget.onChanged != null) {
                    widget.onChanged!(widget.value);
                  }
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
