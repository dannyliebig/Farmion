import 'dart:convert';
import 'dart:io';
import 'package:farmion/CreateCards.dart';
import 'package:farmion/GoogleConnection.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:async';

class MenueDash extends StatefulWidget {
  MenueDash({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MenueDash> with TickerProviderStateMixin {

  TabController controler;

  @override
  void initState() {
    super.initState();
    controler = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    controler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        bottom: new TabBar(controller: controler
            ,tabs: <Tab>[
          new Tab(icon: new Icon(Icons.menu)),
          new Tab(icon: new Icon(Icons.face)),
          new Tab(
            icon: new Icon(Icons.menu),
          )
        ]),
      ),
      body: new TabBarView(
          controller: controler,
          children: <Widget>[
            new Dashbord(),
          new Center(child: new Text("Dein Bereich"),),
            new Center(child: new Text("Veranstaltungen"),),
            //new Dashbord(),
            //new Dashbord()
      ]),
      backgroundColor: const Color.fromRGBO(193, 175, 158, 1.0),
    );
  }
}


class Dashbord extends StatefulWidget {
  Dashbord({Key key, this.title}) : super(key: key);
  final String title;

  @override
  DashbordState createState() => new DashbordState();

}

class DashbordState extends State<Dashbord> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new Divider(height: 1.0),
          new Flexible(
            child: new FirebaseAnimatedList(
              query: GlobalGoogleStuff.reference,
              sort: (a, b) => b.key.compareTo(a.key),
              padding: new EdgeInsets.all(8.0),
              reverse: false,
              itemBuilder:
                  (_, DataSnapshot snapshot, Animation<double> animation) {
                return new MyCard(snapshot: snapshot, animation: animation);
              },
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(193, 175, 158, 1.0),
      //bottomNavigationBar: botNavBar,
      floatingActionButton: new FloatingActionButton(
          child: const Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new CreateCard()),
            );
          }),
    );
  }
}

class MyCard extends StatelessWidget {
  MyCard({this.snapshot, this.animation}); // modified
  final DataSnapshot snapshot; // modified
  final Animation animation;
  bool expand = false;

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
            snapshot.value['senderLocation'], snapshot.value['text'], "lala"));
  }

  Widget buildCard(String name, String ort, String text, String comments) {
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
            new GestureDetector(
                child: new Icon(Icons.menu),
                onTap: () {
                  expand = !expand;
                }),
            (expand ? new Text("Test: $expand") : new Text("Test: $expand")),
          ],
        ));
  }
}
