import 'package:flutter/widgets.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

Future<String> getGallerys() async {
  String s;
  try {
    String ss = await postTest('https://api.flickr.com/services/rest/?method=flickr.photosets.getList&api_key=fdfdfce5ecd55bd546042d6607472870&user_id=111971134@N07', "");
    RegExp exp = new RegExp(r'id="(\d+)');
    List<Match> retrList= exp.allMatches(ss).toList();
    s = retrList.removeLast().group(1);

  } catch(e) {
    print("${e}");
  }
  return s;
}

Future<String> getTest(String uri) async {
  HttpClient client = new HttpClient();
  HttpClientRequest request = await client.getUrl(Uri.parse(uri));
  HttpClientResponse response = await request.close();
  StringBuffer builder = new StringBuffer();
  await for (String a in await response.transform(UTF8.decoder)) {
    builder.write(a);
  }
  return builder.toString();
}

Future<String> postTest(String uri, String message) async {
  HttpClient client = new HttpClient();
  HttpClientRequest request = await client.postUrl(Uri.parse(uri));
  request.write(message);
  HttpClientResponse response = await request.close();
  StringBuffer builder = new StringBuffer();
  await for (String a in await response.transform(UTF8.decoder)) {
    builder.write(a);
  }
  return builder.toString();
}