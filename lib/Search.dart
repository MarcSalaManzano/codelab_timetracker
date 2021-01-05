import 'package:flutter/material.dart';

class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(icon: Icon(Icons.close), onPressed: () {
        query = "";
      })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
      Navigator.pop(context);
    });
  }
  String selectedResult;
  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(query),
      )
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
        child: Center(
          child: Text("Busca activitats a partir de un tag"),
        )
    );
  }
  
}