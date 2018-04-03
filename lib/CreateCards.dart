import 'dart:async';

import 'package:farmion/GoogleConnection.dart';
import 'package:flutter/material.dart';

class CreateCard extends StatefulWidget {
  CreateCard({Key key}) : super(key: key);

  @override
  CreateCardStatus createState() => new CreateCardStatus();
}

class CreateCardStatus extends State<CreateCard> {
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: const Color.fromRGBO(193, 175, 158, 1.0),
        appBar: new AppBar(
          title: new Text('Beitrag erstellen'),
        ),
        body: _buildTextComposer());
  }

  Widget _buildTextComposer() {
    GlobalGoogleStuff.analytics.logEvent(name: 'OpenCreateCard');
    return new Container(
      child: new Column(
        children: <Widget>[
          new Image(
            image: new AssetImage('images/farmionLogo.jpg'),
          ),
          new Container(
            padding: new EdgeInsets.all(10.0),
            child: new Text(
                "Du kannst jetzt ein neuen Beitrag schrieben, der allen Mitgliedern ersichtlich ist und auf den andere Mitglieder antworten können.\n\nBeispiele sind z.B. einladungen zum gemeinsamen Basteln, Larpen oder Fragen."),
          ),
          new IconTheme(
            data: new IconThemeData(color: Colors.brown), //new
            child: new Container(
              decoration: new BoxDecoration(color: Colors.white),
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
                      decoration: new InputDecoration.collapsed(
                          hintText: "Send a message"),
                    ),
                  ),
                  new GestureDetector(
                    child: new Container(
                        margin: new EdgeInsets.symmetric(horizontal: 4.0),
                        child: new Row(
                          children: <Widget>[
                            new Text(
                              "Senden",
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown),
                            ),
                            new IconButton(
                              icon: new Icon(Icons.send),
                            )
                          ],
                        )),
                    onTap: _isComposing
                        ? () => _handleSubmitted(_textController.text)
                        : null,
                  ),
                ],
              ),
            ), //new
          ),
        ],
      ),
    );
  }

  Future<Null> _handleSubmitted(String text) async {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    _sendMessage(text: text);
    Navigator.pop(context);
  }

  void _sendMessage({String text}) {
    GlobalGoogleStuff.reference.push().set({
      //new
      'text': text, //new
      'senderName': "Dein Name",
      'senderLocation': "Dein Ort",
    }); //new
    GlobalGoogleStuff.analytics.logEvent(name: 'createCard');
  }
}
