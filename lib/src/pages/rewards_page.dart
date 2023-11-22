import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                    return ListTile(
                      leading: Image.network(
                          reward.imagen), // Assuming this is a network image
                      title: Text(reward.nombre),
                      // Add trailing or onTap as needed
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
