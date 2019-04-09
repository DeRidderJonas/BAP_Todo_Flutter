import 'package:flutter/material.dart';
import 'database_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskDetail extends StatefulWidget {
  TaskDetail({Key key}) : super(key: key);

  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  Task task = new Task();
  final titleController = TextEditingController();

  @override
  void initState() {
    readCurrentTask().then((result) {
      setState(() {
        task.id = result.id;
        task.title = result.title;
        task.done = result.done;
        task.deadline = result.deadline;
        task.extra = result.extra;
        titleController.text = task.title;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: <Widget>[
        Text("Title"),
        TextField(
          controller: titleController,
        ),
        Row(
          children: <Widget>[
            Text("Done"),
            Checkbox(
              value: task.done,
              onChanged: (bool newValue) {
                setState(() {
                  task.done = newValue;
                });
              },
            )
          ],
        ),
        Row(
          children: <Widget>[
            Text("Deadline "),
            Text(task.deadline),
          ],
        ),
        Row(
          children: <Widget>[
            Text("Extra "),
            Text(task.extra),
          ],
        ),
        RaisedButton(
          child: Text("Save"),
          onPressed: updateCurrentTask,
          shape: Border.all(color: Colors.black),
        ),
      ],
    ));
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  readCurrentTask() async {
    final prefs = await SharedPreferences.getInstance();
    int id = prefs.getInt("currentTaskId") ?? -1;
    DatabaseHelper helper = DatabaseHelper.instance;
    Task t = await helper.getById(id);
    if (t == null) {
      Task empty = new Task();
      empty.title = "";
      empty.done = false;
      return empty;
    } else {
      return t;
    }
  }

  updateCurrentTask() async {
    task.title = titleController.text;
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.update(task);
  }
}
