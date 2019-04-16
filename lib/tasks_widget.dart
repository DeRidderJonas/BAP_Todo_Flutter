import 'package:flutter/material.dart';
import 'database_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasksList extends StatefulWidget {
  TasksList({Key key}) : super(key: key);

  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  List<Task> tasks = [];

  @override
  void initState() {
    loadData().then((result){
      setState(() {
       tasks = result;
      });
    });
    super.initState();
  }

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
          ),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, position) {
              return Row(
                children: <Widget>[
                  Text("${tasks[position].title}   (${tasks[position].done ? 'DONE' : 'TODO'})"),
                  RaisedButton(
                    child: Text("Set Active"),
                    onPressed: () async{
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setInt("currentTaskId", tasks[position].id);
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              );
            },
            itemCount: tasks.length,
          )
        ],
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
  }

  loadData() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    return await helper.getAll();
  }
}
