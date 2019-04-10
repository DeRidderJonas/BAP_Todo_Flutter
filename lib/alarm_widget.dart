import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Alarm extends StatefulWidget {
  Alarm({Key key}) : super(key: key);

  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  String alarm = "";
  bool enabled = false;

  @override
  void initState() {
    loadAlarm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text("Alarm"),
          Row(
            children: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.alarm),
                label: Text(alarm),
                onPressed: selectTime,
                shape: Border.all(color: Colors.black),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text("On:"),
              Checkbox(
                value: enabled,
                onChanged: (bool newValue) async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool("alarmEnabled", newValue);
                  setState(() {
                    enabled = newValue;
                  });
                },
              )
            ],
          )
        ],
      ),
    );
  }

  loadAlarm() async {
    final prefs = await SharedPreferences.getInstance();
    String alarmString = prefs.getString("alarm");
    if (alarmString == null) {
      alarmString = "none";
    }
    bool enabledBool = prefs.getBool("alarmEnabled") ?? false;
    setState(() {
      alarm = alarmString;
      enabled = enabledBool;
    });
    return;
  }

  selectTime() async {
    TimeOfDay time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    String timeString = time.format(context);

    final prefs = await SharedPreferences.getInstance();
    prefs.setString("alarm", timeString);

    setState(() {
      alarm = timeString;
    });
  }
}
