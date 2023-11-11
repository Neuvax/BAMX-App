import 'package:bamx_app/src/components/app_bar.dart';
import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DonationInformationPage extends StatelessWidget {
  const DonationInformationPage({super.key});

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
                  data: "ejrrgerh23462383H",
                  version: QrVersions.auto,
                  size: 215.0,
                ),
              ),
            ),
            const SizedBox(height: 24), // For spacing
            const Text(
              '#986736bs',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24), // For spacing
            Center(
              child: SizedBox(
                width: 150, // Define your preferred width
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        MyColors.primary, // Use your preferred color
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    foregroundColor:
                        Colors.white, // This is the button's text color
                  ),
                  onPressed: () {
                    // Handle button press
                  },
                  child: const Text('No entregado',
                      style: TextStyle(fontSize: 18)),
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
            const TextDetailRow(
                title: 'tenetur illo quia nulla',
                points: 'Puntos',
                quantity: 'Cantidad'),
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
