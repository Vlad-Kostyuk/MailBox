import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:mailbox/widget/alert_dialog.dart';

class InternetConnectivity {
  BuildContext context;

  InternetConnectivity(this.context);

  StreamController controller = new StreamController<ConnectivityResult>();

  Stream<ConnectivityResult> get counterUpdates => controller.stream;

  void initializedInternetConnectivity() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result){
      controller.add(result);
      print(result);
      if(result == ConnectivityResult.none) {
        showAlertDialog(context);
      }
    });
  }
}