import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bamx_app/src/utils/colors.dart';
import 'package:bamx_app/src/cubits/reward_cubit.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RewardCubit()..init(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<RewardCubit, RewardState>(
          builder: (context, state) {
            if (!state.isLoading) {
              if (state.rewards.isNotEmpty) {
                return ListView.builder(
                  itemCount: state.rewards.length,
                  itemBuilder: (context, index) {
                    final reward = state.rewards.elementAt(index);
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0), // Padding arriba y abajo
                        child: ListTile(
                          leading: Image.network(reward.imagen),
                          title: Text(
                            reward.nombre,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "No hay recompensas disponibles",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
