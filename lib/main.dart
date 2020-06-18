import 'package:flutter/material.dart';
import 'package:kamachiapp/Pages/root_page.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'Services/authentication.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) exit(1);
  };
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Kamachi App', home: new RootPage(auth: new Auth()));
  }
}
