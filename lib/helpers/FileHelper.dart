import 'dart:io';

import 'package:AnyDrop/helpers/Utils.dart';
import 'package:angel_framework/angel_framework.dart';

class FileHelper {
  static String saveDirectory = Utils.join([_homeDirectory,"AnyDrop"]);
  
  static Future<DiskSave> saveFile(UploadedFile uploadedFile) async{
    DiskSave diskSave = DiskSave();
    diskSave.isSuccess = true;
    try {
      var fileName = uploadedFile.filename;
      File file = File("$saveDirectory$fileName");
      file.createSync(recursive: true);
      await uploadedFile.data.pipe(file.openWrite());
      diskSave.file = file;
      diskSave.isSuccess = true;
    } on Exception
     catch (e) {
      print(e.toString());
      diskSave.file = null;
      diskSave.isSuccess = false;
      diskSave.e = e;
    }
    return Future.value(diskSave);
  }

  static Future<bool> deleteFile(File file) async{
    var result = await file.delete();
    return result.exists();
  }

  static String get _homeDirectory {
    Map<String, String> envVars = Platform.environment;
    if (Platform.isMacOS) {
      return envVars['HOME'];
    } else if (Platform.isLinux) {
      return envVars['HOME'];
    } else if (Platform.isWindows) {
      return envVars['UserProfile'];
    }
    throw Exception("Platform not yet supported");
  }
}

class DiskSave{
  File file;
  bool isSuccess;
  DiskSave({this.file,this.isSuccess});
  Exception e;

  @override
  String toString() {
    return "File:${file.toString()},isSuccess:$isSuccess,Exception ${e.toString()}";
  }


}
