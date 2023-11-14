import 'package:bamx_app/src/cubits/historial_cubit.dart';
import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter/material.dart';

class PendingDonationsHome extends StatelessWidget {

  final HistorialState state;

  const PendingDonationsHome({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Card(
        child: ListTile(
          title: const Text(
            "12/12/2023",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: const Text("#123456"),
          trailing: IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {},
            color: MyColors.green,
            iconSize: 30.0, // Set this to the size you want
          )
        ),
      ),
    );
  }
}