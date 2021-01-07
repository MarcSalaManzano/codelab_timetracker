import 'package:codelab_timetracker/page_activities.dart';
import 'package:codelab_timetracker/page_find_tag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalculateTotalTime extends StatefulWidget {
  @override
  _CalculateTotalTimeState createState() => _CalculateTotalTimeState();
}

class _CalculateTotalTimeState extends State<CalculateTotalTime> {
  final _formKey = GlobalKey<FormState>();
  DateTime initialDate = DateTime.now();
  Duration initialTimer = new Duration();
  DateTime finalDate = DateTime.now();
  Duration finalTimer = new Duration();
  String dropdownValue = "EUR";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<MenuOption>(
            onSelected: (MenuOption result) => _menuOption(result),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuOption>>[
              const PopupMenuItem<MenuOption>(
                value: MenuOption.calculateTime,
                child: Text('Calculate total time'),
              ),
              const PopupMenuItem<MenuOption>(
                value: MenuOption.findTag,
                child: Text('Find by tag'),
              ),
            ],
          ),
          IconButton(icon: Icon(Icons.home),
              onPressed: () {
                while(Navigator.of(context).canPop()) {
                  //print("pop");
                  Navigator.of(context).pop();
                }
                PageActivities(0);}),
        ],
        title: const Text('Calculate Total'),

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
                  Expanded(
                    child: Text("Initial Date:"),
                  ),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () => _selectDate(context), // Refer step 3
                      child: Text(
                        "${initialDate.toLocal()}".split(' ')[0],
                        style:
                        TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(child: Text("Initial Time:")),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        showModalBottomSheet(
                        context: context,
                        builder: (BuildContext builder) {
                          return Container(
                              height: MediaQuery.of(context).copyWith().size.height / 3,
                              child: CupertinoTimerPicker(
                                mode: CupertinoTimerPickerMode.hms,
                                minuteInterval: 1,
                                secondInterval: 1,
                                initialTimerDuration: initialTimer,
                                onTimerDurationChanged: (Duration changedtimer) {
                                  setState(() {
                                    initialTimer = changedtimer;
                                  });
                                },
                              ));
                          });
                        },
                      child: Text(
                        "${initialTimer.toString().split('.').first.padLeft(8, "0")}",
                        style:
                        TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),


              Row(
                children: <Widget>[
                  Expanded(child: Text("Final Date:")),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () => _selectFinalDate(context), // Refer step 3
                      child: Text(
                        "${finalDate.toLocal()}".split(' ')[0],
                        style:
                        TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text("Final Time:"),
                  ),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext builder) {
                              return Container(
                                  height: MediaQuery.of(context).copyWith().size.height / 3,
                                  child: CupertinoTimerPicker(
                                    mode: CupertinoTimerPickerMode.hms,
                                    minuteInterval: 1,
                                    secondInterval: 1,
                                    initialTimerDuration: finalTimer,
                                    onTimerDurationChanged: (Duration changedtimer) {
                                      setState(() {
                                        finalTimer = changedtimer;
                                      });
                                    },
                                  ));
                            });
                      },
                      child: Text(
                        "${finalTimer.toString().split('.').first.padLeft(8, "0")}",
                        style:
                        TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              TextField(
                decoration: new InputDecoration(labelText: "Price per hour"),
                keyboardType: TextInputType.number,
              ),
              Row(
                children: <Widget>[
                  Expanded(child: Text("Choose a currency")),
                  Expanded(child:
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: Colors.lime,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: <String>['EUR', 'USD', 'GBP']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ]
              ),
              Center(
                child: RaisedButton(
                  child: Text("Calculate"),
                ),
              ),
              Divider(),
              Text("Total Price: "),
            ],
          ),
        ),
        ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: initialDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != initialDate)
      setState(() {
        initialDate = picked;
      });
  }

  _selectFinalDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: finalDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != finalDate)
      setState(() {
        finalDate = picked;
      });
  }

  void _menuOption(MenuOption result) {
    if(result == MenuOption.findTag) {

      // we can not do just _refresh() because then the up arrow doesnt appear in the appbar
      Navigator.of(context)
          .push(MaterialPageRoute<void>(
        builder: (context) => FindByTag(),
      ));
    } else {

      // we can not do just _refresh() because then the up arrow doesnt appear in the appbar
      Navigator.of(context)
          .push(MaterialPageRoute<void>(
        builder: (context) => CalculateTotalTime(),
      ));

    }
  }

}
