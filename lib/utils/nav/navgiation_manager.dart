import 'package:flutter/material.dart';

class NavigationManager {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(Widget widget) {
    return navigatorKey.currentState
            ?.push(MaterialPageRoute(builder: (context) => widget)) ??
        Future.value(false);
  }

  void popTillFirst() {
    return navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  void goBack([dynamic value]) {
    return navigatorKey.currentState?.pop(value);
  }
}
