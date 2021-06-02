import 'package:flutter/material.dart';
import 'package:marine_watch/core/nav/nav.dart';

typedef CustomPageBuilder = Page Function(Uri uri, dynamic params);

class CustomNavigator extends RouterDelegate<Uri>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Uri> {
  CustomNavigator(
      {required Map<String, CustomPageBuilder> routes,
      CustomPageBuilder? notFoundPage}) {
    routeManager = CustomNavConfig(
      routes: routes,
      pageNotFound: notFoundPage,
    );
    routeManager.addListener(notifyListeners);

    // ignore: prefer_foreach
    for (final uri in [Uri(path: '/')]) {
      routeManager.push(uri);
    }
  }
  static CustomNavConfig of(BuildContext context) {
    return (Router.of(context).routerDelegate as CustomNavigator).routeManager;
  }

  @override
  final navigatorKey = GlobalKey<NavigatorState>();
  late CustomNavConfig routeManager;

  /// get the current route [Uri]
  /// this is show by the browser if your app run in the browser
  @override
  Uri? get currentConfiguration =>
      routeManager.uris.isNotEmpty ? routeManager.uris.last : null;

  /// add a new [Uri] and the corresponding [Page] on top of the navigator
  @override
  Future<void> setNewRoutePath(Uri uri) => routeManager.push(uri);

  /// Build method to set [Navigator] widget
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        for (final page in routeManager.pages) page,
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        if (routeManager.routes.isNotEmpty) {
          routeManager.removeLastUri();
          return true;
        }
        return false;
      },
      observers: [HeroController()],
    );
  }
}
