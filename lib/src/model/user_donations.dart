import 'package:equatable/equatable.dart';
import 'package:bamx_app/src/model/donation_group.dart';

class UserDonations extends Equatable {
  final List<DonationGroup> pendientes;
  final List<DonationGroup> aprobadas;
  final List<DonationGroup> rechazadas;

  const UserDonations(
      {this.pendientes = const [],
      this.aprobadas = const [],
      this.rechazadas = const []});

  @override
  List<Object> get props => [pendientes, aprobadas, rechazadas];

  factory UserDonations.fromMap(Map<String, dynamic> data) {
    return UserDonations(
      pendientes: data['pendientes'],
      aprobadas: data['aprobadas'],
      rechazadas: data['rechazadas'],
    );
  }
}
