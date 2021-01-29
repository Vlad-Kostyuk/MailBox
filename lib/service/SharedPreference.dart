import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {

  initializedSharedPreference() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setBool('userIsLogin', false);
    preference.setString('userLogin', '');
    preference.setString('userPassword', '');
  }

  setBoolUserIsLogin(bool userIsLogin) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setBool('userIsLogin', userIsLogin);
  }

  getBoolUserIsLogin() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    return preference.getBool('userIsLogin');
  }



}