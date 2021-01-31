import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {

  initializedSharedPreference() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setBool('userIsLogin', false);
    preference.setString('userLogin', '');
    preference.setString('userPassword', '');
    preference.setString('userName', '');
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
      return false;
    }
  }

  getUserLogin() async {
    try {
      SharedPreferences preference = await SharedPreferences.getInstance();
      return preference.getString('userLogin');
    } catch (error) {
      print(error);
      return false;
    }
  }

  getUserPassword() async {
    try {
      SharedPreferences preference = await SharedPreferences.getInstance();
      return preference.getString('userPassword');
    } catch (error) {
      print(error);
      return false;
    }
  }

  getUserName() async {
    try {
      SharedPreferences preference = await SharedPreferences.getInstance();
      return preference.getString('userName');
    } catch (error) {
      print(error);
      return false;
    }
  }

  setUserLogin(String userLogin) async {
    try {
      SharedPreferences preference = await SharedPreferences.getInstance();
      return preference.setString('userLogin', userLogin);
    } catch (error) {
      print(error);
      return error;
    }
  }

  setUserPassword(String userPassword) async {
    try {
      SharedPreferences preference = await SharedPreferences.getInstance();
      return preference.setString('userPassword', userPassword);
    } catch (error) {
      print(error);
      return error;
    }
  }

  setUserName(String userName) async {
    try {
      SharedPreferences preference = await SharedPreferences.getInstance();
      return preference.setString('userName', userName);
    } catch (error) {
      print(error);
      return error;
    }
  }


}