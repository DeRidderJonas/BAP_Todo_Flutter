import 'package:flutter/material.dart';
import 'database_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class TaskDetail extends StatefulWidget {
  TaskDetail({Key key}) : super(key: key);

  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  Task task = new Task();
  final titleController = TextEditingController();
  final dropdownItems = <String>['None', 'Not important'].map((String value) {
    return new DropdownMenuItem<String>(
     value: value,
      child: Text(value),
    );
  }).toList();

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
            FlatButton.icon(
              icon: Icon(Icons.calendar_today),
              label: Text(task.deadline),
              onPressed: selectDate,
              shape: Border.all(color: Colors.black),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Text("Extra "),
            DropdownButton<String>(
              value: task.extra,
              items: dropdownItems,
              onChanged: (String newValue) {
                setState(() {
                  task.extra = newValue;
                });
              },
            )
          ],
        ),
        Row(
          children: <Widget>[
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

  selectDate() async {
    DateTime date = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2020));
    String dateString = DateFormat('dd/MM/yyyy').format(date);
    setState(() {
      task.deadline = dateString;
    });
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
