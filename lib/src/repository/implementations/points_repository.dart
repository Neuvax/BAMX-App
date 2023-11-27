import 'package:bamx_app/main.dart';
import 'package:bamx_app/src/data-source/firebase_data_source.dart';
import 'package:bamx_app/src/model/user_points.dart';
import 'package:bamx_app/src/repository/points_repository.dart';

class PointsRepositoryImpl extends PointsRepository {
  final FirebaseDataSource _firebaseDataSource = getIt();

  @override
  Stream<UserPoints> getPoints() {
    return _firebaseDataSource.getPoints();
  }
}
