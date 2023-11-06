import 'package:bamx_app/src/components/app_bar.dart';
import 'package:flutter/material.dart';

class DonationConformationPage extends StatelessWidget {
  const DonationConformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return DonationConformationPageUI(
      donationUID: arguments['donationUID'],
      donationCount: arguments['donationCount'],
      pointsAwarded: arguments['pointsAwarded'],
    );
  }
}

class DonationConformationPageUI extends StatelessWidget {
  final String donationUID;
  final int donationCount;
  final int pointsAwarded;
  const DonationConformationPageUI({super.key, required this.donationUID, required this.donationCount, required this.pointsAwarded});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: const SingleChildScrollView(
          child: Column(
            children: [

            ],
          )
        ),
      ),
    );
  }
}