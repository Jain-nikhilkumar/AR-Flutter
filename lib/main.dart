import 'package:flutter/material.dart';
import 'package:ar_flutter/spashscreen/splashwidget.dart';
import 'package:ar_flutter/ar/arscreen.dart'; // Import the AR screen

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AR Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpalshWidget(),
    );
  }
}
