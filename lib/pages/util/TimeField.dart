import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeField extends StatefulWidget {
  final String labelText;
  final TimeEditingController controller;
  final FormFieldValidator<TimeOfDay>? validator;

  const TimeField({Key? key, this.labelText = "", required this.controller, this.validator}) : super(key: key);

  @override
  _TimeFieldState createState() => _TimeFieldState();
}

class _TimeFieldState extends State<TimeField> {
  TimeOfDay? _selectedTime;
  DateTime? _selectedDateTime;
  final now = DateTime.now();
  TextEditingController _controller = TextEditingController();
  DateFormat format = DateFormat("h:mma");

  @override
  Widget build(BuildContext context) {
    _selectedTime = widget.controller.value;
    _selectedDateTime = _selectedTime == null ? null: DateTime(now.year, now.month, now.day, _selectedTime!.hour, _selectedTime!.minute);
    _controller.text = _selectedDateTime == null ? "" : format.format(_selectedDateTime!);
    return TextFormField(
      key: widget.key,
      decoration: InputDecoration(labelText: widget.labelText,
          suffixIcon: IconButton(
            onPressed: () {
              _selectTime(context);
            },
            icon: Icon(Icons.schedule),
          )),
      controller: _controller,
      validator: (newValue) {
        try {
          _selectedTime = newValue == null ? null : TimeOfDay.fromDateTime(format.parse(newValue));
          widget.controller.value = _selectedTime;
          if(widget.validator != null) {
            widget.validator!(widget.controller.value);
          }
        } catch (e) {
          print("Invalid Date $newValue -- ${e.toString()}");
          return "Invalid date";
        }
      },
      onEditingComplete: () {
        print("editing complete ... ${_controller.text}");
        _selectedTime = TimeOfDay.fromDateTime(format.parse(_controller.text));
        widget.controller.value = _selectedTime;
      },
    );
  }

  _selectTime(BuildContext context) async {
    TimeOfDay? newSelectedDate = await showTimePicker(
        context: context,
        initialTime: _selectedTime != null ? _selectedTime! : TimeOfDay.fromDateTime(DateTime.now()),
        builder: (BuildContext context, Widget? child) {
          return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: Colors.deepPurple,
                  onPrimary: Colors.white,
                  surface: Colors.blueGrey,
                  onSurface: Colors.yellow,
                ),
                dialogBackgroundColor: Colors.blue[500],
              ),
              child: child!
          );
        }
    );

    if (newSelectedDate != null) {
      _selectedTime = newSelectedDate;
      _selectedDateTime = DateTime(now.year, now.month, now.day, _selectedTime == null ? 0 : _selectedTime!.hour, _selectedTime == null ? 0 : _selectedTime!.minute);
      _controller
        ..text = _selectedDateTime == null ? "" : format.format(_selectedDateTime!)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _controller.text.length, affinity: TextAffinity.upstream));
    }
  }

}

class TimeEditingController {
  TimeOfDay? value;
}