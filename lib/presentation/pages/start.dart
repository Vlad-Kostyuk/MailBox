import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mailbox/core/auth/firabase_auth.dart';
import 'package:mailbox/modules/dashboard/bloc/login/login_bloc.dart';
import 'package:mailbox/utils/services/connectivity_internet.dart';
import 'package:mailbox/utils/services/local_storage_serice.dart';

import 'login.dart';

class StartPage extends StatefulWidget {
  final SharedPreference sharedPreference = new SharedPreference();
  final FirebaseAuthService firebaseAuthService = new FirebaseAuthService();
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  @override
  void initState() {
    super.initState();
    InternetConnectivity internetConnectivity = new InternetConnectivity(context);
    internetConnectivity.initializedInternetConnectivity();
    Firebase.initializeApp().whenComplete(() {
      print("Completed");
      setState(() {});
      //widget.firebaseAuthService.authenticationState();
    });
    widget.sharedPreference.initializedSharedPreference();

  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [

        BlocProvider<BlocLogin>(
          create: (context) => BlocLogin(),
        ),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}