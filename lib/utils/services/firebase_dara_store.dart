/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirebaseDataStoreProvider {
  writeMessage(DateTime date, String message, String userName) {
    try {
      FirebaseFirestore.instance.collection('chatRoom').add({'date': '${DateFormat('hh:mm').format(date)}',
        'message': '${message}', 'userName': '${userName}'});
    } catch (error) {
      print(error);
    }
  }
}*/