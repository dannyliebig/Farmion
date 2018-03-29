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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
          new Card(
              color: const Color.fromRGBO(138, 121, 103, 1.0),
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Icon(Icons.face),
                      new Text("Marco"),
                      new Icon(Icons.location_on),
                      new Text("Reinfeld"),
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Container(
                        child: new Text(
                          "Ich bin gerade am Hünengrab, kommt wer?",
                          softWrap: true,
                        ),
                      ),
                      new Column(
                        children: <Widget>[
                          new Icon(Icons.arrow_upward),
                          new Text("3"),
                          new Icon(Icons.arrow_downward)
                        ],
                      )
                    ],
                  ),
                  new Icon(Icons.menu)
                ],
              )),
          new Card(
              color: const Color.fromRGBO(138, 121, 103, 1.0),
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Icon(Icons.face),
                      new Text("Marco"),
                      new Icon(Icons.location_on),
                      new Text("Reinfeld"),
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Container(
                        child: new Text(
                          "Heuute wer Lust auf DSA?",
                          softWrap: true,
                        ),
                      ),
                      new Column(
                        children: <Widget>[
                          new Icon(Icons.arrow_upward),
                          new Text("3"),
                          new Icon(Icons.arrow_downward)
                        ],
                      )
                    ],
                  ),
                  new Icon(Icons.menu)
                ],
              )),
          new Card(
              color: const Color.fromRGBO(138, 121, 103, 1.0),
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Icon(Icons.face),
                      new Text("Marco"),
                      new Icon(Icons.location_on),
                      new Text("Reinfeld"),
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Container(
                        child: new Text(
                          "Lageraktion jede hilfe ist wilkommen?",
                          softWrap: true,
                        ),
                      ),
                      new Column(
                        children: <Widget>[
                          new Icon(Icons.arrow_upward),
                          new Text("3"),
                          new Icon(Icons.arrow_downward)
                        ],
                      )
                    ],
                  ),
                  new Icon(Icons.menu)
                ],
              )),
        ],
      ),
      backgroundColor: const Color.fromRGBO(193, 175, 158, 1.0),
    );
  }
}
