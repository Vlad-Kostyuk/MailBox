//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mailbox/modules/dashboard/models/Message.dart';
import 'package:mailbox/utils/services/connectivity_internet.dart';
import 'package:mailbox/utils/services/fiebase_db_services.dart';
import 'login.dart';
import 'package:mailbox/core/auth/firabase_auth.dart';
import 'package:mailbox/modules/dashboard/models/User.dart';

class ChatScreen extends StatefulWidget {
  final FirebaseDbServices firebaseDbServices = new FirebaseDbServices();
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final FirebaseAuthService registrationScreen = new FirebaseAuthService();

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  TextEditingController _textController = TextEditingController();
  bool _isWriting = false;
  Animation<double> _sendButtonAnimation;
  AnimationController _sendButtonAnimationController;
  DatabaseReference messageRef;
  Message message;
  Users users;
  ScrollController _controller = new ScrollController();


  @override
  void initState() {
    super.initState();
    initSendButtonAnimation();
    messageRef = widget.database.reference().child("messages");
    messageRef.onChildAdded.listen(_onEntry);
    getUser();
    widget.registrationScreen.authenticationState();
    _controller = ScrollController();

  }

  void getUser() async{
    users = await widget.registrationScreen.getUser();
  }

  _onEntry(Event event) {
    setState(() {
      _controller.animateTo(
          _controller.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration:  Duration(milliseconds: 500)
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _sendButtonAnimationController.dispose();
    super.dispose();
  }

  void initSendButtonAnimation(){
    InternetConnectivity internetConnectivity = new InternetConnectivity(context);
    internetConnectivity.initializedInternetConnectivity();
    this._sendButtonAnimationController = AnimationController(
        duration: const Duration(seconds:2), vsync: this
    )..repeat(reverse: true);
    this._sendButtonAnimation = Tween(begin: 0.9, end: 1.1).animate(
        CurvedAnimation(parent: _sendButtonAnimationController, curve: Curves.linear,)
    );
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        title:  Text("MailBox room",
          style: TextStyle(
            fontFamily: 'OpenSans',
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.logout),
            label: Text(''),
            onPressed: (){
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ],
        iconTheme:  IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(236, 241, 247, 1),
      ),
      body:  Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.indigo.withOpacity(0.1), BlendMode.dstATop),
            image: AssetImage("assets/icons/mailbox2.png"),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Column(children: [
          Flexible(
            child: FirebaseAnimatedList(
              controller: _controller,

              query: messageRef,
              // shrinkWrap: true,
              //reverse: true,

              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index){
                message = Message.fromSnapshot(snapshot);
                return Container(
                  margin:  EdgeInsets.all(10),
                  child:  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin:EdgeInsets.only(right: 20.0),//
                          child:
                          CircleAvatar(
                            child:  Text(message.username[0]),
                          )
                      ),
                      Flexible(
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(message.username + ','
                                + message.datetime,
                              //messages[index].username + ', '+
                              //   messages[index].datetime,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.indigo,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(top: 6.0),
                              padding: EdgeInsets.all(10.0),
                              child: Text(message.text,
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                              decoration:  BoxDecoration(
                                color: Colors.indigo.withOpacity(0.4),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5.0),
                                  topRight: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0),
                                  topLeft: Radius.circular(20.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Divider(height: 2.0),


          Container(
            decoration:  BoxDecoration(color: Theme.of(context).cardColor),
            child: _InputField(),

          ),
        ]),
      ),
      backgroundColor: Color.fromRGBO(236, 241, 247, 1),
    );
  }

  Widget _InputField() {
    return  IconTheme(
      data:  IconThemeData(color: Theme.of(context).accentColor),
      child:  Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        child:  Row(
          children: <Widget>[
            Flexible(
              child:  TextField(
                controller: _textController,
                decoration:
                InputDecoration.collapsed(hintText: "Write a message..."),
                onChanged: (String messageText) {
                  setState(() {
                    RegExp regExp = new RegExp(r"(\S+)");
                    _isWriting = regExp.hasMatch(messageText);
                  });
                },
                minLines : 1,
                maxLines : 100,
              ),
            ),
            ScaleTransition(
              scale: _sendButtonAnimation,
              child: Container(
                margin:  EdgeInsets.symmetric(horizontal: 3.0),
                child: IconButton(onPressed :
                _isWriting ? () => _submitMessage(_textController.text.trim()) : null,
                  icon: _isWriting? Icon(Icons.send):Icon(Icons.message_outlined),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _submitMessage(String text) async {
    final bool result = await widget.firebaseDbServices.sendMessage(text);
    if(result) {
      _textController.clear();
      setState(() {
        _isWriting = false;
      });
    }
  }
}


