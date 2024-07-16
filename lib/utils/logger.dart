import 'package:flutter/foundation.dart';

class Logger {
  static void printInDebug(Object? object) {
    if (kDebugMode) {
      print(object);
    }
  }
}
