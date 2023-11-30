import 'dart:async';

import 'package:bamx_app/main.dart';
import 'package:bamx_app/src/model/user_points.dart';
import 'package:bamx_app/src/repository/points_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PointsCubit extends Cubit<PointsState> {
  final PointsRepository _pointsRepository = getIt();
  StreamSubscription? _pointsSubscription;

  PointsCubit() : super(const PointsState());

  Future<void> init() async {
    _pointsSubscription = _pointsRepository.getPoints().listen(pointsListener);
  }

  void pointsListener(UserPoints points) {
    emit(PointsState(isLoading: false, points: points));
  }

  @override
  Future<void> close() {
    _pointsSubscription?.cancel();
    return super.close();
  }
}

class PointsState extends Equatable {
  final bool isLoading;
  final UserPoints points;

  const PointsState({
    this.isLoading = true,
    this.points = const UserPoints(),
  });

  @override
  List<Object> get props => [isLoading, points];

  PointsState copyWith({
    bool? isLoading,
    UserPoints? points,
  }) {
    return PointsState(
      isLoading: isLoading ?? this.isLoading,
      points: points ?? this.points,
    );
  }
}
