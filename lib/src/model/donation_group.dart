import 'package:equatable/equatable.dart';
import 'package:bamx_app/src/model/donacion_item.dart';

class DonationGroup extends Equatable {
  final int totalPoints;
  final DateTime donationDate;
  final List<DonacionItem> donationItems;

  const DonationGroup({
    required this.totalPoints,
    required this.donationDate,
    required this.donationItems,
  });

  @override
  List<Object> get props => [totalPoints, donationDate, donationItems];

  factory DonationGroup.fromMap(Map<String, dynamic> data) {
    return DonationGroup(
      totalPoints: data['totalPoints'],
      donationDate: data['donationDate'],
      donationItems: data['donationItems'],
    );
  }
}
