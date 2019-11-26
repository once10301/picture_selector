import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PictureSelectWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  PictureSelectWidget({
    Key key,
    @required this.text,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 80,
        height: 80,
        child: DottedBorder(
          dashPattern: [4, 2],
          color: Color(0xFF999999),
          strokeWidth: 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 12),
              Image.asset('assets/images/camera.png', width: 24, height: 21),
              SizedBox(height: 10),
              Center(
                child: Text(text, style: TextStyle(color: Color(0xFF999999), fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
