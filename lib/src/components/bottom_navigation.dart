import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  final int currentIndex;
  final void Function(int) onTap;
  const BottomNavigation({required this.currentIndex, required this.onTap,super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final _icons = [(Icons.home, "Principal"), (Icons.favorite_border, "Donaciones"), (Icons.history, "Historial"), (Icons.star_border, "Recompensas")];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: BottomNavigationBar(
        elevation: 0,
        currentIndex: widget.currentIndex,
        onTap: widget.onTap,
        unselectedItemColor: MyColors.accent,
        selectedItemColor: MyColors.primary,
        iconSize: 27.0,
        items: List.generate(_icons.length, (index) => 
          BottomNavigationBarItem(icon: Icon(_icons[index].$1), label: _icons[index].$2)
        ),
      ),
    );
  }
}