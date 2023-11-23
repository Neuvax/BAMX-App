import 'dart:async';

import 'package:bamx_app/main.dart';
import 'package:bamx_app/src/model/reward.dart';
import 'package:bamx_app/src/repository/rewards_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RewardCubit extends Cubit<RewardState> {
  final RewardsRepository _rewardsRepository = getIt();
  StreamSubscription? _rewardsSubscription;

  RewardCubit() : super(const RewardState());

  Future<void> init() async {
    _rewardsSubscription =
        _rewardsRepository.getRewards().listen(rewardsListener);
  }

  void rewardsListener(Iterable<Reward> rewards) {
    emit(RewardState(isLoading: false, rewards: rewards));
  }

  @override
  Future<void> close() {
    _rewardsSubscription?.cancel();
    return super.close();
  }
}

class RewardState extends Equatable {
  final bool isLoading;
  final Iterable<Reward> rewards;

  const RewardState({
    this.isLoading = true,
    this.rewards = const [],
  });

  @override
  List<Object> get props => [isLoading, rewards];

  RewardState copyWith({
    bool? isLoading,
    Iterable<Reward>? rewards,
  }) {
    return RewardState(
      isLoading: isLoading ?? this.isLoading,
      rewards: rewards ?? this.rewards,
    );
  }
}
