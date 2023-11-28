import 'package:bamx_app/main.dart';
import 'package:bamx_app/src/data-source/firebase_data_source.dart';
import 'package:bamx_app/src/model/reward.dart';
import 'package:bamx_app/src/repository/rewards_repository.dart';

class RewardsRepositoryImpl extends RewardsRepository {
  final FirebaseDataSource _firebaseDataSource = getIt();

  @override
  Stream<Iterable<Reward>> getRewards() {
    return _firebaseDataSource.getRewards();
  }
}
