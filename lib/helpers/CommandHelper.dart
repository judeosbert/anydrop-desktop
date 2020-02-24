import 'dart:io';

import 'package:AnyDrop/helpers/FileHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:process_run/shell.dart';


class CommandHelper{
  static var _shell = Shell();
  static  String _openCommand({bool highlight = true}) {
    if (Platform.isMacOS) {
      return "open "+(highlight?"-R ":"");
    }
    else if (Platform.isLinux) {
      return "nautilus ";
    }
    else if (Platform.isWindows) {
      return "Explorer "+(highlight?"/select,":"");
    }
    return "";
  }
  static Future<void> openFileManager(String path, {bool highlight = true}) async {
    debugPrint("Path type ${FileSystemEntity.typeSync(path)}");
    if(FileSystemEntity.typeSync(path) == FileSystemEntityType.directory &&!Directory(path).existsSync()){
      Directory(path).createSync(recursive: true);
    }
    path = "\"$path\"";
    String openCommand = _openCommand(highlight: highlight);
    String completeCommand = "$openCommand$path";
    debugPrint("Executing Command $completeCommand");
    try {
      await _shell.run(completeCommand);
    } on Exception
    catch(e){
      return Future.error(e);
    }
  }
  static Future<void> openFilesFolder() async{
    return openFileManager(FileHelper.saveDirectory,highlight: false);
  }
}