import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailbox/modules/dashboard/models/User.dart';
import 'package:mailbox/utils/services/local_storage_serice.dart';

class FirebaseAuthService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  authenticationState() {
    _firebaseAuth.authStateChanges().listen((event) {
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
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
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
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
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
      await _firebaseAuth.signOut();
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
    if (_firebaseAuth.currentUser != null) {
      final Users users = new Users(id: _firebaseAuth.currentUser.uid, email: _firebaseAuth.currentUser.email, userName: _firebaseAuth.currentUser.displayName);
      return users;
    }
  }

  Future<bool> userDisconnect() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch(e, stacktrace) {
      print(e.toString());
      print(stacktrace.toString());
      return false;
    }
  }



  Future<bool> reauthenticatingUser() async {
    final SharedPreference sharedPreference = new SharedPreference();
    bool tmp = await sharedPreference.getBoolUserIsLogin();
    if(tmp) {
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