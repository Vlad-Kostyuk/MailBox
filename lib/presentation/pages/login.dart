import 'package:animated_button/animated_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mailbox/core/auth/firabase_auth.dart';
import 'package:mailbox/modules/dashboard/bloc/login/login_bloc.dart';
import 'package:mailbox/modules/dashboard/bloc/login/login_event.dart';
import 'package:mailbox/modules/dashboard/bloc/login/login_state.dart';
import 'package:mailbox/presentation/pages/chat.dart';
import 'package:mailbox/presentation/pages/registration.dart';
import 'package:mailbox/utils/services/connectivity_internet.dart';
import 'package:mailbox/utils/services/local_storage_serice.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuthService loginService = new FirebaseAuthService();
  final SharedPreference sharedPreference = new SharedPreference();

  @override
  _LoginScreenState createState() => _LoginScreenState(email: '', password: '',
    errorEmail: '', errorPassword: '', rememberMe: false);
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  String errorEmail;
  String errorPassword;
  bool rememberMe;

  _LoginScreenState({
    this.email,
    this.password,
    this.errorEmail,
    this.errorPassword,
    this.rememberMe
  });

  @override
  initState() {
    super.initState();
    InternetConnectivity internetConnectivity = new InternetConnectivity(context);
    internetConnectivity.initializedInternetConnectivity();
    BlocProvider.of<BlocLogin>(context).add(LoginPageLoadedEvent());
    checkUserIsLoginNoeNull();
  }

  checkUserIsLoginNoeNull() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    print(preference.containsKey('userIsLogin'));
    if(!preference.containsKey('userIsLogin'))
      widget.sharedPreference.initializedSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme:  IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(236, 241, 247, 1),
      ),
      body: Container(
        child: BlocBuilder<BlocLogin, LoginState>(
          builder: (BuildContext context, state) {

            if(state is LoginPageLoadingState) {
               return Container(
                   color: Color.fromRGBO(236, 241, 247, 1),
                   child: Center(
                     child: new ListView(
                         shrinkWrap: true,
                         padding: const EdgeInsets.all(20.0),
                         children: [
                           Center(child: new Text('Loading..')),
                           Center(child: CircularProgressIndicator())
                         ]
                     ),
                   )
               );
            }

            if(state is LoginPageUserIsLoginState) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:
                    (context) => ChatScreen()), (Route<dynamic> route) => false);
              });
            }

            if(state is LoginPageUserLoadedState) {
              return Container(
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
                            SizedBox(height: 5.0),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Log In',
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
                                    Icons.account_box,
                                    size: 80,
                                    color: Colors.indigo[100],
                                  )
                                ]
                            ),

                            SizedBox(height: 10.0),

                            emailTextForm(),

                            this.errorEmail.isNotEmpty ? Text(this.errorEmail, style: TextStyle(color: Colors.red)) : Container(),

                            SizedBox(height: 20.0),

                            passwordTextForm(),

                            this.errorPassword.isNotEmpty ? Text(this.errorPassword, style: TextStyle(color: Colors.red)) : Container(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Theme(
                                        data: ThemeData(
                                            unselectedWidgetColor: Colors.white),
                                        child: Checkbox(
                                          value: this.rememberMe,
                                          checkColor: Colors.white,
                                          activeColor: Colors.indigo,
                                          onChanged: (value) {
                                            setState(() {
                                              this.rememberMe = value;
                                            });
                                          },
                                        ),
                                      ),
                                      Text(
                                        "Remember me",
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  child: FlatButton(
                                    onPressed: () => print("Forgot Password"),
                                    padding: EdgeInsets.only(right: 0.0),
                                    child: Text(
                                      'Forgot Password',
                                      style: TextStyle(
                                          color: Colors.grey[800]
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            buttonLogin(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Don\'t have an Account? ',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                FlatButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => RegistrationScreen()),
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Sign In',
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
                  )
              );
            }

            if(state is LoginPageErrorState) {
              return Container(
                color: Color.fromRGBO(236, 241, 247, 1),
                child: Center(
                  child: new ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(20.0),
                      children: [
                        Center(child: new Text('Loading..')),
                        Center(child: CircularProgressIndicator())
                      ]
                  ),
                )
              );
            }

            return Container();
          },
        ),
      )
    );
  }

  Widget buttonLogin() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 30,
      ),
      width: 400,
      height: 55,
      child: AnimatedButton(
        child: Text(
          'Login',
          style: TextStyle(color: Colors.white,
              fontSize: 24),
        ),
        onPressed: () async {
          validatedLogin(this.email, this.password);
        },
        duration: 100,
        height: 54,
        width: 220,
        shadowDegree: ShadowDegree.dark,
        color: Colors.indigo,
      ),
    );
  }

  Widget passwordTextForm() {
    return Container(
      height: 80.0,
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
        validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long'
            : null,
        obscureText: true,
        onChanged: (val) {
          setState(() => this.password = val.trim());
        },
      ),
    );
  }

  Widget emailTextForm() {
   return Container(
      height: 80.0,
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
        validator: (val) => val.isEmpty ? 'Enter an email' : null,
        onChanged: (val) {
          setState(() => this.email = val.trim());
        },
      ),
    );
  }

  validatedLogin(String email, String password) async {
    this.errorEmail = '';
    this.errorPassword = '';

    if(checkLoginIsNull(email, password)) {
      sendToHomePage(await widget.loginService.signIn(email.trim(), password.trim()));
    }
  }

  void sendToHomePage(var resultLoginService) {
    if(resultLoginService is bool && this.rememberMe) {
      saveUserEmailAndPassport();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ChatScreen()), (Route<dynamic> route) => false);
    }

    if(resultLoginService is bool) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ChatScreen()), (Route<dynamic> route) => false);
    } else {
      validatedErrorCode(resultLoginService);
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

  bool checkLoginIsNull(String email, String password) {
    if(password == null  && email == null) {
      setState(() {
        this.errorEmail = 'Please write your email!';
        this.errorPassword = 'Please write your password!';
      });
      return false;
    }

    if(password == null && email != null) {
      setState(() {
        this.errorEmail = '';
        this.errorPassword = 'Please write your password!';
      });
      return false;
    }

    if(email == null && password != null) {
      setState(() {
        this.errorEmail = 'Please write your email!';
        this.errorPassword = '';
      });
      return false;
    } else {
      return checkLoginIsNotEmpty(email, password);
    }
  }

  bool checkLoginIsNotEmpty(String email, String password) {
    if(password.isEmpty  && email.isEmpty) {
      setState(() {
        this.errorEmail = 'Please write your email!';
        this.errorPassword = 'Please write your password!';
      });
      return false;
    }

    if(password.isEmpty && email.isNotEmpty) {
      setState(() {
        this.errorEmail = '';
        this.errorPassword = 'Please write your password!';
      });
      return false;
    }

    if(email.isEmpty && password.isNotEmpty) {
      setState(() {
        this.errorEmail = 'Please write your email!';
        this.errorPassword = '';
      });
      return false;
    } else {
      return true;
    }
  }
}
