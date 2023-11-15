import 'package:bamx_app/src/components/donaciones_home.dart';
import 'package:bamx_app/src/components/news_card.dart';
import 'package:bamx_app/src/components/pending_donations_home.dart';
import 'package:bamx_app/src/cubits/donaciones_cubit.dart';
import 'package:bamx_app/src/cubits/historial_cubit.dart';
import 'package:bamx_app/src/cubits/news_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 28),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "¡Bienvenido a BAMX App!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Esta aplicación te permite donar al Bancos de Alimentos de Jalisco de una manera fácil y segura.",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 28),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Noticias",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 28),
            BlocProvider(
              create: (context) => NewsCubit()..init(),
              child: SizedBox(
                height: 210,
                child: BlocBuilder<NewsCubit, NewsState>(
                  builder: (context, state) => NewsCard(state: state),
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Donaciones prioritarias",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Text(
              "Estas son las donaciones que más se necesitan en este momento ¡Obtén más puntos al donar estos productos!",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 28),
            BlocProvider(
              create: (context) => ListaDonacionesPrioritariasCubit()..init(),
              child: SizedBox(
                height: 150,
                child: BlocBuilder<ListaDonacionesPrioritariasCubit,
                    ListaDonacionesState>(
                  builder: (context, state) => DonacionesHome(state: state),
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Donaciones pendientes",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 28),
            BlocProvider(
              create: (context) => HistorialCubit()..init(),
              child: SizedBox(
                height: 80,
                child: BlocBuilder<HistorialCubit, HistorialState>(
                  builder: (context, state) => PendingDonationsHome(state: state),
                ),
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}
