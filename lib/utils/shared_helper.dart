import 'package:shared_preferences/shared_preferences.dart';

class SharedHelper {

  static final String _isLogin = "is_login";
  static final String _id = "_id";
  
  Future<bool> getIsLogin() async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
  	return prefs.getBool(_isLogin) ?? false;
  }

  void setIsLogin(bool value) async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(value);
	  prefs.setBool(_isLogin, value);
  }

  Future<String> getID() async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
  	return prefs.getString(_id) ?? false;
  }

  void setID(String value) async {
	  final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(value);
	  prefs.setString(_isLogin, value);
  }
}

