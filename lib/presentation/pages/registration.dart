import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_button/animated_button.dart';
import 'package:mailbox/core/auth/firabase_auth.dart';
import 'package:mailbox/utils/services/local_storage_serice.dart';
import 'chat.dart';
import 'login.dart';


class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({this.toggleView});
  final Function toggleView;
  final _formKey = GlobalKey<FormState>();
  final SharedPreference sharedPreference = new SharedPreference();

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String errorName = '';
  String errorEmail = '';
  String errorPassword = '';
  String email = '';
  String password = '';
  String userName = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Color.fromRGBO(236, 241, 247, 1),
        title: Text(
          'MailBox Registration',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme:  IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(236, 241, 247, 1),
      ),
      body: Container(
          color: Color.fromRGBO(236, 241, 247, 1),
          padding: EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 50.0,
          ),
          child: ListView(
            children: <Widget>[
              Form(
                key: widget._formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Sign In',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'OpenSans',
                              fontSize: 30.0,
                              height: 3,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.app_registration,
                            size: 80,
                            color: Colors.indigo[100],
                          )
                        ]),

                    SizedBox(height: 10.0),

                    Container(
                      height: 60.0,
                      child: TextFormField(
                        validator: (val) =>
                        val.isEmpty ? 'First Name' : null,
                        onChanged: (val) {
                          setState(() => userName = val);
                        },
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: const InputDecoration(
                            labelText: 'First Name',
                            labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    this.errorName.isNotEmpty ? Text(this.errorName, style: TextStyle(color: Colors.red)) : Container(),

                    SizedBox(height: 10.0),
                    Container(
                      height: 60.0,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),

                        validator: (val) =>
                        val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                    ),

                    this.errorEmail.isNotEmpty ? Text(this.errorEmail, style: TextStyle(color: Colors.red)) : Container(),

                    SizedBox(height: 10.0),
                    Container(
                      height: 60.0,
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        validator: (val) => val.length < 6
                            ? 'Enter a password 6+ chars long'
                            : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                    ),

                    this.errorPassword.isNotEmpty ? Text(this.errorPassword, style: TextStyle(color: Colors.red)) : Container(),

                    SizedBox(height: 15.0),
                    Container(

                      margin: EdgeInsets.symmetric(
                        vertical:10,
                        horizontal: 30,
                      ),
                      width: 410,
                      height: 55,
                      child: AnimatedButton(

                        child: Text(
                          'Create Account',
                          style: TextStyle(color: Colors.white,
                              fontSize: 24),
                        ),

                        onPressed: () {
                          validatedLogin(email, password, userName);
                        },
                          duration: 100,
                          height: 54,
                          width: 220,
                          shadowDegree: ShadowDegree.dark,
                          color: Colors.indigo,
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Already Register? ',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        FlatButton(
                          onPressed: () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                                (Route<dynamic> route) => false,
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Login',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );

  }

  validatedLogin(String email, String password, String userName) async {
    this.errorName = '';
    this.errorEmail = '';
    this.errorPassword = '';

    if(checkLoginIsNull(email, password, userName)) {
      final FirebaseAuthService loginService = new FirebaseAuthService();
      loginService.registrationNewUser(email.trim(), password.trim(), userName.trim());
      saveUserEmailAndPassport();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ChatScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }

  void saveUserEmailAndPassport() {
    widget.sharedPreference.setBoolUserIsLogin(true);
    widget.sharedPreference.setUserLogin(email);
    widget.sharedPreference.setUserPassword(password);
  }

  void validatedErrorCode(var resultLoginService) {
    switch (resultLoginService) {
      case "ERROR_INVALID_EMAIL":
        setState(() {
          this.errorEmail = "Your email address appears to be malformed.";
        });
        break;
      case "ERROR_WRONG_PASSWORD":
        setState(() {
          this.errorPassword = "Your password is wrong.";
        });
        break;
      case "ERROR_USER_NOT_FOUND":
        setState(() {
          this.errorEmail = "User with this email doesn't exist.";
        });
        break;
      case "ERROR_USER_DISABLED":
        setState(() {
          this.errorEmail = "User with this email has been disabled.";
        });
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        setState(() {
          this.errorEmail = "Too many requests. Try again later.";
        });
        break;
      default:
        setState(() {
          this.errorEmail = "An undefined Error happened.";
        });
    }
  }

  bool checkLoginIsNull(String email, String password, String userName) {
    if(userName == null) {
      setState(() {
        this.errorName = 'Pls write you Name!';
      });
    }

    if(email == null) {
      setState(() {
        this.errorEmail = 'Pls write you email!';
      });
    }

    if(password == null) {
      setState(() {
        this.errorPassword = 'Pls write you password!';
      });
    }

    if(password == null || email == null || userName == null) {
      return false;
    } else {
      return checkLoginIsNotEmpty(email, password);
    }
  }

  bool checkLoginIsNotEmpty(String email, String password) {
    if(userName.isEmpty) {
      setState(() {
        this.errorName = 'Pls write you Name!';
      });
    }

    if(email.isEmpty) {
      setState(() {
        this.errorEmail = 'Pls write you email!';
      });
    }

    if(password.isEmpty) {
      setState(() {
        this.errorPassword = 'Pls write you password!';
      });
    }

    if(password.isEmpty || email.isEmpty || userName.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}


