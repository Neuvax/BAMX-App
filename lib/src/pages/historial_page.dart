import 'package:bamx_app/src/routes/routes.dart';
import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:bamx_app/src/cubits/historial_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Step 2: Use BlocBuilder in the historial_page
// class HistorialPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HistorialCubit, List<UserDonation>>(
//       builder: (context, userDonations) {
//         return ListView.builder(
//           itemCount: userDonations.length,
//           itemBuilder: (context, index) {
//             final donation = userDonations[index];
//             return ListTile(
//               title: Text(donation.title),
//               onTap: () {
//                 // Step 3: Update the state when a donation item is clicked
//                 context.read<HistorialCubit>().selectDonation(donation);
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }

class HistorialPage extends StatelessWidget {
  const HistorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0), // Add padding here
      child: ListView(
        children: const <Widget>[
          DonationDateSection(date: 'Donaciones Pendientes'),
          DonationDateSection(date: 'Donaciones Pasadas'),
          DonationDateSection(date: 'Donaciones rechazadas'),
        ],
      ),
    ));
  }
}

class DonationDateSection extends StatelessWidget {
  final String date;

  const DonationDateSection({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            date,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const DonationItem(),
        const DonationItem(),
      ],
    );
  }
}

class DonationItem extends StatelessWidget {
  const DonationItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: const Text('Noviembre 10 2023', style: TextStyle(fontSize: 18)),
        subtitle: const Text('#owejkcwe'),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.donationInformationPage);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.green,
            foregroundColor: Colors.white,
          ),
          child: const Text(
            'Más Info',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
