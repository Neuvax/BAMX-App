import 'package:bamx_app/src/components/donations_list.dart';
import 'package:bamx_app/src/cubits/donaciones_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DonationsPage extends StatelessWidget {
  const DonationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ListaDonacionesPrioritariasCubit>(
          create: (context) => ListaDonacionesPrioritariasCubit()..init(),
        ),
        BlocProvider<ListaDonacionesCubit>(
          create: (context) => ListaDonacionesCubit()..init(),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: <Widget>[
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Donaciones prioritarias",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "Estas son las donaciones que más se necesitan en este momento ¡Obtén dobles puntos al donar estos artículos!",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<ListaDonacionesPrioritariasCubit,
                ListaDonacionesState>(
              builder: (context, state) => DonationList(state: state),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Otros artículos para donar",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            BlocBuilder<ListaDonacionesCubit, ListaDonacionesState>(
              builder: (context, state) => DonationList(state: state),
            ),
          ],
        ),
      ),
    );
  }
}
