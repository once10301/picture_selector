 import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class PictureSelector {
  static const MethodChannel _channel =
      const MethodChannel('picture_selector');

  static Future<File> select() async {
    return await _channel.invokeMethod('select');
  }
}
