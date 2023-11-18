import 'package:bamx_app/main.dart';
import 'package:bamx_app/src/data-source/firebase_data_source.dart';
import 'package:bamx_app/src/repository/donations_repository.dart';
import 'package:bamx_app/src/model/user_donations.dart';
import 'package:bamx_app/src/model/donation_group.dart';

class DonationsRepositoryImp extends DonationRepository {
  final FirebaseDataSource _firebaseDataSource = getIt();

  @override
  Stream<UserDonations> getUserDonations() {
    return _firebaseDataSource.getUserDonations();
  }

  @override
  Stream<Iterable<DonationGroup>> getUserPendingDonations() {
    return _firebaseDataSource.getUserPendingDonations();
  }

  @override
  Future<(DonationGroup, String)?> getPublicDonation(String donationId) {
    return _firebaseDataSource.getPublicDonation(donationId);
  }
}
