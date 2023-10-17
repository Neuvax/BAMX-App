import 'package:bamx_app/src/components/bottom_navigation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  void onBottomTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BAMX'),
      ),
      body: const Center(child: Text('Home Page')),
      bottomNavigationBar: BottomNavigation(currentIndex: _currentIndex, onTap: onBottomTap)
    );
  }
}