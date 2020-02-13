import 'package:AnyDrop/DataTypes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManager{
  static String deviceNameKey = "devicename";
  static SharedPreferences _sharedPreferences;
  static Future<void> init() async{
    if(_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  static String getString(String key) => _sharedPreferences.getString(key);
  static Future<bool> setString(String key,String value) => _sharedPreferences.setString(key,value);
}