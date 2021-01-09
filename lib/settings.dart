import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();

  Settings();
}

class _SettingsState extends State<Settings> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final tagsController = TextEditingController();
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
                      ListTile(
                        title: const Text('Spanish'),
                      ),
                      ListTile(
                        title: const Text('English'),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Country:',
                        ),
                        controller: nameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please fill the form';
                          }
                          return null;
                        },
                      ),
                    ]
                )
            )
        )
    );
  }
}