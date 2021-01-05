
import 'package:codelab_timetracker/Search.dart';
import 'package:codelab_timetracker/page_activities.dart';
import 'package:flutter/material.dart';

class FindByTag extends StatefulWidget {
  @override
  _FindByTagState createState() => _FindByTagState();
}

class _FindByTagState extends State<FindByTag> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: Search());
                }
            ),
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
    );
  }
}
