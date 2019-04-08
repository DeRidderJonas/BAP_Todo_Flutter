import 'package:flutter/material.dart';
import 'Task.dart';

class TaskDetail extends StatefulWidget {
  TaskDetail({Key key}) : super(key: key);

  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {

  Task task = new Task(-1, "placeholder", false);
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = task.title;

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
          FlatButton(
            child: Text("Save"),
            onPressed: () => {

            },
            shape: Border.all(color: Colors.black),
          )
        ],
      )
    );
  }

  @override
  void dispose(){
    titleController.dispose();
    super.dispose();
  }

}
