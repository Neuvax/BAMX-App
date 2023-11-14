import 'package:bamx_app/src/cubits/historial_cubit.dart';
import 'package:bamx_app/src/routes/routes.dart';
import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class PendingDonationsHome extends StatelessWidget {
  final HistorialState state;

  const PendingDonationsHome({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          itemCount: 2,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return const SizedBox(
              width: 300,
              child: Card(),
            );
          },
        ),
      );
    } else if (state.pendientes.isEmpty) {
      return const Center(
        child: Text(
          "No tienes donaciones pendientes",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: state.pendientes.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 300,
            child: Card(
              child: ListTile(
                  title: Text(
                    DateFormat('yyyy-MM-dd')
                        .format(state.pendientes[index].donationDate),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle:
                      Text("#${state.pendientes[index].donationId.toString()}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => Navigator.pushNamed(
                        context, Routes.donationInformationPage,
                        arguments: state.pendientes[index]),
                    color: MyColors.green,
                    iconSize: 30.0, // Set this to the size you want
                  )),
            ),
          );
        },
      );
    }
  }
}

// SizedBox(
//       width: 300,
//       child: Card(
//         child: ListTile(
//           title: const Text(
//             "12/12/2023",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           subtitle: const Text("#123456"),
//           trailing: IconButton(
//             icon: const Icon(Icons.chevron_right),
//             onPressed: () {},
//             color: MyColors.green,
//             iconSize: 30.0, // Set this to the size you want
//           )
//         ),
//       ),
//     );