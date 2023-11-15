import 'package:bamx_app/src/routes/routes.dart';
import 'package:bamx_app/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:bamx_app/src/cubits/historial_cubit.dart';
import 'package:bamx_app/src/model/donation_group.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistorialPage extends StatelessWidget {
  const HistorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistorialCubit()..init(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<HistorialCubit, HistorialState>(
          builder: (context, state) {
            // Comprobación si los arrays están vacíos
            if (state.pendientes.isEmpty &&
                state.aprobadas.isEmpty &&
                state.rechazadas.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "No hay donaciones existentes",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }

            if (!state.isLoading) {
              List<Widget> donationSections = [];

              if (state.pendientes.isNotEmpty) {
                donationSections.add(
                  DonationSection(
                    titulo: 'Donación Pendiente',
                    donations: state.pendientes,
                  ),
                );
              }

              if (state.aprobadas.isNotEmpty) {
                donationSections.add(
                  DonationSection(
                    titulo: 'Donación Aprobada',
                    donations: state.aprobadas,
                  ),
                );
              }

              if (state.rechazadas.isNotEmpty) {
                donationSections.add(
                  DonationSection(
                    titulo: 'Donación Rechazada',
                    donations: state.rechazadas,
                  ),
                );
              }

              return ListView(
                children: donationSections,
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class DonationSection extends StatelessWidget {
  final String titulo;
  final List<DonationGroup> donations;

  const DonationSection({
    super.key,
    required this.titulo,
    required this.donations,
  });

  @override
  Widget build(BuildContext context) {
    if (donations.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "No se encontraron donaciones",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            titulo,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...donations
            .map((donationGroup) => DonationItem(donationGroup: donationGroup))
            .toList(),
      ],
    );
  }
}

class DonationItem extends StatelessWidget {
  final DonationGroup donationGroup;

  const DonationItem({super.key, required this.donationGroup});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(
          'ID: ${donationGroup.donationId}',
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Text('Puntos Totales: ${donationGroup.totalPoints}'),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              Routes.donationInformationPage,
              arguments: donationGroup,
            );
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
