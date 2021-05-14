import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateField extends StatefulWidget {
  final String labelText;
  final DateEditingController controller;
  final FormFieldValidator<DateTime> validator;

  const DateField({Key key, this.labelText = "", this.controller, this.validator}) : super(key: key);

  @override
  _DateFieldState createState() => _DateFieldState(this.labelText, this.key, this.controller, this.validator);
}

class _DateFieldState extends State {
  final String labelText;
  final Key key;
  final DateEditingController dateController;
  final FormFieldValidator<DateTime> validator;
  DateTime _selectedDate;
  TextEditingController _controller = TextEditingController();
  DateFormat format = DateFormat.yMd();

  _DateFieldState(this.labelText, this.key, this.dateController, this.validator);

  @override
  Widget build(BuildContext context) {
    _selectedDate = dateController.value;
    _controller.text = _selectedDate == null ? "" : format.format(_selectedDate);
    return TextFormField(
      key: this.key,
      decoration: InputDecoration(labelText: this.labelText,
          suffixIcon: IconButton(
            onPressed: () {
              _selectDate(context);
            },
            icon: Icon(Icons.calendar_today),
          )),
      controller: _controller,
      validator: (newValue) {
        try {
          dateController.value = format.parse(newValue);
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
        dateController.value = format.parse(_controller.text);
      },
    );
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(3000),
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
      _selectedDate = newSelectedDate;
      _controller
        ..text = format.format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _controller.text.length, affinity: TextAffinity.upstream));
    }
  }

}

class DateEditingController {
  DateTime value;
}