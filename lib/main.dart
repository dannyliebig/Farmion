import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

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
  var _ipAddress = 'Unknown';

  _getIPAddress() async {
    var url = 'https://httpbin.org/ip';
    var httpClient = new HttpClient();

    String result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var jsonString = await response.transform(utf8.decoder).join();
        var data = json.decode(jsonString);
        result = data['origin'];
      } else {
        result =
        'Error getting IP address:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed getting IP address';
    }

    // If the widget was removed from the tree while the message was in flight,
    // we want to discard the reply rather than calling setState to update our
    // non-existent appearance.
    if (!mounted) return;

    setState(() {
      _ipAddress = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new ListView(
        children: <Widget>[
          new Image(
            image: new AssetImage('images/farmionLogo.jpg'),
          ),
          new Container(
            padding: new EdgeInsets.all(10.0),
            child: new Text(
                "Farmion hat ab jetzt eine App, diese kann nichts und muss gewartet werden und aktiv gehalten werden."),
          ),
          buildCard(
              "Marco Gabrecht", "Reinfeld", "Heute treffen beim Hünengrab?", 5),
          buildCard(
              "Marco Gabrecht",
              "Reinfeld",
              "Ich habe mal wieder lust auf DSA, hat jemand auch Lust? Ich wäre auch für D&D und SchadowRun zu haben, habt ihr eine Gruppe doer eher nicht?",
              5),
          buildCard("Marco Gabrecht", "Reinfeld",
              "Hallllo, dies ist ein Test wie geht es ich hoffe es klappt", 5),
          buildCard("Marco Gabrecht", "Reinfeld",
              "Hallllo, dies ist ein Test wie geht es ich hoffe es klappt", 5),
          new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text('Your current IP address is:'),
                new Text('$_ipAddress.'),
                new RaisedButton(
                  onPressed: _getIPAddress,
                  child: new Text('Get IP address'),
                ),
              ],
            ),
          ),],
      ),
      backgroundColor: const Color.fromRGBO(193, 175, 158, 1.0),
    );
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
