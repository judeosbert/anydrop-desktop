import 'dart:io';

import 'package:AnyDrop/DataTypes.dart';
import 'package:AnyDrop/helpers/CommandHelper.dart';
import 'package:AnyDrop/helpers/DeviceHelper.dart';
import 'package:AnyDrop/helpers/FileHelper.dart';
import 'package:AnyDrop/helpers/SharedPrefManager.dart';
import 'package:AnyDrop/widgets/UpdateButton.dart';
import 'package:flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:AnyDrop/helpers/Utils.dart';
class ConnectionParameterWidget extends StatefulWidget {
  ConnectionParameterWidget();

  @override
  _ConnectionParameterWidgetState createState() => _ConnectionParameterWidgetState();
}

class _ConnectionParameterWidgetState extends State<ConnectionParameterWidget> {
  bool _isDeviceName = false;
  String _deviceName;

  @override
  Widget build(BuildContext context) {
    DeviceHelper.deviceName().then((String ip){
      setState(() {
        _deviceName = ip;
        _isDeviceName = true;
      });

    });
    if(!_isDeviceName){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox.fromSize(
            size: Size.square(20),
            child: CircularProgressIndicator(
              strokeWidth: 1,
            )),
      );
    }
    return  Stack(
      children:<Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(left: 8),
            child: UpdateButton(),
          ),
        ),
        Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Device Name "),
            SizedBox(width: 8,),
            SizedBox.fromSize(
              size: Size(200, 40),
              child: Center(
                child: TextFormField(
                  onChanged: (value){
                    if(value.length == 0){
                      PersistentSnackbar.show(context, "Cannot be an empty text",type: SnackbarType.ERROR);
                      return "";
                    }
                    DeviceHelper.startSaveRoutineWith(value);
                    PersistentSnackbar.cancel();
                  return "";
                  },
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "Change device Name",
                  ),
                  initialValue: _deviceName,
                  keyboardType: TextInputType.number,
                ),
              ),
            )

          ],
        ),
      ),
        Container(
          margin: EdgeInsets.only(right: 8),
          child: Align(
            alignment: Alignment.centerRight,
            child: RaisedButton.icon(onPressed: (){
              CommandHelper.openFilesFolder().catchError((onError){
                doSnackbar(context,onError.toString(),type:SnackbarType.ERROR);
              });
            }, icon: Icon(Icons.open_in_browser), label: Text("Open Files Folder")),
          ),
        )
    ]
    );
  }


}
