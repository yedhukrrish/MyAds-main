import 'package:myads_app/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManager {
  static final SharedPrefManager _prefManager = SharedPrefManager._internal();
  static const String token = "_Token";

  Future<String> getToken() async {
    return getString(Constants.token);
  }

  // Future<String> getPhoneNumber() async {
  //   return getString(Constants.MOBILE_NUMBER);
  // }

  Future<String> getString(String type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(type);
  }

  Future<bool> setString(String type, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(type, value);
  }

  SharedPrefManager._internal();

  static SharedPrefManager get instance => _prefManager;

  Future clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
