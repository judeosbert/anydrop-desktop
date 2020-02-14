import 'SharedPreferences.dart';

class SharedPrefManager{
  static SharedPreferences _sharedPreferences;

  static String deviceNameKey = "devicename";

  static SharedPrefManager _instance = SharedPrefManager._internal();

  factory SharedPrefManager() => _instance;

  SharedPrefManager._internal(){
    _sharedPreferences = SharedPreferences();
  }
  Future<String> getString(String key,{String defaultValue}) => _sharedPreferences.getString(key,defaultValue: defaultValue);
  void setString(String key,String value) => _sharedPreferences.setString(key, value);
}