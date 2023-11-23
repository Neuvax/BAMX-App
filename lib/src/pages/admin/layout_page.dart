import 'package:bamx_app/src/components/app_bar.dart';
import 'package:bamx_app/src/components/bottom_navigation.dart';
import 'package:bamx_app/src/pages/admin/qr_scanner_page.dart';
import 'package:bamx_app/src/pages/admin/update_items.dart';
import 'package:bamx_app/src/utils/upgrader_messages.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

class AdminLayout extends StatefulWidget {
  const AdminLayout({super.key});

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  final List<Widget> _pages = <Widget>[
    const UpdateItemsPage(),
    const QRScannerPage()
  ];

  final _icons = [
    (Icons.home, "Principal"),
    (Icons.qr_code_scanner, "Escanear")
  ];

  int _currentIndex = 0;
  void onBottomTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: Upgrader(
          debugDisplayOnce: true,
          messages: SpanishMessages(),
          showLater: false,
          showIgnore: false),
      child: Scaffold(
          appBar: const MyAppBar(),
          body: _pages[_currentIndex],
          bottomNavigationBar: BottomNavigation(
            currentIndex: _currentIndex,
            onTap: onBottomTap,
            icons: _icons,
          )),
    );
  }
}
