import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeField extends StatefulWidget {
  final String labelText;
  final TimeEditingController controller;
  final FormFieldValidator<TimeOfDay> validator;

  const TimeField({Key key, this.labelText = "", this.controller, this.validator}) : super(key: key);

  @override
  _TimeFieldState createState() => _TimeFieldState(this.labelText, this.key, this.controller, this.validator);
}

class _TimeFieldState extends State {
  final String labelText;
  final Key key;
  final TimeEditingController dateController;
  final FormFieldValidator<TimeOfDay> validator;
  TimeOfDay _selectedTime;
  DateTime _selectedDateTime;
  final now = DateTime.now();
  TextEditingController _controller = TextEditingController();
  DateFormat format = DateFormat("h:mma");

  _TimeFieldState(this.labelText, this.key, this.dateController, this.validator);

  @override
  Widget build(BuildContext context) {
    _selectedTime = dateController.value;
    _selectedDateTime = _selectedTime == null ? null: DateTime(now.year, now.month, now.day, _selectedTime.hour, _selectedTime.minute);
    _controller.text = _selectedDateTime == null ? "" : format.format(_selectedDateTime);
    return TextFormField(
      key: this.key,
      decoration: InputDecoration(labelText: this.labelText,
          suffixIcon: IconButton(
            onPressed: () {
              _selectTime(context);
            },
            icon: Icon(Icons.schedule),
          )),
      controller: _controller,
      validator: (newValue) {
        try {
          _selectedTime = TimeOfDay.fromDateTime(format.parse(newValue));
          dateController.value = _selectedTime;
          if(this.validator != null) {
            this.validator.call(dateController.value);
          }
        } catch (e) {
          print("Invalid Date $newValue -- ${e.toString()}");
          return "Invalid date";
        }
      },
      onEditingComplete: () {
        print("editing complete ... ${_controller.text}");
        _selectedTime = TimeOfDay.fromDateTime(format.parse(_controller.text));
        dateController.value = _selectedTime;
      },
    );
  }

  _selectTime(BuildContext context) async {
    TimeOfDay newSelectedDate = await showTimePicker(
        context: context,
        initialTime: _selectedTime != null ? _selectedTime : TimeOfDay.fromDateTime(DateTime.now()),
        builder: (BuildContext context, Widget child) {
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
              child: child
          );
        }
    );

    if (newSelectedDate != null) {
      _selectedTime = newSelectedDate;
      _selectedDateTime = DateTime(now.year, now.month, now.day, _selectedTime.hour, _selectedTime.minute);
      _controller
        ..text = format.format(_selectedDateTime)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _controller.text.length, affinity: TextAffinity.upstream));
    }
  }

}

class TimeEditingController {
  TimeOfDay value;
}