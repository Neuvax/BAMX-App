import 'package:bamx_app/src/components/app_bar.dart';
import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:bamx_app/src/model/donation_group.dart';

class DonationInformationPage extends StatelessWidget {
  final DonationGroup donationGroup;

  const DonationInformationPage({Key? key, required this.donationGroup})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0), // Add padding on top
              child: Center(
                child: QrImageView(
                  data: donationGroup.donationId.toString(),
                  version: QrVersions.auto,
                  size: 215.0,
                ),
              ),
            ),
            const SizedBox(height: 24), // For spacing
            Text(
              '#${donationGroup.donationId.toString()}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24), // For spacing
            Center(
              child: Container(
                width: 140, // Define your preferred width
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  color: MyColors.primary, // Use your preferred color
                  borderRadius: BorderRadius.circular(100), // Rounded corners
                ),
                child: Text(
                  donationGroup.donationStatus,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24), // For spacing
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Articulos Donados',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ), // For spacing
            // Add your text details here
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: donationGroup.donationItems.length,
              itemBuilder: (context, index) {
                final donacionItem = donationGroup.donationItems[index];
                return TextDetailRow(
                  title: donacionItem.name,
                  points: '${donacionItem.puntos}',
                  quantity: '${donacionItem.cantidad}',
                );
              },
            ),
            // Repeat TextDetailRow for each entry
          ],
        ),
      ),
    );
  }
}

class TextDetailRow extends StatelessWidget {
  final String title;
  final String points;
  final String quantity;

  const TextDetailRow({
    Key? key,
    required this.title,
    required this.points,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(quantity, style: const TextStyle(fontSize: 16)),
          Text(points,
              style: const TextStyle(
                  fontSize: 16,
                  color: MyColors.green,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
