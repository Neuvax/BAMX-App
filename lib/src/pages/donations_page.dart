import 'package:bamx_app/src/components/donations_list.dart';
import 'package:bamx_app/src/cubits/donaciones_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DonationsPage extends StatelessWidget {
  const DonationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListaDonacionesCubit()..init(),
      child: BlocBuilder<ListaDonacionesCubit, ListaDonacionesState>(
        builder: (context, state) {
          //If the state is loading, show a progress indicator
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          //If there are no items, show a message
          else if (state.listaItemsDonaciones.isEmpty) {
            return const Center(
              child: Text("No hay donaciones disponibles"),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: DonationsList(title: "Artículos para donación",state: state),
            );
          }
        },
      )
    );
  }
}

