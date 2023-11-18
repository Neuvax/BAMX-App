import 'package:bamx_app/src/model/donation_group.dart';
import 'package:bamx_app/src/model/user_donations.dart';

abstract class DonationRepository {
  Stream<UserDonations> getUserDonations();
  Stream<Iterable<DonationGroup>> getUserPendingDonations();
  Future<DonationGroup?> getPublicDonation(String donationId);
}
