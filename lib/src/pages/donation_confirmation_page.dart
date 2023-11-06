import 'package:bamx_app/src/components/app_bar.dart';
import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DonationConformationPage extends StatelessWidget {
  const DonationConformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return DonationConformationPageUI(
      donationUID: arguments['donationUID'],
      donationCount: arguments['donationCount'],
      pointsAwarded: arguments['pointsAwarded'],
      status: arguments['status'],
    );
  }
}

class DonationConformationPageUI extends StatelessWidget {
  final String donationUID;
  final int donationCount;
  final int pointsAwarded;
  final String status;
  const DonationConformationPageUI(
      {super.key,
      required this.donationUID,
      required this.donationCount,
      required this.pointsAwarded,
      required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40.0),
            QrImageView(
              data: donationUID,
              version: QrVersions.auto,
              size: 215.0,
            ),
            const SizedBox(height: 20.0),
            const Text(
              '¡Muchas gracias por tu donación!',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              "#$donationUID",
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              donationCount == 1
                  ? "$donationCount item"
                  : "$donationCount items",
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10.0),
            StatusBadge(status: status),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Volver al inicio',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)),
            ),
          ],
        )),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status; // 'success' or 'failed' or 'pending'
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: status == 'success'
            ? MyColors.green
            : status == 'failed'
                ? Colors.red
                : MyColors.yellow,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        status == 'success'
            ? 'Donación exitosa'
            : status == 'failed'
                ? 'Donación rechazada'
                : 'Donación pendiente',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
