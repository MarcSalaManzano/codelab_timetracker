import 'package:flutter/material.dart';
import 'package:codelab_timetracker/requests.dart';
import 'package:codelab_timetracker/page_activities.dart';
import 'dart:async';

enum TypeActivity {Task, Project}

class PageNewActivity extends StatefulWidget {
  @override
  _PageNewActivityState createState() => _PageNewActivityState();

  int id;

  PageNewActivity(this.id);
}

class _PageNewActivityState extends State<PageNewActivity> {
  final _formKey = GlobalKey<FormState>();
  int id;
  TypeActivity typeActivity = TypeActivity.Task;
  final nameController = TextEditingController();
  final tagsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    id = widget.id; // of PageActivities
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear activitat'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Nom activitat:',
                ),
                controller: nameController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Si us plau, posa un nom';
                  }
                  return null;
                },
              ),
              ListTile(
                title: const Text('Task'),
                leading: Radio(
                  value: TypeActivity.Task,
                  groupValue: typeActivity,
                  onChanged: (TypeActivity value) {
                    setState(() {
                      typeActivity = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Project'),
                leading: Radio(
                  value: TypeActivity.Project,
                  groupValue: typeActivity,
                  onChanged: (TypeActivity value) {
                    setState(() {
                      typeActivity = value;
                    });
                  },
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Tags activitat:',
                ),
                controller: tagsController,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                    )
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState.validate()) {
                          if(typeActivity == TypeActivity.Task) {
                            createTask(id, nameController.text, tagsController.text);
                          } else {
                            createProject(id, nameController.text, tagsController.text);
                          } //TODO: Arreglar el tirar enrere i tornar a la pagina
                          Navigator.of(context)
                              .push(MaterialPageRoute<void>(
                            builder: (context) => PageActivities(id),
                          ));
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}
