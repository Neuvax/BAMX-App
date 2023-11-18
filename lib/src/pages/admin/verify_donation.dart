import 'package:bamx_app/src/cubits/historial_cubit.dart';
import 'package:bamx_app/src/model/donation_group.dart';
import 'package:bamx_app/src/pages/donation_information_page.dart';
import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyDonationPage extends StatefulWidget {
  final DonationGroup donationGroup;
  final String userId;
  const VerifyDonationPage(
      {super.key, required this.donationGroup, required this.userId});

  @override
  State<VerifyDonationPage> createState() => _VerifyDonationPageState();
}

class _VerifyDonationPageState extends State<VerifyDonationPage> {
  final List<bool> isSelected = [true, false];
  final List<String> options = ['Aprobar', 'Rechazar'];

  @override
  Widget build(BuildContext context) {
    return DonationInformationPage(
      donationGroup: widget.donationGroup,
      children: [
        const Text(
          '¿Desea aprobar o rechazar la donación?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24), // For spacing
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ToggleButtons(
              isSelected: isSelected,
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor:
                  isSelected[0] ? MyColors.green : MyColors.primary,
              selectedColor: Colors.white,
              fillColor: isSelected[0] ? MyColors.green : MyColors.primary,
              color: isSelected[1] ? MyColors.green : MyColors.primary,
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 100.0,
              ),
              children: options.map((String option) {
                return Text(option);
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 24),
        BlocProvider(
          create: (context) => HistorialCubit(),
          child: BlocBuilder<HistorialCubit, HistorialState>(
            builder: (context, state) => ElevatedButton(
              onPressed: () {
                context.read<HistorialCubit>().verifyDonation(
                    widget.donationGroup, widget.userId, isSelected[0]);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Donación ${isSelected[0] ? 'aprobada' : 'rechazada'}',
                    ),
                  ),
                );
                //Wait for the snackbar to finish
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Confirmar'),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
