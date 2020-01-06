import 'dart:io';

import 'package:AnyDrop/DataTypes.dart';
import 'package:AnyDrop/helpers/CommandHelper.dart';
import 'package:AnyDrop/helpers/FileHelper.dart';
import 'package:AnyDrop/widgets/UpdateButton.dart';
import 'package:flutter/material.dart';
import 'package:AnyDrop/helpers/Utils.dart';
class ConnectionParameterWidget extends StatefulWidget {
  final TextEditingController controller;
  ConnectionParameterWidget(this.controller);

  @override
  _ConnectionParameterWidgetState createState() => _ConnectionParameterWidgetState();
}

class _ConnectionParameterWidgetState extends State<ConnectionParameterWidget> {
  bool _isAddressReady = false;
  String _ip;


  Future<String> _findIp() async{
    for (var interface in await NetworkInterface.list()){
      return interface.addresses[0].address;
    }
    return "NO NETWORK DEVICES FOUND";
  }

  @override
  Widget build(BuildContext context) {
    _findIp().then((String ip){
      setState(() {
        _ip = ip;
        _isAddressReady = true;
      });

    });
    if(!_isAddressReady){
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
            Text("Server Address"),
            SizedBox(width: 8,),
            Text(_ip),
            SizedBox.fromSize(
              size: Size(90, 40),
              child: Center(
                child: TextFormField(
                  onChanged: (value){
                    RegExp exp = RegExp("^[0-9]{1,4}\$");
                    if(!exp.hasMatch(value)){
                      widget.controller.clear();
                    }
                  },
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "Port",
                  ),
                  controller: widget.controller,
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
