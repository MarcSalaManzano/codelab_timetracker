import 'package:codelab_timetracker/page_activities.dart';
import 'package:flutter/material.dart';

class CalculateTotalTime extends StatefulWidget {
  @override
  _CalculateTotalTimeState createState() => _CalculateTotalTimeState();
}

class _CalculateTotalTimeState extends State<CalculateTotalTime> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedHour = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.home),
              onPressed: () {
                while(Navigator.of(context).canPop()) {
                  //print("pop");
                  Navigator.of(context).pop();
                }
                PageActivities(0);}),
        ],
        title: const Text('Cerca per tag'),

      ),
      body:
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Data inicial:"),
                  RaisedButton(
                    onPressed: () => _selectDate(context), // Refer step 3
                    child: Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Hora inicial:"),
                  RaisedButton(
                    onPressed: () => _selectTime(context), // Refer step 3
                    child: Text(
                      "${selectedHour}",
                      style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedHour
    );
    if (picked != null && picked != selectedHour)
      setState(() {
        selectedHour = picked;
      });
  }
}
