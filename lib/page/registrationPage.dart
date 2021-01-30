import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_button/animated_button.dart';
import 'chat_page.dart';
import 'loginPage.dart';


class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({this.toggleView});
  final Function toggleView;
  final _formKey = GlobalKey<FormState>();

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String error = '';
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
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => ChatScreen()),
                                (Route<dynamic> route) => false,
                          );
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
}
