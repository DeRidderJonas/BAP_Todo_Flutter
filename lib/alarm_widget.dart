import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Alarm extends StatefulWidget {
  Alarm({Key key}) : super(key: key);

  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  String alarm = "";
  bool enabled = false;
  String timeString = "";

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
          ),
          RaisedButton(
            child: Text("Get location"),
            onPressed: () async{
              var location = new Location();
              try {
                LocationData l = await location.getLocation();
                String url = "https://api.timezonedb.com/v2.1/get-time-zone?key=BNC3MFRJAMK4&format=json&fields=abbreviation,formatted&by=position&lat=${l.latitude}&lng=${l.longitude}";
                final response = await http.get(url);
                final jsonObject = jsonDecode(response.body);
                setState(() {
                  timeString = "Timezone: ${jsonObject["abbreviation"]}, time: ${jsonObject["formatted"]}";
                });
              } catch (e){
                print(e);
              }
            },
          ),
          Text(timeString)
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
