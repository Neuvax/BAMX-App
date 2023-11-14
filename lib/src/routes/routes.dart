import 'package:bamx_app/src/pages/cart_page.dart';
import 'package:bamx_app/src/pages/donation_confirmation_page.dart';
import 'package:bamx_app/src/pages/forgot_password.dart';
import 'package:bamx_app/src/pages/layout_page.dart';
import 'package:bamx_app/src/pages/news_page.dart';
import 'package:bamx_app/src/pages/sign_in.dart';
import 'package:bamx_app/src/pages/sign_up.dart';
import 'package:bamx_app/src/pages/user_profile_page.dart';
import 'package:flutter/material.dart';

class Routes {
  /// Route names
  static const String login = '/';
  static const String signUp = '/signUp';
  static const String forgotPassword = '/forgotPassword';
  static const String home = '/home';
  static const String cart = '/cart';
  static const String userProfile = '/userProfile';
  static const String donationConfirmation = '/donationConfirmation';

  static const String news = '/news';

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
      case signUp:
        return buildRoute(const SignUpPage());
      case forgotPassword:
        return buildRoute(const ForgotPasswordPage());
      case cart:
        return buildRoute(const CartPage());
      case userProfile:
        return buildRoute(const UserProfilePage());
      case donationConfirmation:
        return buildRoute(const DonationConformationPage());

      
      case news:
        return buildRoute(const NewsPage());
      default:
        throw Exception('La ruta: ${settings.name} no existe');
    }
  }
}