import 'package:bamx_app/src/pages/cart_page.dart';
import 'package:bamx_app/src/pages/layout_page.dart';
import 'package:bamx_app/src/pages/sign_in.dart';
import 'package:flutter/material.dart';

class Routes {
  /// Route names
  static const String login = '/';
  static const String home = '/home';
  static const String cart = '/cart';

  /// Route generator
  static Route routes(RouteSettings settings) {
    MaterialPageRoute buildRoute(Widget widget) {
      return MaterialPageRoute(builder: (_) => widget, settings: settings);
    }
    switch (settings.name) {
      case home:
        return buildRoute(const LayoutPage());
      case login:
        return buildRoute(const SignInPage());
      case cart:
        return buildRoute(const CartPage());
      default:
        throw Exception('La ruta: ${settings.name} no existe');
    }
  }
}