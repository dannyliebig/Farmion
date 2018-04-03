import 'package:farmion/Dashbord.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';



void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Farmion App',
      theme: new ThemeData(
        primaryColor: const Color.fromRGBO(158, 141, 123, 1.0),
      ),
      home: new Dashbord(title: 'Farmion Dashbord'),
    );
  }
}