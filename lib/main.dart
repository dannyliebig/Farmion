import 'dart:convert';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:async';

final analytics = new FirebaseAnalytics();
final reference = FirebaseDatabase.instance.reference().child('messages');

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Farmion App',
      theme: new ThemeData(
        primaryColor: const Color.fromRGBO(158, 141, 123, 1.0),
      ),
      home: new MyHomePage(title: 'Farmion Dashbord'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body:
          new Column(
            children: <Widget>[
              new Flexible(
                child: new FirebaseAnimatedList(
                  query: reference,
                  sort: (a, b) => b.key.compareTo(a.key),
                  padding: new EdgeInsets.all(8.0),
                  reverse: false,
                  itemBuilder:
                      (_, DataSnapshot snapshot, Animation<double> animation) {
                    return new MyCard(snapshot: snapshot, animation: animation);
                  },
                ),
              ),
              new Divider(height: 1.0),
              new Container(
                decoration:
                    new BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
            ],
          ),

      backgroundColor: const Color.fromRGBO(193, 175, 158, 1.0),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      //new
      data: new IconThemeData(color: Theme.of(context).accentColor), //new
      child: new Container(
        //modified
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                  //modified
                  icon: new Icon(Icons.send),
                  onPressed: _isComposing
                      ? () => _handleSubmitted(_textController.text)
                      : null,
                )),
          ],
        ),
      ), //new
    );
  }

  Future<Null> _handleSubmitted(String text) async {
    _textController.clear();
    setState(() {
      _isComposing = false; //new
    });
    _sendMessage(text: text);
  }

  void _sendMessage({String text}) {
    reference.push().set({
      //new
      'text': text, //new
      'senderName': "Dein Name",
      'senderLocation': "Dein Ort",
    }); //new
    analytics.logEvent(name: 'send_message');
  }
}

class MyCard extends StatelessWidget {
  MyCard({this.snapshot, this.animation}); // modified
  final DataSnapshot snapshot; // modified
  final Animation animation;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
        //new
        sizeFactor: new CurvedAnimation(
            //new
            parent: animation,
            curve: Curves.easeOut),
        axisAlignment: 0.0, //new
        child: buildCard(snapshot.value['senderName'],
            snapshot.value['senderLocation'], snapshot.value['text'], 3));
  }

  Widget buildCard(String name, String ort, String text, int comments) {
    return new Card(
        color: const Color.fromRGBO(138, 121, 103, 1.0),
        child: new Column(
          children: <Widget>[
            new Container(
              padding: new EdgeInsets.all(5.0),
              child: new Row(
                children: <Widget>[
                  new Icon(Icons.face),
                  new Text(name),
                  new Icon(Icons.location_on),
                  new Text(ort),
                ],
              ),
            ),
            new Stack(
              children: <Widget>[
                new Container(
                  margin: new EdgeInsets.all(10.0),
                  child: new Text(
                    text,
                    softWrap: true,
                  ),
                ),
                new Container(
                  alignment: new Alignment(1.0, 0.0),
                  child: new Column(
                    children: <Widget>[
                      new Icon(Icons.arrow_upward),
                      new Text("$comments"),
                      new Icon(Icons.arrow_downward)
                    ],
                  ),
                )
              ],
            ),
            new Icon(Icons.menu)
          ],
        ));
  }
}
