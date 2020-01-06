import 'package:flutter/material.dart';

class ConnectionStatusBar extends StatelessWidget {
  final bool isServerRunning;
  ConnectionStatusBar(this.isServerRunning);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: isServerRunning?Colors.green:Colors.red,
      child: Padding(
        padding: EdgeInsets.only(left: 16,top: 8,bottom: 8),
        child: Text(getStatus(),
        style: TextStyle(color: Colors.white),),
      ),
    );
  }

  String getStatus(){
    if(isServerRunning){
      return "Server running";
    }else{
      return "Server is not running";
    }
  }
}


