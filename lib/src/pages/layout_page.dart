import 'package:bamx_app/src/components/app_bar.dart';
import 'package:bamx_app/src/components/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'donations_page.dart';
import 'historial_page.dart';
import 'home_page.dart';
import 'rewards_page.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  final List<Widget> _pages = <Widget>[
    const HomePage(),
    const DonationsPage(),
    const HistorialPage(),
    const RewardsPage(),
  ];

  int _currentIndex = 0;
  void onBottomTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigation(currentIndex: _currentIndex, onTap: onBottomTap)
    );
  }
}