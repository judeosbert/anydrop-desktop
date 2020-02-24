import 'dart:convert';

import 'package:AnyDrop/DataTypes.dart';
import 'package:AnyDrop/widgets/ReleaseValues.dart';
import 'package:http/http.dart' show get;
class ConnectionManager{
  //TestValues
//  var testResult = '{ "v": "1.0", "bn": 1, "force": false, "sv": "0.0.2", "sbn": 2, "sforce": true }';

  static final ConnectionManager _instance = ConnectionManager._internal();
  factory ConnectionManager() => _instance;
  String updateURL = "https://my-json-server.typicode.com/judeosbert/anydrop-server-update/info";
  ConnectionManager._internal();

  Future<UpdateResponse> isUpdateAvailable() async{
    UpdateResponse isUpdateAvailable = UpdateResponse();
    try{
    var result = await get(_instance.updateURL);
    Map<String,dynamic> updateValues = jsonDecode(result.body);
    isUpdateAvailable.isForceUpdate = updateValues['sforce'];
    isUpdateAvailable.isUpdateAvailable = _findIfUpdateAvailable(updateValues["sbn"]);
    isUpdateAvailable.currentVersionName = ReleaseValues.version;
    isUpdateAvailable.newVersionName = updateValues['sv'];
    }on Exception
    catch(e){
        print("Update Inside $e");
    }
    return Future.value(isUpdateAvailable);
  }

  bool _findIfUpdateAvailable(int newBuildNumber) =>
       newBuildNumber > ReleaseValues.buildNumber;


}