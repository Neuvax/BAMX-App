import 'package:bamx_app/src/components/app_bar.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Text('Cart Page'),
      ),
    );
  }
}