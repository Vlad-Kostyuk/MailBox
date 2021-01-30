import 'package:flutter/material.dart';

void showAlertDialog(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Not found internet connection..'),
          content: Container(
              width: 50,
              child: Column(
                children: [
                  Icon(Icons.wifi),
              ],
              )
          ),
          actions: <Widget>[
            SizedBox(
              width: 15,
            ),

            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                // goTo(HomePage());
              },
            )
          ],
        );
      }
  );
}