import 'package:equatable/equatable.dart';
import 'package:bamx_app/src/model/donacion_item.dart';

class DonationGroup extends Equatable {
  final String donationId;
  final String donationStatus;
  final int totalPoints;
  final DateTime donationDate;
  final List<DonacionItem> donationItems;

  const DonationGroup({
    required this.donationId,
    required this.donationStatus,
    required this.totalPoints,
    required this.donationDate,
    required this.donationItems,
  });

  @override
  List<Object> get props =>
      [donationId, totalPoints, donationDate, donationItems];

  factory DonationGroup.fromMap(
      String id, String status, Map<String, dynamic> data) {
    var donationItems = (data['donationsItems'] as List<dynamic>)
        .map((item) => DonacionItem.fromMap(item as Map<String, dynamic>))
        .toList();

    return DonationGroup(
      donationId: id,
      donationStatus: status,
      totalPoints: data['totalPoints'],
      donationDate: DateTime.parse(data['donationDate']),
      donationItems: donationItems,
    );
  }
}
