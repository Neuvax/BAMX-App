import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter/material.dart';

class PendingDonationsHome extends StatelessWidget {
  const PendingDonationsHome({super.key});

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