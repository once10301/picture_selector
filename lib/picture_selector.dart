 import 'dart:async';

import 'package:flutter/services.dart';

class PictureSelector {
  static const MethodChannel _channel =
      const MethodChannel('picture_selector');

  static Future<String> select() async {
    return await _channel.invokeMethod('select');
  }
}
