import 'dart:io';

import 'package:flutter/material.dart';
import 'package:picture_selector/picture_selector.dart';
import 'package:picture_selector_example/picture_select_widget.dart';
import 'package:picture_selector_example/ui_adapter_config.dart';

void main() {
  InnerWidgetsFlutterBinding.ensureInitialized()
    ..attachRootWidget(MyApp())
    ..scheduleWarmUpFrame();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int max = 6;
  List<Media> list = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: list.length < max ? list.length + 1 : max,
          itemBuilder: (context, index) {
            if (list.length < max && index == list.length) {
              return Container(
                width: 84,
                height: 84,
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: PictureSelectWidget(
                        text: list.isEmpty ? '选择图片' : '${list.length} / 6',
                        onTap: () => selectPictures(),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container(
              width: 84,
              height: 84,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Image.file(File(list[index].path), width: 80, height: 80, fit: BoxFit.cover),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      child: Image.asset('assets/images/delete.png', width: 22, height: 22),
                      onTap: () {
                        setState(() {
                          list.removeAt(index);
                        });
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  selectPictures() {
    List<String> selectList = [];
    list.forEach((media) {
      selectList.add(media.path);
    });
    PictureSelector.select(max: max, selectList: selectList).then((value) {
      list.clear();
      setState(() {
        list.addAll(value);
      });
    });
  }
}
