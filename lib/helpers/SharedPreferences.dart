import 'dart:convert';
import 'dart:io';

import 'package:AnyDrop/helpers/FileHelper.dart';

class SharedPreferences{
  static final SharedPreferences _instance = SharedPreferences._internal();
  Map<String,dynamic> _sharedPreferenceData = Map();
  static File _storageFile;
  static final String _fileName = ".info.json";

  factory SharedPreferences(){
    return _instance;
  }

  SharedPreferences._internal();

  Future<void> _loadData() async{
    await  _getStorageFile();
    String content = _storageFile.readAsStringSync();
    try {
      _sharedPreferenceData = jsonDecode(content);
    }catch(e){
      _sharedPreferenceData = Map();
    }
  }

  Future<void> _getStorageFile() async{
    _storageFile = await FileHelper.createAndOpenFile(_fileName);
  }

  void _updateDisk(){
    _storageFile.writeAsString(json.encode(_sharedPreferenceData));
  }

  void setString(String key,String value){
    _sharedPreferenceData[key] = value;
    _updateDisk();
  }

  Future<String> getString(String key,{String defaultValue=""}) async {
    if(_sharedPreferenceData.isEmpty){
      await _loadData();
    }
    if(_sharedPreferenceData.containsKey(key)){
      return Future.value(_sharedPreferenceData[key]);
    }
    else
      return Future.value(defaultValue);
  }
}