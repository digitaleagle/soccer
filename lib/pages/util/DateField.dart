import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateField extends StatefulWidget {
  final String labelText;
  final DateEditingController controller;
  final FormFieldValidator<DateTime>? validator;

  const DateField({Key? key, this.labelText = "", required this.controller, this.validator}) : super(key: key);

  @override
  _DateFieldState createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  DateTime? _selectedDate;
  TextEditingController _controller = TextEditingController();
  DateFormat format = DateFormat.yMd();

  @override
  Widget build(BuildContext context) {
    _selectedDate = widget.controller.value;
    _controller.text = _selectedDate == null ? "" : format.format(_selectedDate!);
    return TextFormField(
      key: widget.key,
      decoration: InputDecoration(labelText: widget.labelText,
          suffixIcon: IconButton(
            onPressed: () {
              _selectDate(context);
            },
            icon: Icon(Icons.calendar_today),
          )),
      controller: _controller,
      validator: (newValue) {
        if(newValue == null || newValue.isEmpty) {
          return "Please select a date";
        }
        try {
          widget.controller.value = format.parse(newValue);
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
        widget.controller.value = format.parse(_controller.text);
      },
    );
  }

  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate! : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(3000),
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
      _selectedDate = newSelectedDate;
      _controller
        ..text = (_selectedDate == null ? "" : format.format(_selectedDate!))
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _controller.text.length, affinity: TextAffinity.upstream));
    }
  }

}

class DateEditingController {
  DateTime? value;
}