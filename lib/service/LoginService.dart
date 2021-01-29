import 'package:firebase_auth/firebase_auth.dart';

class LoginService {

  signIn(String email, String password) async {
    try {
      AuthResult authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      print(authResult);
      return true;
    } catch (error) {
      print(error);
      return error;
    }
  }

  registration(String email, String password) async {
    try {
      AuthResult authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      print(authResult);
      return true;
    } catch (error) {
      print(error);
      return error;
    }
  }

  signingOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (error) {
      print(error);
      return error;
    }
  }


}