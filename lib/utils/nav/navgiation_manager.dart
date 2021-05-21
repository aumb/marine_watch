import 'package:flutter/material.dart';

class NavigationManager {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(Widget widget, {bool isFullScreenDialog = false}) {
    return navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => widget,
            fullscreenDialog: isFullScreenDialog,
          ),
        ) ??
        Future.value(false);
  }

  void popTillFirst() {
    return navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  Future<dynamic>? navgivateAndReplace(Widget widget) {
    return navigatorKey.currentState
        ?.pushReplacement(MaterialPageRoute(builder: (context) => widget));
  }

  void goBack([dynamic value]) {
    return navigatorKey.currentState?.pop(value);
  }
}
