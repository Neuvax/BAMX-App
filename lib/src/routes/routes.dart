import 'package:flutter/material.dart';

class Routes {
  /// Route names
  static const String home = '/';
  static const String login = '/login';

  /// Route generator
  static Route routes(RouteSettings settings) {
    MaterialPageRoute buildRoute(Widget widget) {
      return MaterialPageRoute(builder: (_) => widget, settings: settings);
    }
    switch (settings.name) {
      case home:
        return buildRoute(const Placeholder());
      case login:
        return buildRoute(const Placeholder());
      default:
        return buildRoute(const Placeholder());
    }
  }
}