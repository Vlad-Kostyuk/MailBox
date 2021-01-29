import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailbox/model/User.dart';

class LoginService {


  authenticationState() {
    FirebaseAuth.instance.onAuthStateChanged.listen((event) {

      print(event);

      if (event == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }

    });
  }

  signIn(String email, String password) async {
    try {
      AuthResult authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
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
      AuthResult authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser != null) {

      User user = new User(id: firebaseUser.uid, email: firebaseUser.email, userName: firebaseUser.displayName, photoUrl: firebaseUser.photoUrl);
      return user;
    }
  }
}