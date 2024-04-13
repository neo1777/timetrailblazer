import 'package:flutter/material.dart';

class NavigatorKey {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext? get currentContext => navigatorKey.currentContext;
}
