import 'package:flutter/cupertino.dart';

class ApplicationHelper {
  static final ApplicationHelper _ApplicationHelper = ApplicationHelper._internal();
  factory ApplicationHelper() {
    return _ApplicationHelper;
  }
  ApplicationHelper._internal();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  get context => navigatorKey.currentContext;
}
