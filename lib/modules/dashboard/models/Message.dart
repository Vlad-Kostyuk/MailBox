import 'package:firebase_database/firebase_database.dart';
//added 30.01.2021 Serhii Senyk
class Message {
  String key;
  String text;
  String datetime;
  String username;

  Message(this.text, this.datetime, this.username);

  Message.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        text = snapshot.value["text"],
        datetime = snapshot.value["datetime"],
        username = snapshot.value["username"];
  //don`t works
  Map<String, dynamic> toJson() =>
    {
      'username': username,
      'datetime': datetime,
      'text' : text,
    };

}