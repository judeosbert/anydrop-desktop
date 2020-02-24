import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:AnyDrop/helpers/DeviceHelper.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

abstract class Transaction{
  TransactionType type;
  DateTime timestamp;
  Transaction({@required this.type}){
    refreshTimestamp();
  }

  void refreshTimestamp(){
    timestamp = DateTime.now();
  }
  String getTitle();
}

class StringTransaction extends Transaction{
  String value;
  StringTransaction({@required this.value}):super(type:TransactionType.STRING);

  @override
  String getTitle()=>value;
}

class FileTransaction extends Transaction{
  File file;
  FileTransaction({@required this.file}):super(type:TransactionType.FILE);

  @override
  String getTitle()=>basename(file.path);
}

enum TransactionType{
  STRING,FILE
}

enum SnackbarType{
  INFO,ERROR
}

class Log{
  String log;
  DateTime time = DateTime.now();
  Log(this.log);
}

class StringBody{
  String value;
  StringBody(this.value);

  Map<String,dynamic> toJson() =>{
    'value':value
  };

  factory StringBody.fromJson(Map<String,dynamic> json){
    return StringBody(json['value']);
  }
}

class UpdateResponse{
  bool isUpdateAvailable ,isForceUpdate;
  String currentVersionName,newVersionName;
}

class PingResponse{
  static Future<Map<String, dynamic>> toMap() async{
      var deviceName = await DeviceHelper.deviceName();
      return {
        "deviceName":deviceName,
        "deviceType":"laptop"
      };
  }
  static Future<String> toJson() async => json.encode(await toMap());
}
class DeviceNames{
  static final _deviceNames = [
    "Spiderman",
    "Thanos",
    "Deadpool",
    "Hulk",
    "Thor",
    "Wolverine",
    "Loki",
    "Groot",
    "Magneto",
    "Juggernaut",
    "Gamora",
    "Ronan"
  ];
  static String get deviceName => _deviceNames[Random().nextInt(_deviceNames.length)];
}
