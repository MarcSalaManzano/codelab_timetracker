import 'package:codelab_timetracker/page_calculate_time.dart';
import 'package:codelab_timetracker/page_find_tag.dart';
import 'package:flutter/material.dart';
import 'package:codelab_timetracker/PageIntervals.dart';
import 'package:codelab_timetracker/page_new_activity.dart';
import 'package:codelab_timetracker/tree.dart' hide getTree;
// the old getTree()
import 'package:codelab_timetracker/requests.dart';
import 'dart:async';
// has the new getTree() that sends an http request to the server
class PageActivities extends StatefulWidget {
  @override
  _PageActivitiesState createState() => _PageActivitiesState();

  int id;

  PageActivities(this.id);
}
enum MenuOption { findTag, calculateTime }
class _PageActivitiesState extends State<PageActivities> {
  int id;
  IconData iconData = Icons.play_arrow;
  Future<Tree> futureTree;
  Timer _timer;
  static const int periodeRefresh = 6;
  @override
  void initState() {
    super.initState();
    id = widget.id; // of PageActivities
    futureTree = getTree(id);
    _activateTimer();
  }

  void _activateTimer() {
    _timer = Timer.periodic(Duration(seconds: periodeRefresh), (Timer t) {
      futureTree = getTree(id);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<Tree>(
      future: futureTree,
      // this makes the tree of children, when available, go into snapshot.data
      builder: (context, snapshot) {
        // anonymous function

        if (snapshot.hasData) {
          String startDate = snapshot.data.root.initialDate!=null ? snapshot.data.root.initialDate.toString().split('.')[0] : 'Not started';
          String endDate = snapshot.data.root.finalDate!=null ? snapshot.data.root.finalDate.toString().split('.')[0] : 'Not started';
          String strDuration = Duration(seconds: snapshot.data.root.duration).toString().split('.').first;
          return Scaffold(
            appBar: AppBar(
              title: Text(snapshot.data.root.name),
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
                //TODO other actions
              ],
            ),
            body:
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Information:', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text('Start Date: ${startDate}'),
                      Text('End Date: ${endDate}'),
                      Text('Duration: ${strDuration}'),
                      Divider( thickness: 2.0,),
                      Text('Activities:', style: TextStyle(fontWeight: FontWeight.bold),),
                      Expanded(
                        child: ListView.separated(
                          // it's like ListView.builder() but better because it includes a separator between items
                          padding: const EdgeInsets.all(16.0),
                          itemCount: snapshot.data.root.children.length,
                          itemBuilder: (BuildContext context, int index) =>
                              _buildRow(snapshot.data.root.children[index], index),
                          separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                        ),
                      )
                    ],
                  ),
                ),

            floatingActionButton: FloatingActionButton(
              onPressed: () => _createActivity(snapshot.data.root.id),
              tooltip: 'Create Activity',
              child: const Icon(Icons.add),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a progress indicator
        return Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ));
      },
    );
  }

  Widget _buildRow(Activity activity, int index) {
    String strDuration = Duration(seconds: activity.duration).toString().split('.').first;
    // split by '.' and taking first element of resulting list removes the microseconds part
    if (activity is Project) {
      return ListTile(
        leading: Icon(Icons.folder_open),
        title: Text('${activity.name}'),
        subtitle: Text('$strDuration'),
        onTap: () => _navigateDownActivities(activity.id),
      );
    } else if (activity is Task) {
      Task task = activity as Task;
      // at the moment is the same, maybe changes in the future
      Widget trailing;
      if(task.active)
        trailing = new IconButton(icon: Icon(Icons.pause), onPressed: () {
          stop(activity.id);
          setState(() {
            task.active == false;
          });
          _refresh();
      }
        );
      else
        trailing = new IconButton(icon: Icon(Icons.play_arrow), onPressed: () {
          start(activity.id);
          setState(() {
            task.active == true;
          });
          _refresh();
        });

      return ListTile(
        leading: Icon(Icons.description_outlined),
        title: Text('${activity.name}'),
        subtitle: Text('${strDuration}'),
        onTap: () {_navigateDownIntervals(activity.id);},
        trailing: trailing
        );
    }
  }

  void _createActivity(int projectId) {
    _timer.cancel();
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => PageNewActivity(projectId),
    )).then( (var value) {
      _activateTimer();
      _refresh();
    });
  }

  void _menuOption(MenuOption result) {
    if(result == MenuOption.findTag) {
      _timer.cancel();
      // we can not do just _refresh() because then the up arrow doesnt appear in the appbar
      Navigator.of(context)
          .push(MaterialPageRoute<void>(
        builder: (context) => FindByTag(),
      )).then( (var value) {
        _activateTimer();
        _refresh();
      });
    } else {
      _timer.cancel();
      // we can not do just _refresh() because then the up arrow doesnt appear in the appbar
      Navigator.of(context)
          .push(MaterialPageRoute<void>(
        builder: (context) => CalculateTotalTime(),
      )).then( (var value) {
        _activateTimer();
        _refresh();
      });

    }
  }

  void _navigateDownActivities(int childId) {
    _timer.cancel();
    // we can not do just _refresh() because then the up arrow doesnt appear in the appbar
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => PageActivities(childId),
    )).then( (var value) {
      _activateTimer();
      _refresh();
    });
  }



  void _navigateDownIntervals(int childId) {
    _timer.cancel();
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => PageIntervals(childId),
    )).then( (var value) {
      _activateTimer();
      _refresh();
    });
    //https://stackoverflow.com/questions/49830553/how-to-go-back-and-refresh-the-previous-page-in-flutter?noredirect=1&lq=1
  }

  void _refresh() async {
    futureTree = getTree(id); // to be used in build()
    setState(() {});
  }

  @override
  void dispose() {
    // "The framework calls this method when this State object will never build again"
    // therefore when going up
    _timer.cancel();
    super.dispose();
  }
}