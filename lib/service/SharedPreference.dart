import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {

  initializedSharedPreference() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setBool('userIsLogin', false);
    preference.setString('userLogin', '');
    preference.setString('userPassword', '');
  }

  setBoolUserIsLogin(bool userIsLogin) async {
    try {
      SharedPreferences preference = await SharedPreferences.getInstance();
      preference.setBool('userIsLogin', userIsLogin);
      return true;
    } catch (error) {
      print(error);
      return error;
    }
  }

  getBoolUserIsLogin() async {
    try {
      SharedPreferences preference = await SharedPreferences.getInstance();
      return preference.getBool('userIsLogin');
    } catch (error) {
      print(error);
      return error;
    }
  }

  getUserLogin() async {
    try {
      SharedPreferences preference = await SharedPreferences.getInstance();
      return preference.getBool('userLogin');
    } catch (error) {
      print(error);
      return error;
    }
  }

  getUserPassword() async {
    try {
      SharedPreferences preference = await SharedPreferences.getInstance();
      return preference.getBool('userPassword');
    } catch (error) {
      print(error);
      return error;
    }
  }

  setUserLogin(String userLogin) async {
    try {
      SharedPreferences preference = await SharedPreferences.getInstance();
      return preference.getBool('userLogin');
    } catch (error) {
      print(error);
      return error;
    }
  }

  setUserPassword(String userPassword) async {
    try {
      SharedPreferences preference = await SharedPreferences.getInstance();
      return preference.getBool('userPassword');
    } catch (error) {
      print(error);
      return error;
    }
  }

}