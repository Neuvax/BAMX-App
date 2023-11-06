import 'package:bamx_app/src/routes/routes.dart';
import 'package:flutter/material.dart';

class HistorialPage extends StatelessWidget {
  const HistorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.donationConfirmation, arguments: {
              'donationUID': '123456789',
              'donationCount': 5,
              'pointsAwarded': 10,
              'status': 'pending',
            });
          },
          child: const Text('Historial')),
    );
  }
}
