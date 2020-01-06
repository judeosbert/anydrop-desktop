import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:AnyDrop/DataTypes.dart';
class Utils{
  static Future<void> copyToClipboard(String data){
    return Clipboard.setData(ClipboardData(text: data));
}
}

void doSnackbar(BuildContext context,String message,{SnackbarType type = SnackbarType.INFO}){
    bool isTypeNotification() => type == SnackbarType.INFO;
    Flushbar(

      title: isTypeNotification()?"Heads up":"Oops",
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      margin: EdgeInsets.symmetric(horizontal: 10),
      leftBarIndicatorColor: isTypeNotification()?Colors.blue:Colors.red,
      icon: isTypeNotification()?Icon(Icons.info,
        color: Colors.blue,
      ):Icon(Icons.error,
        color: Colors.red,
      ),
      duration:Duration(seconds: 1),
    )..show(context);
  }
