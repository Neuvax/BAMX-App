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
  final TextEditingController _donationId = TextEditingController();

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
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
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
                                    .getPublicDonation(
                                        barcodes.raw[0]["rawValue"])
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
                        : Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                          )),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: toggleScanning,
                  child: Text(
                      isScanning ? 'Detener escaneo' : 'Empezar a escanear'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'O ingrese el código de la donación',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    controller: _donationId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Código de la donación',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<HistorialCubit, HistorialState>(
                  builder: (context, state) => ElevatedButton(
                    onPressed: () {
                      context
                          .read<HistorialCubit>()
                          .getPublicDonation(_donationId.text)
                          .then((donation) {
                        if (donation != null) {
                          Navigator.pushNamed(context, Routes.verifyDonation,
                              arguments: {
                                'donationGroup': donation.$1,
                                'userId': donation.$2
                              });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Donación no encontrada'),
                            ),
                          );
                        }
                      });
                    },
                    child: const Text('Verificar donación'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
