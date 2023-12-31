import 'package:bamx_app/src/pages/admin/layout_page.dart';
import 'package:bamx_app/src/pages/admin/verify_donation.dart';
import 'package:bamx_app/src/pages/cart_page.dart';
import 'package:bamx_app/src/pages/donation_confirmation_page.dart';
import 'package:bamx_app/src/pages/forgot_password.dart';
import 'package:bamx_app/src/pages/layout_page.dart';
import 'package:bamx_app/src/pages/news_page.dart';
import 'package:bamx_app/src/pages/privacy_policy_page.dart';
import 'package:bamx_app/src/pages/sign_in.dart';
import 'package:bamx_app/src/pages/sign_up.dart';
import 'package:bamx_app/src/pages/two_factor_page.dart';
import 'package:bamx_app/src/pages/donation_information_page.dart';
import 'package:bamx_app/src/pages/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:bamx_app/src/model/donation_group.dart';

class Routes {
  /// Route names
  static const String login = '/';
  static const String signUp = '/signUp';
  static const String forgotPassword = '/forgotPassword';
  static const String home = '/home';
  static const String cart = '/cart';
  static const String userProfile = '/userProfile';
  static const String donationConfirmation = '/donationConfirmation';
  static const String twoFactorAuth = '/twoFactorAuth';
  static const String donationInformationPage = '/donationInformationPage';
  static const String adminHome = '/adminHome';
  static const String verifyDonation = '/verifyDonation';
  static const String news = '/news';
  static const String privacyPolicy = '/privacyPolicy';

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
      case twoFactorAuth:
        return buildRoute(const TwoFactorAuthPage());
      case privacyPolicy:
        return buildRoute(const PrivacyPolicyPage());
      case donationInformationPage:
        final DonationGroup donationGroup = settings.arguments as DonationGroup;
        return buildRoute(
            DonationInformationPage(donationGroup: donationGroup));
      case news:
        return buildRoute(const NewsPage());
      case adminHome:
        return buildRoute(const AdminLayout());
      case verifyDonation:
        final args = settings.arguments as Map<String, dynamic>;
        final DonationGroup donationGroup =
            args['donationGroup'] as DonationGroup;
        final String userId = args['userId'] as String;
        return buildRoute(VerifyDonationPage(
          donationGroup: donationGroup,
          userId: userId,
        ));
      default:
        throw Exception('La ruta: ${settings.name} no existe');
    }
  }
}
