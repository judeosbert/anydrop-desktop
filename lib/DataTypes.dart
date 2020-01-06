import 'dart:io';
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