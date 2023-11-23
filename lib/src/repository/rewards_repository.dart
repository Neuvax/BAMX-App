import 'package:bamx_app/src/model/reward.dart';

abstract class RewardsRepository {
  Stream<Iterable<Reward>> getRewards();
}
