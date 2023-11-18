import 'package:bamx_app/src/cubits/historial_cubit.dart';
import 'package:bamx_app/src/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HistorialCubit()..init(),
      child: Center(
        child: Builder(
          // Using Builder here
          builder: (newContext) {
            // newContext can access HistorialCubit
            return SizedBox(
              height: 300,
              width: 300,
              child: MobileScanner(
                onDetect: (barcodes) {
                  newContext
                      .read<HistorialCubit>()
                      .getPublicDonation(barcodes.raw[0]["rawValue"])
                      .then((donation) {
                    if (donation != null) {
                      Navigator.pushNamed(
                          newContext, Routes.donationInformationPage,
                          arguments: donation);
                      //Close the scanner
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Donación no encontrada'),
                        ),
                      );
                    }
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
