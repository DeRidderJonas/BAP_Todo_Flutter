import 'package:flutter/material.dart';

class Alarm extends StatefulWidget {
  Alarm({Key key}) :super(key: key);

  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Alarm"),
    );
  }

}
