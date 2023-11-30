import 'package:bamx_app/src/model/user_points.dart';

abstract class PointsRepository {
  Stream<UserPoints> getPoints();
}
