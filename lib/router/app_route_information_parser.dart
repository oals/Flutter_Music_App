import 'package:flutter/material.dart';

// 라우터 경로 설정
class RoutePath {
  final String? location;
  RoutePath({this.location});
}

class AppRouteInformationParser extends RouteInformationParser<RoutePath> {
  @override
  Future<RoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final location = routeInformation.location ?? '/';
    return RoutePath(location: location);
  }

  @override
  RouteInformation? restoreRouteInformation(RoutePath configuration) {
    return RouteInformation(location: configuration.location);
  }
}
