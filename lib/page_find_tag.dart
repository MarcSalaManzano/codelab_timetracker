
import 'package:codelab_timetracker/Search.dart';
import 'package:codelab_timetracker/page_activities.dart';
import 'package:codelab_timetracker/page_calculate_time.dart';
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
          title: const Text('Find by tag'),
        ),
    );
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
