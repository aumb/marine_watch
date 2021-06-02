import 'package:flutter/material.dart';

class CustomInformationParser extends RouteInformationParser<Uri> {
  @override
  Future<Uri> parseRouteInformation(RouteInformation routeInformation) async =>
      Uri.parse(routeInformation.location!);

  @override
  RouteInformation? restoreRouteInformation(Uri configuration) =>
      RouteInformation(location: Uri.decodeComponent(configuration.toString()));
}
