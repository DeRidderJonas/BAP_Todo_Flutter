import 'package:flutter/material.dart';
import 'database_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          RaisedButton(
            child: Text("Add new task"),
            onPressed: saveTask,
            shape: Border.all(color: Colors.black),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }


  saveTask() async{
    Task newTask = new Task();
    newTask.title = "something";
    newTask.done = false;
    newTask.deadline = "none";
    newTask.extra = "None";
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insert(newTask);
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("currentTaskId", id);
    print('inserted row: $id');
  }
}
