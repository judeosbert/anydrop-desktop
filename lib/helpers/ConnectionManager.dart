import 'dart:convert';

import 'package:AnyDrop/DataTypes.dart';
import 'package:http/http.dart' show get;
import 'package:package_info/package_info.dart';
class ConnectionManager{
  static final ConnectionManager _instance = ConnectionManager._internal();
  factory ConnectionManager() => _instance;
  String updateURL = "https://my-json-server.typicode.com/judeosbert/anydrop-server-update/info";
  ConnectionManager._internal();

  Future<UpdateResponse> isUpdateAvailable() async{
    UpdateResponse isUpdateAvailable = UpdateResponse();
    try{
    var result = await get(_instance.updateURL);
    Map<String,dynamic> updateValues = jsonDecode(result.body);
    isUpdateAvailable.isForceUpdate = updateValues['force'];
    await _findIfUpdateAvailable(updateValues["bn"] as int,isUpdateAvailable);
    isUpdateAvailable.newVersionName = updateValues['v'];
    }on Exception
    catch(e){
        print(e);
    }
    return Future.value(isUpdateAvailable);
  }

  Future<void> _findIfUpdateAvailable(int newBuildNumber,UpdateResponse response) async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      int buildNumber = packageInfo.buildNumber as int;
      if(newBuildNumber > buildNumber){
        response.isUpdateAvailable = true;
        response.currentVersionName = packageInfo.version;
      }
    
  }


}