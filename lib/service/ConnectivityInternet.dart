import 'dart:async';
import 'package:connectivity/connectivity.dart';

class InternetConnectivity {
  StreamController controller = new StreamController<ConnectivityResult>();

  Stream<ConnectivityResult> get counterUpdates => controller.stream;

  void initializedInternetConnectivity() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result){
      controller.add(result);
    });
  }
}