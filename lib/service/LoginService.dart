import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailbox/model/User.dart';

import 'SharedPreference.dart';

class LoginService {

  authenticationState() {
    FirebaseAuth.instance.authStateChanges().listen((event) {

      print(event);
      if (event == null) {
        print('User is currently signed out!');
        return false;
      } else {
        print('User is signed in!');
        return true;
      }

    });
  }

  signIn(String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      print(userCredential);
      return true;
    } catch (error) {
      print(error.code);
      return error.code;
    }
  }

  registrationNewUser(String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
      );
      print(userCredential);
      return true;
    } catch (error) {
      print(error.code);
      return error.code;
    }
  }

  signingOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      final SharedPreference sharedPreference = new SharedPreference();
      sharedPreference.setBoolUserIsLogin(false);
      sharedPreference.setUserLogin('');
      sharedPreference.setUserPassword('');
      return true;
    } catch (error) {
      print(error.code);
      return error.code;
    }
  }

  Future<Users> getUser() async {
    if (FirebaseAuth.instance.currentUser != null) {
      final Users users = new Users(id: FirebaseAuth.instance.currentUser.uid, email: FirebaseAuth.instance.currentUser.email, userName: FirebaseAuth.instance.currentUser.displayName);
      return users;
    }
  }

  Future<bool> userDisconnect() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch(e, stacktrace) {
      print(e.toString());
      print(stacktrace.toString());
      return false;
    }
  }

  Future<bool> reauthenticatingUser() async {
    final SharedPreference sharedPreference = new SharedPreference();
    if(await sharedPreference.getBoolUserIsLogin()) {
      final String _email = await sharedPreference.getUserLogin();
      final String _password = await sharedPreference.getUserPassword();

      try {
        await FirebaseAuth.instance.currentUser.reauthenticateWithCredential(EmailAuthProvider.credential(email: _email, password: _password));
        return true;
      } catch(e, stacktrace) {
        print(e.toString());
        print(stacktrace.toString());
      }
    } else {
      return false;
    }
  }

}