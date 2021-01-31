import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailbox/modules/dashboard/models/User.dart';
import 'package:mailbox/utils/services/local_storage_serice.dart';

class LoginService {
  final SharedPreference sharedPreference = new SharedPreference();
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
      String userName = await userCredential.user.displayName;
      if(userName.isEmpty)
        userName = "userName";

      sharedPreference.setUserName(userName);
      print(userCredential);
      return true;
    } catch (error) {
      print(error.code);
      return error.code;
    }
  }

 //тут виправлено додано Profile
  registrationNewUser(String email, String password, String username) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    try {
      final userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user.updateProfile(displayName: username);
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