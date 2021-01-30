import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailbox/model/User.dart';

import 'SharedPreference.dart';

class LoginService {

  authenticationState() {
    FirebaseAuth.instance.onAuthStateChanged.listen((event) {

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
      final AuthResult authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      print(authResult);
      return true;
    } catch (error) {
      print(error.code);
      return error.code;
    }
  }

  registrationNewUser(String email, String password) async {
    try {
      final AuthResult authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
      );
      print(authResult);
      return true;
    } catch (error) {
      print(error.code);
      return error.code;
    }
  }

  signingOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (error) {
      print(error.code);
      return error.code;
    }
  }

  Future<User> getUser() async {
    final FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser != null) {
      final User user = new User(id: firebaseUser.uid, email: firebaseUser.email, userName: firebaseUser.displayName);
      return user;
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
    //await userDisconnect();
    final SharedPreference sharedPreference = new SharedPreference();
    if(await sharedPreference.getBoolUserIsLogin()) {
      final String _email = await sharedPreference.getUserLogin();
      final String _password = await sharedPreference.getUserPassword();

      try {
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        AuthResult authResult = await user.reauthenticateWithCredential(
          EmailAuthProvider.getCredential(
            email: _email,
            password: _password,
          ),
        );
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