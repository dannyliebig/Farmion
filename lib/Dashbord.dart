import 'dart:convert';
import 'dart:io';
import 'package:farmion/GoogleConnection.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:async';



class Dashbord extends StatefulWidget {
  Dashbord({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<Dashbord> with TickerProviderStateMixin {
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.shifting;
  List<NavigationIconView> _navigationViews;

  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
        icon: const Icon(Icons.cloud),
        title: 'Dashbord',
        color: Colors.teal,
        vsync: this,
      ),
      new NavigationIconView(
        icon: const Icon(Icons.favorite),
        title: 'Favorites',
        color: Colors.indigo,
        vsync: this,
      ),
      new NavigationIconView(
        icon: const Icon(Icons.event_available),
        title: 'Termine',
        color: Colors.pink,
        vsync: this,
      )
    ];

    for (NavigationIconView view in _navigationViews)
      view.controller.addListener(_rebuild);

    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews)
      view.controller.dispose();
    super.dispose();
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (NavigationIconView view in _navigationViews)
      transitions.add(view.transition(_type, context));

    // We want to have the newly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return new Stack(children: transitions);
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = new BottomNavigationBar(
      items: _navigationViews
          .map((NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: _type,
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
        });
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),

      body:
      new Column(
        children: <Widget>[
          new Divider(height: 1.0),
          new Container(
            decoration:
            new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
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
      bottomNavigationBar: botNavBar,
      floatingActionButton: const FloatingActionButton(child: const Icon(Icons.edit),onPressed: null),
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
      _isComposing = false;
    });
    _sendMessage(text: text);
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

class NavigationIconView {
  NavigationIconView({
    Widget icon,
    String title,
    Color color,
    TickerProvider vsync,
  }) : _icon = icon,
        _color = color,
        _title = title,
        item = new BottomNavigationBarItem(
          icon: icon,
          title: new Text(title),
          backgroundColor: color,
        ),
        controller = new AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ) {
    _animation = new CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
  }

  final Widget _icon;
  final Color _color;
  final String _title;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  CurvedAnimation _animation;

  FadeTransition transition(BottomNavigationBarType type, BuildContext context) {
    Color iconColor;
    if (type == BottomNavigationBarType.shifting) {
      iconColor = _color;
    } else {
      final ThemeData themeData = Theme.of(context);
      iconColor = themeData.brightness == Brightness.light
          ? themeData.primaryColor
          : themeData.accentColor;
    }

    return new FadeTransition(
      opacity: _animation,
      child: new SlideTransition(
        position: new Tween<Offset>(
          begin: const Offset(0.0, 0.02), // Slightly down.
          end: Offset.zero,
        ).animate(_animation),
        child: new IconTheme(
          data: new IconThemeData(
            color: iconColor,
            size: 120.0,
          ),
          child: new Semantics(
            label: 'Placeholder for $_title tab',
            child: _icon,
          ),
        ),
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return new Container(
      margin: const EdgeInsets.all(4.0),
      width: iconTheme.size - 8.0,
      height: iconTheme.size - 8.0,
      color: iconTheme.color,
    );
  }
}