import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class AppHive {
  static final AppHive _singleton = AppHive._internal();
  Box? dynamic365Token;
  bool isInitialized = false;

  factory AppHive() {
    return _singleton;
  }
  initialize() async {
    if (isInitialized) return;
    await Hive.initFlutter();
    dynamic365Token = await Hive.openBox("dynamic365Token");
  }

  String? get token => Platform.environment.containsKey('FLUTTER_TEST') ? "FLUTTER_TEST" : dynamic365Token?.get("token", defaultValue: null);
  void setToken(String _token) => dynamic365Token?.put("token", _token);

  AppHive._internal();
}
