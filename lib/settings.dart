import 'package:flutter/material.dart';

enum Language {English, Castellano}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();

  Settings();
}

class _SettingsState extends State<Settings> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final tagsController = TextEditingController();
  Language language = Language.Castellano;
  List<String> countries = ['Alemania', 'España', 'Estados Unidos', 'Francia', 'Inglaterra'];
  String selectedCountry;
  List<String> dateFormats = ['DD/MM/YY', 'YY/MM/DD', 'Month D, Yr', 'M/D/YY'];
  String selectedDateFormat;
  List<String> timeFormats = ['hh:mm', 'hh:mm:ss', 'hh:mm:ss:s'];
  String selectedTimeFormat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('Idioma'),
                      ListTile(
                        title: const Text('Castellano'),
                        leading: Radio(
                          value: Language.Castellano,
                          groupValue: language,
                          onChanged: (Language value) {
                            setState(() {
                              language = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Inglés'),
                        leading: Radio(
                          value: Language.English,
                          groupValue: language,
                          onChanged: (Language value) {
                            setState(() {
                              language = value;
                            });
                          },
                        ),
                      ),
                      DropdownButton(
                        hint: Text('País'), // Not necessary for Option 1
                        value: selectedCountry,
                        onChanged: (newValue) {
                          setState(() {
                            selectedCountry = newValue;
                          });
                        },
                        items: countries.map((location) {
                          return DropdownMenuItem(
                            child: new Text(location),
                            value: location,
                          );
                        }).toList(),
                      ),
                      DropdownButton(
                        hint: Text('Formato de fecha'), // Not necessary for Option 1
                        value: selectedDateFormat,
                        onChanged: (newValue) {
                          setState(() {
                            selectedDateFormat = newValue;
                          });
                        },
                        items: dateFormats.map((location) {
                          return DropdownMenuItem(
                            child: new Text(location),
                            value: location,
                          );
                        }).toList(),
                      ),
                      DropdownButton(
                        hint: Text('Formato de tiempo'), // Not necessary for Option 1
                        value: selectedTimeFormat,
                        onChanged: (newValue) {
                          setState(() {
                            selectedTimeFormat = newValue;
                          });
                        },
                        items: timeFormats.map((location) {
                          return DropdownMenuItem(
                            child: new Text(location),
                            value: location,
                          );
                        }).toList(),
                      ),
                    ]
                ),
            )
        )
    );
  }
}