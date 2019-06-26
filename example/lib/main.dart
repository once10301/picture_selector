import 'package:flutter/material.dart';
import 'package:picture_selector/picture_selector.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: RaisedButton(onPressed: select, child: new Text("Select")),
        ),
      ),
    );
  }

  select() async {
    var path = await PictureSelector.select();
    print(path);
  }
}
