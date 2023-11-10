import 'package:bamx_app/src/routes/routes.dart';
import 'package:bamx_app/src/utils/colors.dart';
import 'package:bamx_app/src/components/app_bar.dart';
import 'package:flutter/material.dart';

class DonationInformationPage extends StatelessWidget {
  const DonationInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0), // Add padding here
        child: Text(
          'Más Info',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
