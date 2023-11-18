import 'dart:async';

import 'package:bamx_app/main.dart';
import 'package:bamx_app/src/model/donation_group.dart';
import 'package:bamx_app/src/model/user_donations.dart';
import 'package:bamx_app/src/repository/donations_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistorialCubit extends Cubit<HistorialState> {
  final DonationRepository _historialRepository = getIt();
  StreamSubscription? _historialSubscription;

  HistorialCubit() : super(const HistorialState());

  Future<void> init() async {
    _historialSubscription =
        _historialRepository.getUserDonations().listen(historialListener);
  }

  void historialListener(UserDonations userDonations) {
    emit(HistorialState(
        isLoading: false,
        pendientes: userDonations.pendientes,
        aprobadas: userDonations.aprobadas,
        rechazadas: userDonations.rechazadas));
  }

  Future<(DonationGroup, String)?> getPublicDonation(String donationId) async {
    return _historialRepository.getPublicDonation(donationId);
  }

  @override
  Future<void> close() {
    _historialSubscription?.cancel();
    return super.close();
  }
}

class HistorialState extends Equatable {
  final bool isLoading;
  final List<DonationGroup> pendientes;
  final List<DonationGroup> aprobadas;
  final List<DonationGroup> rechazadas;

  const HistorialState({
    this.isLoading = true,
    this.pendientes = const [],
    this.aprobadas = const [],
    this.rechazadas = const [],
  });

  @override
  List<Object> get props => [isLoading, pendientes, aprobadas, rechazadas];

  HistorialState copyWith({
    bool? isLoading,
    List<DonationGroup>? pendientes,
    List<DonationGroup>? aprobadas,
    List<DonationGroup>? rechazadas,
  }) {
    return HistorialState(
      isLoading: isLoading ?? this.isLoading,
      pendientes: pendientes ?? this.pendientes,
      aprobadas: aprobadas ?? this.aprobadas,
      rechazadas: rechazadas ?? this.rechazadas,
    );
  }
}
