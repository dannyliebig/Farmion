import 'dart:convert';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:async';

class GlobalGoogleStuff {
  static final analytics = new FirebaseAnalytics();
  static final reference =
      FirebaseDatabase.instance.reference().child('messages');
}
