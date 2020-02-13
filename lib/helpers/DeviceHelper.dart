import 'dart:async';

import 'package:AnyDrop/helpers/SharedPrefManager.dart';
import 'package:flutter/cupertino.dart';

import '../DataTypes.dart';

class DeviceHelper{

  static Timer _scheduler;

  static Future<String> deviceName() async{
    await SharedPrefManager.init();
    return Future.value(SharedPrefManager.getString(SharedPrefManager.deviceNameKey) ??
        _setAndGetName().then((value) => value));
  }

  static Future<String> _setAndGetName() async{
    String deviceName = DeviceNames.deviceName;
    await SharedPrefManager.setString(SharedPrefManager.deviceNameKey, deviceName);
    return deviceName;
  }

  static void startSaveRoutineWith(String deviceName) {
    if(_scheduler != null && _scheduler.isActive){
      debugPrint("SaveRoutine Cancelled");
      _scheduler.cancel();
    }
    _scheduler = new Timer(Duration(milliseconds: 500),(){
      debugPrint("Starting SaveRoutine");
      SharedPrefManager.setString(SharedPrefManager.deviceNameKey, deviceName);
      debugPrint("SaveRoutine Complete");
    });
    debugPrint("New SaveRoutine Created");
  }
}