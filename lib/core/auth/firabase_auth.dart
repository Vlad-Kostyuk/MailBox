import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailbox/modules/dashboard/models/User.dart';
import 'package:mailbox/utils/services/local_storage_serice.dart';

class FirebaseAuthService {
  final SharedPreference sharedPreference = new SharedPreference();
  authenticationState() {
    FirebaseAuth.instance.authStateChanges().listen((event) {
      print(event);
      if (event == null) {
        return false;
      } else {
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
      return true;
    } catch (error) {
      print(error);
      return error;
    }
  }

  registrationNewUser(String email, String password, String username) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await _firebaseAuth.currentUser.updateProfile(displayName: username);
      await userCredential.user.reload();
      print(userCredential);
      return true;
    } catch (error) {
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
    bool tmp = await sharedPreference.getBoolUserIsLogin();
    if(tmp != null) {
      if(tmp) {
        final String _email = await sharedPreference.getUserLogin();
        final String _password = await sharedPreference.getUserPassword();
        try {
          await FirebaseAuth.instance.currentUser.reauthenticateWithCredential(EmailAuthProvider.credential(email: _email, password: _password));
          return true;
        } catch(e, stacktrace) {
          print(e.toString());
          print(stacktrace.toString());
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

}