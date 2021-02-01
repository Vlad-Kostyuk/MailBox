
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //InternetConnectivity internetConnectivity = new InternetConnectivity(context);

  var tmp = false;

  @override
  void initState() {
    super.initState();
   // internetConnectivity.initializedInternetConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Mail Box'),
          ),
          body: Container(
            child: StreamBuilder<ConnectivityResult>(
              //stream: internetConnectivity.counterUpdates,
              // ignore: missing_return
              builder: (context, snapshot) {
                if (snapshot != null && snapshot.hasData) {
                  print(snapshot.data.toString());
                  if(snapshot.data == ConnectivityResult.none || tmp) {
                    return Text('Connect...');
                  } else if(snapshot.data == ConnectivityResult.mobile) {
                    setState(() {
                      tmp == true ? tmp = false : tmp =  true;
                    });
                  }
                }

                return Container();
              },
            ),
          )
      ),
    );
  }
}