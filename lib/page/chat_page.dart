import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:mailbox/page/registrationPage.dart';

import 'loginPage.dart';



class ChatScreen extends StatefulWidget {
  final Function toggleView;
  ChatScreen({this.toggleView});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}


class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  TextEditingController _textController = TextEditingController();
  List<MyMessage> _messages = <MyMessage>[];
  bool _isWriting = false;

  Animation<double> _sendButtonAnimation;
  AnimationController _sendButtonAnimationController;


  String userName = "Serhii Senyk";

  @override
  void initState() {
    super.initState();
    initSendButtonAnimation();
  }

  @override
  void dispose() {
    _sendButtonAnimationController.dispose();
    for (MyMessage message in _messages) {
      message.sendMessageAnimationController.dispose();
    }
    super.dispose();
  }

  void initSendButtonAnimation(){
    this._sendButtonAnimationController = AnimationController(
        duration: const Duration(seconds:2),
        vsync: this
    )..repeat(reverse: true);
    this._sendButtonAnimation =
        Tween(begin: 0.9, end: 1.1).animate(
        CurvedAnimation(
          parent: _sendButtonAnimationController,
          curve: Curves.linear,
        ));
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
        backgroundColor: Color.fromRGBO(236, 241, 247, 1),//elevation: 6.0,
      ),
      body:  Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.indigo.withOpacity(0.1), BlendMode.dstATop),
            image: AssetImage("assets/icons/mailbox2.png"),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Column(children: <Widget>[
          Flexible(
              child:  ListView.builder(
                padding:  EdgeInsets.all(10.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              )),
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


  Widget _InputField() {//відповідає за поле відправки повідомлення
    return  IconTheme(
      data:  IconThemeData(color: Theme.of(context).accentColor),
      child:  Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0), //відступ тексту зліва
        child:  Row(
          children: <Widget>[
            Expanded(
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

            IconButton(
              onPressed :
              _isWriting ? () => _submitMessage(_textController.text.trim(), userName) : null,
              icon:  Icon(Icons.message_outlined),

            )

          ],
        ),
      ),
    );
  }

  void _submitMessage(String text, String userName) { //відповідає за відправку повідомлення
    _textController.clear();
    setState(() {
      _isWriting = false;
    });
    MyMessage message = MyMessage(
      text: text,
      userName: userName,
      sendMessageAnimationController: AnimationController(
          vsync: this,
          duration:  Duration(seconds: 2)
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.sendMessageAnimationController.forward();
  }
}

class MyMessage extends StatelessWidget {
  MyMessage({
    this.text,
    this.userName,
    this.sendMessageAnimationController
  });
  String text;
  String userName;
  AnimationController sendMessageAnimationController;
  String currentTime = DateTime.now().hour.toString() + ':' +
                       DateTime.now().minute.toString() ;//+ ':' +
                       //DateTime.now().second.toString();

  @override
  Widget build(BuildContext context) {
    return  SizeTransition(
      sizeFactor:
      CurvedAnimation(
          parent: sendMessageAnimationController, curve: Curves.elasticOut),
      axisAlignment: 0.0,
      child:  Container(
        margin:  EdgeInsets.all(10),
        child:  Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[

            Container(
              margin:  EdgeInsets.only(right: 20.0),//
              child:
                CircleAvatar(
                    child:  Text(userName[0]),
                )
            ),

            Flexible(
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    userName + ', ' + currentTime,
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
                    child: Text(text,
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                      ),),
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
      ),
    );
  }

}