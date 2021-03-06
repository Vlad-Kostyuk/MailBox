import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:mailbox/core/auth/firabase_auth.dart';
import 'package:mailbox/modules/dashboard/models/User.dart';
import 'package:mailbox/utils/services/local_storage_serice.dart';

/*class FirebaseDbServices {
  final DatabaseReference messageRef = FirebaseDatabase.instance.reference().child("messages");

  Future<bool> sendMessage(String text) async {
    final SharedPreference sharedPreference = new SharedPreference();
    //final FirebaseAuthService registrationScreen = new FirebaseAuthService();
    //final Users users = await registrationScreen.getUser();
    String username = await sharedPreference.getUserName();
    try {
      //if(users.userName.isNotEmpty) {
        messageRef.push().set({
          'username': username,
          'datetime': DateFormat('hh:mm').format(DateTime.now()).toString(),
          'text': text
        });

     // }
      return true;
    } catch(error) {
      print(error);
      return false;
    }
  }
}*/

import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:mailbox/core/auth/firabase_auth.dart';
import 'package:mailbox/modules/dashboard/models/User.dart';

class FirebaseDbServices {
  final DatabaseReference messageRef = FirebaseDatabase.instance.reference().child("messages");

  Future<bool> sendMessage(String text) async {
    final FirebaseAuthService registrationScreen = new FirebaseAuthService();
    final Users users = await registrationScreen.getUser();
    try {
      //if(users.userName.isNotEmpty) {
      String user = users.userName;
      if(users.userName.isEmpty) {
        user = "unregistered";
      }
        messageRef.push().set({
          'username': user,
          'datetime': DateFormat('hh:mm').format(DateTime.now()).toString(),
          'text': text
        });
      //}
      return true;
    } catch(error) {
      print(error);
      return false;
    }
  }
}