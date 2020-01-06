import 'dart:math';

import 'package:flutter/material.dart';
import 'package:AnyDrop/DataTypes.dart';
import 'package:timeago/timeago.dart' as timeago;

class LogScreen extends StatelessWidget {
  final List<Log> logs;
  LogScreen(this.logs);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Text("App Logs",
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context,int position){
                return ListTile(
                    title: Text(logs[position].log),
                    subtitle: Text(timeago.format(logs[position].time)),
                  );
              },
              itemCount: logs.length,
            ),
          )
        ],
      ),
    );
  }

}




