import 'package:flutter/material.dart';
import 'package:codelab_timetracker/tree.dart' as Tree hide getTree;
// to avoid collision with an Interval class in another library
import 'package:codelab_timetracker/requests.dart';
import 'package:codelab_timetracker/page_activities.dart';
import 'dart:async';
class PageIntervals extends StatefulWidget {
  int id;

  PageIntervals(this.id);
  @override
  _PageIntervalsState createState() => _PageIntervalsState();
}

class _PageIntervalsState extends State<PageIntervals> {

  int id;
  Future<Tree.Tree> futureTree;

  Timer _timer;
  static const int periodeRefresh = 6;

  @override
  void initState() {
    super.initState();
    id = widget.id;
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
    return FutureBuilder<Tree.Tree>(
      future: futureTree,
      // this makes the tree of children, when available, go into snapshot.data
      builder: (context, snapshot) {
        // anonymous function
        if (snapshot.hasData) {
          String startDate = snapshot.data.root.initialDate!=null ? snapshot.data.root.initialDate.toString().split('.')[0] : 'No començada';
          String endDate = snapshot.data.root.finalDate!=null ? snapshot.data.root.finalDate.toString().split('.')[0] : 'No començada';
          String strDuration = Duration(seconds: snapshot.data.root.duration).toString().split('.').first;
          int numChildren = snapshot.data.root.children.length;
          bool isActive = (snapshot.data.root as Tree.Task).active;
          return Scaffold(
            appBar: AppBar(
              title: Text(snapshot.data.root.name),
              actions: <Widget>[
                IconButton(icon: Icon(Icons.home),
                  onPressed: () {
                    while(Navigator.of(context).canPop()) {
                      //print("pop");
                      Navigator.of(context).pop();
                    }
                    PageActivities(0);})
              ],
            ),
            body: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[Text('Informació:', style: TextStyle(fontWeight: FontWeight.bold),),
                  Text('Start Date: ${startDate}'),
                  Text('End Date: ${endDate}'),
                  Text('Duration: ${strDuration}'),
                  Divider( thickness: 2.0,),
                  Text('Intervals:', style: TextStyle(fontWeight: FontWeight.bold),),
                  Expanded(
                    child: ListView.separated(
                      // it's like ListView.builder() but better because it includes a separator between items
                      padding: const EdgeInsets.all(16.0),
                      itemCount: numChildren,
                      itemBuilder: (BuildContext context, int index) =>
                          _buildRow(snapshot.data.root.children[index], index, (isActive && index == numChildren-1)),
                      separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                    ),
                  ),
              ]),
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

  Widget _buildRow(Tree.Interval interval, int index, bool isActive) {
    String strDuration = Duration(seconds: interval.duration).toString().split('.').first;
    String strInitialDate = interval.initialDate.toString().split('.')[0];
    // this removes the microseconds part
    String strFinalDate = interval.finalDate.toString().split('.')[0];
    Color textColor = isActive ? Colors.green : Colors.black;
    return ListTile(
      title: Text('From: ${strInitialDate} \nTo: ${strFinalDate} ', style: TextStyle(color: textColor),),
      subtitle: Text('Duration: $strDuration'),

    );
  }

  @override
  void dispose() {
    // "The framework calls this method when this State object will never build again"
    // therefore when going up
    _timer.cancel();
    super.dispose();
  }
}