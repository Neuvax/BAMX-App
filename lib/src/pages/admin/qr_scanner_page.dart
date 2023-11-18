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
  late MobileScannerController cameraController;
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController();
  }

  void toggleScanning() {
    setState(() {
      isScanning = !isScanning;
      if (isScanning) {
        cameraController.start();
      } else {
        cameraController.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HistorialCubit()..init(),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 300,
                width: 300,
                child: isScanning
                    ? Builder(builder: (newContext) {
                        return MobileScanner(
                          controller: cameraController,
                          onDetect: (barcodes) {
                            cameraController.stop();
                            newContext
                                .read<HistorialCubit>()
                                .getPublicDonation(barcodes.raw[0]["rawValue"])
                                .then((donation) {
                              if (donation != null) {
                                toggleScanning();
                                Navigator.pushNamed(
                                    newContext, Routes.verifyDonation,
                                    arguments: {
                                      'donationGroup': donation.$1,
                                      'userId': donation.$2
                                    });
                              } else {
                                toggleScanning();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Donación no encontrada'),
                                  ),
                                );
                              }
                            });
                          },
                        );
                      })
                    : const SizedBox(width: 300, height: 300,)
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: toggleScanning,
                child: Text(isScanning ? 'Detener escaneo' : 'Empezar a escanear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
