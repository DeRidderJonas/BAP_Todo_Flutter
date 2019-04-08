import 'package:flutter/material.dart';

class TasksList extends StatefulWidget {
  TasksList({Key key}) : super(key: key);

  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text("Tasks"),
          FlatButton(
            child: Text("Add new task"),
            onPressed: () => {

            },
            shape: Border.all(color: Colors.black),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

}
