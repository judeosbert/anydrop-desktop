import 'package:AnyDrop/helpers/ConnectionManager.dart';
import 'package:AnyDrop/pages/UpdatePage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class UpdateButton extends StatefulWidget {
  @override
  _UpdateButtonState createState() => _UpdateButtonState();
}

class _UpdateButtonState extends State<UpdateButton> {
  bool _isUpdateAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  void _checkForUpdate() {
    ConnectionManager().isUpdateAvailable().then((updateResult) {
      if (updateResult.isUpdateAvailable) {
        if (updateResult.isForceUpdate) {
          Navigator.of(context)
              .pushReplacementNamed(UpdatePage.routeName, arguments: updateResult.newVersionName);
        } else {
          setState(() {
            _isUpdateAvailable = true;
          });
        }
      }
    }).catchError((onError) {
      print("Update Outside ${onError.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return _getButton();
  }

  Widget _getButton() {
    if (_isUpdateAvailable) {
      return FlatButton.icon(
        onPressed: () {
          launchUrl(ClickType.UPDATE);
        },
        icon: Icon(Icons.cloud_download),
        label: Text("Update Available"),
      );
    } else {
      return FlatButton.icon(
          onPressed: () {
            launchUrl(ClickType.DONATE);
          },
          icon: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
          label: Text("Donate"));
    }
  }

  Future<void> launchUrl(ClickType type) async{
    String urlToLaunch = "";
    switch(type){
      case ClickType.DONATE:
        urlToLaunch = "http://www.google.com";
        break;
      case ClickType.UPDATE:
        urlToLaunch = "http://www.github.com";
        break;
    }
    if( await canLaunch(urlToLaunch)){
      await launch(urlToLaunch);      
    }

  }
}

enum ClickType{
  DONATE,UPDATE
}