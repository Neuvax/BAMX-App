import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bamx_app/src/cubits/reward_cubit.dart';
import 'package:bamx_app/src/cubits/points_cubit.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RewardCubit>(
          create: (context) => RewardCubit()..init(),
        ),
        BlocProvider<PointsCubit>(
          create: (context) => PointsCubit()..init(),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Mis Recompensas",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            BlocBuilder<PointsCubit, PointsState>(
              builder: (context, pointsState) {
                if (!pointsState.isLoading) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 16.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Mis Puntos: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${pointsState.points.puntos}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 150,
                            height: 50,
                            child: Card(),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
            BlocBuilder<RewardCubit, RewardState>(
              builder: (context, rewardState) {
                if (rewardState.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (rewardState.rewards.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: rewardState.rewards.length,
                      itemBuilder: (context, index) {
                        final reward = rewardState.rewards.elementAt(index);
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: Image.network(reward.imagen),
                              title: Text(
                                reward.nombre,
                                style: const TextStyle(fontSize: 18),
                              ),
                              subtitle: Text(
                                DateFormat('yyyy-MM-dd')
                                    .format(DateTime.parse(reward.rewardDate)),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
