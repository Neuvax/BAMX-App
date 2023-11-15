import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  final int currentIndex;
  final List<(IconData, String)> icons;
  final void Function(int) onTap;
  const BottomNavigation(
      {required this.currentIndex, required this.onTap, super.key, required this.icons});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
        top: BorderSide(
          color: MyColors.accent,
          width: 0.2,
        ),
      )),
      child: BottomNavigationBar(
        elevation: 0,
        currentIndex: widget.currentIndex,
        onTap: widget.onTap,
        unselectedItemColor: MyColors.accent,
        selectedItemColor: MyColors.primary,
        iconSize: 27.0,
        items: List.generate(
            widget.icons.length,
            (index) => BottomNavigationBarItem(
                icon: Icon(widget.icons[index].$1), label: widget.icons[index].$2)),
      ),
    );
  }
}
