import 'package:dynamic_365_integration/helpers/application.dart';
import 'package:flutter/material.dart';

class DeviceInfo {
  static double width(double width) {
    return MediaQuery.of(ApplicationHelper().context).size.width / 100.0 * width;
  }

  static double height(double height) {
    return MediaQuery.of(ApplicationHelper().context).size.height / 100.0 * height;
  }
}
